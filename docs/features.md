---
title: Features
description: A walkthrough of each LM+ Locator feature, screen by screen, with source file references.
---

## 1. Office & mailbox locator (main feature)

The Locator tab ([HomeScreen](../lib/screens/home_screen.dart)) has several states, tracked by an internal `_LocatorStatus` enum: `idle`, `loading`, `results`, and a few error states (`permissionDenied`, `permissionPermanentlyDenied`, `serviceDisabled`, `error`).

### Hero screen (`idle`)

The starting screen, showing the app logo, tagline, and two ways to search:

- **"Mijn locatie gebruiken" (find nearest)**: calls `_findNearestOffices()`, which:
  1. Checks/requests location permission via [LocationService.checkPermission()](../lib/services/location_service.dart)
  2. If granted, shows results for the **last known position** immediately (if any) for instant feedback, then fetches a fresh GPS fix and updates the results and the "your location" label (via reverse geocoding)
  3. On permission/GPS issues, shows a dedicated info screen with a button to open the relevant system settings
- **"Zoek op adres" (search by address)**: opens [AddressSearchSheet](../lib/widgets/address_search_sheet.dart), a bottom sheet with a text field that shows live suggestions (debounced, via Nominatim) as the user types, or geocodes the typed address on submit. When the device is offline the field immediately shows an inline error and the search button is disabled, since address lookup requires a network call to Nominatim. See [§ Offline-first banner](#6-offline-first-banner).

### Results screen (`results`)

Shows:

- The resolved "your location" text
- A "change location" button, returning to the hero screen (`_changeLocation()`)
- A text field that filters the current results by name, street, or house number ([OfficeService.filterByText()](../lib/services/office_service.dart)). Matching is case- and diacritic-insensitive and requires every word of a multi-word query to match, but does no network call and preserves the existing distance order. This narrows what's already on screen; it's not a way to search the full office list independently of a GPS/address search.
- A segmented control to filter between **Offices** and **Mailboxes** (`OfficeType`), whose counts reflect the active text filter
- A paginated list of [OfficeCard](../lib/widgets/office_card.dart)s, sorted by distance (loaded 10 at a time as the user scrolls, via `_onScroll`)
- An empty-state message when the current type/text filter combination matches nothing

Each `OfficeCard` shows the office's name, distance, open/closed status (if opening hours are known), address, and phone number, and opens the location in Google/Apple Maps when tapped. A bookmark icon in the name row saves the office to the Saved tab (see [§ Saved offices](#2-saved-offices)). If the office has opening hours data, a "View opening hours" button appears at the bottom of the card.

### Opening hours panel

Tapping "View opening hours" on a card that has hours data opens [OpeningHoursSheet](../lib/widgets/opening_hours_sheet.dart), a modal bottom sheet showing the full weekly schedule:

- Days are displayed Monday to Sunday (the data model uses 0 = Sunday … 6 = Saturday, matching the source site's convention; the sheet remaps this to Monday-to-Sunday display order internally)
- Today's row is highlighted in the theme's primary colour with bold text
- Time slots are shown in `HH:mm` format; days with no slots show "Closed"
- The button only appears on cards where `office.openingHours != null`

### Back navigation

A `PopScope` ensures the system back button returns to the hero screen from any non-idle state, rather than closing the app outright.

### Distance calculation

[OfficeService.nearestOffices()](../lib/services/office_service.dart) sorts the bundled office list by straight-line (haversine) distance to the user's coordinates. See [data-pipeline.md](data-pipeline.md) for where that office list comes from.

## 2. Saved offices

The Saved tab ([FavoritesScreen](../lib/screens/favorites_screen.dart)) shows all bookmarked offices in the same [OfficeCard](../lib/widgets/office_card.dart) format as the Locator results, without a distance (no GPS search is active here).

Bookmarking is done via the bookmark icon in the top-right corner of any office card: in the Locator results, in the Saved tab itself, or anywhere else a card appears. The icon reacts instantly across the whole app because [FavoritesService](../lib/services/favorites_service.dart) exposes a `ValueNotifier<Set<String>>` that every card subscribes to.

### Persistence

Favorites are stored in two layers:

- **Local** (`shared_preferences`): saved on every change, works fully offline and without an account
- **Cloud** (Firestore `userFavorites/{uid}`): synced when a user is signed in

On sign-in, cloud favorites are merged additively with any locally stored ones, so offices bookmarked before creating an account are never lost. On sign-out, the current set is flushed back to local storage before the cloud reference is released. All Firestore writes are best-effort (`try/catch`), so a network hiccup cannot break the local experience.

### Empty state

When no offices are saved, the tab shows an empty-state illustration with a prompt explaining how to use the bookmark icon on any office card.

## 3. Account (optional sign-in)

Settings → **Account** opens [AccountSheet](../lib/widgets/account_sheet.dart):

- If signed out: an email/password login form, with a toggle to switch to registration (`_isRegisterMode`)
- If signed in: shows the account's email, creation date, account ID, and a "log out" button (with a confirmation dialog)

Backed by [AuthService](../lib/services/auth_service.dart) (Firebase Auth). Entirely optional: none of the locator or saved-offices features require an account. Signing in adds one benefit: favorites sync to Firestore, so they survive reinstalls and transfer across devices.

## 4. Settings

The settings icon in the app bar ([SettingsSelector](../lib/widgets/settings_selector.dart)) opens one sheet containing:

- **Account** entry → opens the Account sheet above
- **Privacy notice** entry → explains the app's use of location data
- **Language** picker (nl/fr/de/en) → persisted via `LocaleService`
- **Theme** picker (system/light/dark) → persisted via `ThemeService`
- App version + a note that this is an unofficial app

The app bar also has a head-office info button ([HeadOfficeInfoButton](../lib/widgets/head_office_info_button.dart)), showing LM Oost-Vlaanderen's contact details from [HeadOffice](../lib/models/head_office.dart), with tap-to-call/email/website links.

## 5. Send Document (experimental)

The third bottom-nav tab ([SendDocumentScreen](../lib/screens/send_document_screen.dart)) lets the user:

1. Take a photo of a document with the camera (`image_picker`)
2. Preview it, with the option to retake
3. Send it by email (`flutter_email_sender`), which opens the device's native Mail compose screen with the recipient, subject, and the photo already attached, ready for the user to review and send

## 6. Offline-first banner

[OfflineBanner](../lib/widgets/offline_banner.dart) sits at the top of every tab, just below the app bar. It slides in smoothly (via `AnimatedSize`) when the device loses internet connectivity and slides back out when connectivity returns.

The banner reads **"Offline — GPS search still works"**, and it means what it says. Office data is bundled in the app (`assets/lm_offices.json`) and GPS is a hardware feature independent of the internet, so the Locator tab works fully offline. What doesn't work offline:

- **Address search**: requires a network call to Nominatim (OpenStreetMap's geocoding server). The [AddressSearchSheet](../lib/widgets/address_search_sheet.dart) detects offline state via `ConnectivityService` and shows an inline error *"Offline — only GPS search available"* as soon as the user starts typing, rather than letting them submit and receive a misleading "address not found" message.
- **Favorites cloud sync**: Firestore writes are skipped when offline; local favorites still work normally and will sync the next time the device is online and the user is signed in.

Connectivity is tracked by [ConnectivityService](../lib/services/connectivity_service.dart), a thin wrapper around the `connectivity_plus` plugin that exposes a `Stream<bool>` (`onlineStream`). The banner uses `initialData: true` so it never incorrectly flashes "offline" on cold start before the first connectivity check resolves.

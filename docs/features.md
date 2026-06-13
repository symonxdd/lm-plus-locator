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
- **"Zoek op adres" (search by address)**: opens [AddressSearchSheet](../lib/widgets/address_search_sheet.dart), a bottom sheet with a text field that shows live suggestions (debounced, via Nominatim) as the user types, or geocodes the typed address on submit

### Results screen (`results`)

Shows:

- The resolved "your location" text
- A "change location" button, returning to the hero screen (`_changeLocation()`)
- A segmented control to filter between **Offices** and **Mailboxes** (`OfficeType`)
- A paginated list of [OfficeCard](../lib/widgets/office_card.dart)s, sorted by distance (loaded 10 at a time as the user scrolls, via `_onScroll`)

Each `OfficeCard` shows the office's name, distance, open/closed status (if opening hours are known), address, and phone number, and opens the location in Google/Apple Maps when tapped.

### Back navigation

A `PopScope` ensures the system back button returns to the hero screen from any non-idle state, rather than closing the app outright.

### Distance calculation

[OfficeService.nearestOffices()](../lib/services/office_service.dart) sorts the bundled office list by straight-line (haversine) distance to the user's coordinates. See [data-pipeline.md](data-pipeline.md) for where that office list comes from.

## 2. Account (optional sign-in)

Settings → **Account** opens [AccountSheet](../lib/widgets/account_sheet.dart):

- If signed out: an email/password login form, with a toggle to switch to registration (`_isRegisterMode`)
- If signed in: shows the account's email and a "log out" button (with a confirmation dialog)

Backed by [AuthService](../lib/services/auth_service.dart) (Firebase Auth). Entirely optional: none of the locator features require an account.

## 3. Settings

The settings icon in the app bar ([SettingsSelector](../lib/widgets/settings_selector.dart)) opens one sheet containing:

- **Account** entry → opens the Account sheet above
- **Privacy notice** entry → explains the app's use of location data
- **Language** picker (nl/fr/de/en) → persisted via `LocaleService`
- **Theme** picker (system/light/dark) → persisted via `ThemeService`
- App version + a note that this is an unofficial app

The app bar also has a head-office info button ([HeadOfficeInfoButton](../lib/widgets/head_office_info_button.dart)), showing LM Oost-Vlaanderen's contact details from [HeadOffice](../lib/models/head_office.dart), with tap-to-call/email/website links.

## 4. Photo Share (experimental)

The second bottom-nav tab ([PhotoShareScreen](../lib/screens/photo_share_screen.dart)) lets the user:

1. Take a photo with the camera (`image_picker`)
2. Preview it, with the option to retake
3. Share it via the OS share sheet (`share_plus`), e.g. to email it to an LM+ office

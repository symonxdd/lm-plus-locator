---
title: Architecture
description: Tech stack, app shell and navigation, theming, localization, persistence, and Firebase/auth for LM+ Locator.
---

## Why Flutter?

This app is a small, single-developer side project that still needs to run well on both Android and iOS, talk to the device's camera/GPS, and support four languages and light/dark theming, all without becoming a maintenance burden. Flutter was a good fit for a few reasons:

- **One codebase, two app stores.** The bulk of the UI, navigation, and business logic (locator search, distance sorting, opening-hours logic) is written once and ships to Android and iOS alike, with no Kotlin/Swift code to keep in sync.
- **Everything this app needs is "off the shelf".** Location (`geolocator`), reverse geocoding (`geocoding`), runtime permissions (`permission_handler`), camera + share sheet (`image_picker`, `share_plus`), local persistence (`shared_preferences`), and auth (`firebase_auth`) are all mature, well-maintained plugins, so no custom native modules were needed anywhere.
- **Material 3 + localization come built in.** `flutter_localizations` plus ARB files gave nl/fr/de/en support with generated, type-safe accessors (`l10n.xxx`), and Material 3 theming (`ColorScheme.fromSeed`, `InputDecorationTheme`, etc.) made consistent light/dark styling straightforward.
- **Hot reload makes UI iteration fast.** Tweaking layouts, theming, or copy and seeing the result in under a second is a big productivity win for the kind of UI-polish work this app gets a lot of.
- **Dart is a pleasant, statically-typed language** with good null-safety and tooling (`flutter analyze`, DevTools), and a single language for the whole app is simpler than context-switching between platforms.
- **Backed by Google, with a large plugin ecosystem**, which helps with long-term viability and community support for a project that may sit untouched for stretches between updates.

The main trade-off is the debug-mode performance overhead discussed in the README's "Build modes" section, but for development that's a worthwhile trade for the iteration speed, and it disappears entirely in release builds.

## Tech stack

- **Flutter** (Material 3): UI framework, targeting Android and iOS
- **Firebase Auth**: optional email/password sign-in
- **geolocator** / **geocoding** / **permission_handler**: device location and reverse geocoding
- **Nominatim (OpenStreetMap)**: free address-search/autocomplete API, called directly via `http`
- **shared_preferences**: persisting the user's theme and language choice
- **image_picker** / **share_plus**: camera capture and OS share sheet (Photo Share tab)
- **flutter_localizations** + ARB files: translations for nl/fr/de/en

No external state-management package is used. Screens are `StatefulWidget`s using `setState`, since the app's state is simple and mostly screen-local.

## App shell & navigation

`main.dart` builds a single `MaterialApp` whose `home` is `RootScreen`.

[RootScreen](../lib/screens/root_screen.dart) is the only "real" screen with a `Navigator` route. It shows an `AppBar` (with the head-office info and settings buttons) and a bottom `NavigationBar` switching between two tabs via `IndexedStack`:

1. **Locator**: `HomeScreen`
2. **Photo Share**: `PhotoShareScreen`

Both tabs are kept alive in the `IndexedStack`, so switching tabs doesn't reset their state.

Everything else (address search, account, settings, info sheets) is a **modal bottom sheet** opened with `showModalBottomSheet`, not a pushed route. Because of this:

- Sheets that contain a focusable `TextField` (address search, login/register) must manually pad themselves by `MediaQuery.of(context).viewInsets.bottom` so the keyboard doesn't cover the input. `showModalBottomSheet` does **not** do this automatically. See [AddressSearchSheet](../lib/widgets/address_search_sheet.dart) and [AccountSheet](../lib/widgets/account_sheet.dart).
- `HomeScreen` itself has multiple "screens" (hero / loading / results / error) inside one widget, switched via an internal `_LocatorStatus` enum. A `PopScope` intercepts the system back button so that, from any non-idle state, back returns to the hero screen first instead of leaving the app. See [home_screen.dart](../lib/screens/home_screen.dart).

## Theming

[lib/theme/app_theme.dart](../lib/theme/app_theme.dart) defines `AppTheme.light` / `AppTheme.dark`, both Material 3 `ThemeData` built from a single seed color (`Colors.blue`). It also defines:

- A shared `InputDecorationTheme` giving all text fields a filled, rounded, borderless-at-rest look (a colored border appears on focus/error).
- `systemOverlayStyle(theme)`: keeps the Android status/navigation bar icons legible and the nav bar tinted to match the app's surface color, for the edge-to-edge layout enabled in `main.dart`.

[lib/theme/app_colors.dart](../lib/theme/app_colors.dart) defines `ctaColors(context)`, the background/foreground color pair used for the app's primary "call to action" buttons (navy in light mode, sky blue in dark mode, the two colors from the app icon).

`main.dart` picks `AppTheme.light` or `AppTheme.dark` based on the resolved `ThemeMode` (system/light/dark), persisted via `ThemeService`.

## Localization

Translations live as ARB files in `lib/l10n/` (`app_nl.arb`, `app_en.arb`, `app_fr.arb`, `app_de.arb`); the `app_localizations*.dart` files are generated from these by `flutter gen-l10n` (triggered automatically on build via `generate: true` in `pubspec.yaml`).

Dutch (`nl`) is the fallback if the device language isn't one of the four supported. The user can also pick a language manually via Settings, persisted by `LocaleService`.

## Persistence

Two tiny services wrap `shared_preferences`:

- [LocaleService](../lib/services/locale_service.dart): the manually-selected app language
- [ThemeService](../lib/services/theme_service.dart): the manually-selected theme mode

Both default to "follow the device" (`null` locale / `ThemeMode.system`) until the user picks something in Settings.

## Firebase / Auth

`main.dart` initializes Firebase using `firebase_options.dart` (generated by the FlutterFire CLI). [AuthService](../lib/services/auth_service.dart) is a thin wrapper around `FirebaseAuth` for email/password sign-in and registration, used by [AccountSheet](../lib/widgets/account_sheet.dart). An account is entirely optional. The locator works fully signed out.

### Why the Firebase config files are committed

`lib/firebase_options.dart`, `android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist`, and `firebase.json` are checked into this repo on purpose. They are not secrets, per Firebase's own documentation.

[Firebase docs: Learn about using and managing API keys for Firebase](https://firebase.google.com/docs/projects/api-keys):

> API keys for Firebase services are not used to control access to backend resources; that can only be done with Firebase Security Rules [...] If your app's setup follows the [...] guidelines, then API keys restricted to Firebase services do not need to be treated as secrets, and it's safe to include them in your code or configuration files.

[Firebase docs: Get started with Firebase in your Flutter project](https://firebase.google.com/docs/flutter/setup), specifically about `firebase_options.dart`:

> This Firebase config file contains unique, but non-secret identifiers for each platform you selected.

#### Checking this project against the "if your app's setup follows the guidelines" condition

The API keys page lists four guidelines before saying a key doesn't need to be treated as a secret. Going through each one for this project:

1. **Public by design**: an API key only identifies the project and app; authorization is handled by Google Cloud IAM, Firebase Security Rules, and Firebase App Check, not by the key itself. Nothing to configure, this is just how Firebase works.
2. **Apply restrictions**: Firebase-provisioned API keys are automatically restricted to Firebase-related APIs. Nothing in this project changes that default.
3. **Use the key only for Firebase services**: this app's only Firebase/Google dependencies are `firebase_core` and `firebase_auth`. Address lookups use the device's built-in geocoder (`geocoding` package) and "open in Maps" uses `url_launcher` to open a URL, neither uses this API key, and there's no Google Maps, Places, or Gemini API anywhere in this project that could share it.
4. **Security Rules and App Check are critical for Realtime Database, Cloud Firestore, and Cloud Storage**: this app uses none of those, so there's nothing to lock down here.

This project's setup matches all four, so the Firebase config files can stay in version control, including now that the repo is public.

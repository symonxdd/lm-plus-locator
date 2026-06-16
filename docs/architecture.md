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
- **Cloud Firestore**: cloud storage for saved-office favorites, synced per authenticated user
- **geolocator** / **geocoding** / **permission_handler**: device location and reverse geocoding
- **Nominatim (OpenStreetMap)**: free address-search/autocomplete API, called directly via `http`
- **shared_preferences**: persisting the user's theme, language choice, and offline favorites cache
- **connectivity_plus**: network-state stream powering the offline banner
- **image_picker** / **share_plus**: camera capture and OS share sheet (Photo Share tab)
- **flutter_localizations** + ARB files: translations for nl/fr/de/en

No external state-management package is used. Screens are `StatefulWidget`s using `setState`; cross-screen reactive state (favorites) uses `ValueNotifier`.

## App shell & navigation

`main.dart` builds a single `MaterialApp` whose `home` is `RootScreen`.

[RootScreen](../lib/screens/root_screen.dart) is the only "real" screen with a `Navigator` route. It shows an `AppBar` (with the head-office info and settings buttons), an [OfflineBanner](../lib/widgets/offline_banner.dart) that slides in when the device loses connectivity, and a bottom `NavigationBar` switching between three tabs via `IndexedStack`:

1. **Locator**: `HomeScreen`
2. **Saved**: `FavoritesScreen`
3. **Photo Share**: `PhotoShareScreen`

All tabs are kept alive in the `IndexedStack`, so switching tabs doesn't reset their state.

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

Translations live as four ARB files in `lib/l10n/`: `app_nl.arb`, `app_en.arb`, `app_fr.arb`, and `app_de.arb`.

### What is ARB?

ARB stands for **Application Resource Bundle**, the file format Flutter uses for localizations. Each ARB file is a JSON file mapping string keys to their translated values. The `app_nl.arb` (Dutch) file is the **source-of-truth template**: it contains both the translations *and* `@key` metadata entries that describe each string (translator context, placeholder argument types, etc.). The three other files contain only the translated values, with no metadata.

Example snippet from `app_nl.arb`:

```json
"offlineBannerMessage": "Offline — zoeken via GPS werkt nog",
"@offlineBannerMessage": {
  "description": "Banner shown at the top of the screen when the device is offline."
},
"distanceInKm": "{distance} km",
"@distanceInKm": {
  "description": "Distance label shown on an office card.",
  "placeholders": {
    "distance": { "type": "String" }
  }
}
```

### Code generation

Running `flutter gen-l10n` (or simply building the app, because `generate: true` is set in `pubspec.yaml`) reads all four ARB files and produces:

- `lib/l10n/app_localizations.dart`: the abstract `AppLocalizations` class with a getter for every key
- Per-locale subclasses (e.g. `app_localizations_nl.dart`) with the actual translated strings

In code, strings are accessed via `AppLocalizations.of(context)!.someKey`, fully type-safe: a missing translation key is a compile-time error, not a runtime surprise.

**Adding a new string** means: add it to `app_nl.arb` with its `@metadata` entry, add the translated value to the other three ARB files, then rebuild. `flutter gen-l10n` generates the type-safe accessor automatically.

Dutch (`nl`) is the fallback locale if the device language isn't one of the four supported. The user can also pick a language manually via Settings, persisted by `LocaleService`.

## Persistence

Three services handle persistent state:

- [LocaleService](../lib/services/locale_service.dart): the manually-selected app language, written to `shared_preferences`
- [ThemeService](../lib/services/theme_service.dart): the manually-selected theme mode, written to `shared_preferences`
- [FavoritesService](../lib/services/favorites_service.dart): the set of bookmarked offices

Both locale and theme default to "follow the device" (`null` locale / `ThemeMode.system`) until the user picks something in Settings.

`FavoritesService` is a singleton with a `ValueNotifier<Set<String>> favorites` that widgets subscribe to. The key for each office is `"${office.lat},${office.lng}"`, a stable identifier derived from the bundled JSON. Persistence works in two layers:

- **Local** (`shared_preferences`): always written on every change, so favorites survive offline use and work for signed-out users.
- **Cloud** (Firestore `userFavorites/{uid}`): written and read when a user is signed in. On sign-in, cloud favorites are merged (additive) with any locally stored ones, so bookmarks made offline are never lost. On sign-out, the latest set is flushed to local storage before the cloud reference is released. All Firestore operations are fire-and-forget (best-effort, wrapped in `try/catch`) so a network hiccup can't break the local experience.

### Firestore data model

Firestore organizes data in three nested levels:

| Term | Plain synonym | What it is in this app |
|---|---|---|
| **Collection** | Folder / table | `userFavorites` — one collection for all users |
| **Document** | Row / file | One document per signed-in user, identified by their Firebase Auth UID (e.g. `r8nB7Qly…`) |
| **Field** | Column / property | `keys` — an array of `"lat,lng"` strings, one per bookmarked office |

The full path to any user's favorites is `userFavorites/{uid}`, which is also what the security rules use (`match /userFavorites/{userId}`) to ensure each user can only access their own document.

The Firebase Console's Data tab shows this as three side-by-side columns (database → collection → document) and updates in real time via a live WebSocket connection, so bookmarks tapped in the app appear in the Console instantly without any manual refresh.

## Firebase / Auth

`main.dart` initializes Firebase using `firebase_options.dart` (generated by the FlutterFire CLI), then calls `FavoritesService.instance.initialize()` to load any cached favorites before the first frame. [AuthService](../lib/services/auth_service.dart) is a thin wrapper around `FirebaseAuth` for email/password sign-in and registration, used by [AccountSheet](../lib/widgets/account_sheet.dart). An account is entirely optional; signing in adds one benefit: favorites sync to the cloud so they survive reinstalls and transfer across devices.

### Session persistence

Staying signed in across app restarts is handled entirely by the `firebase_auth` SDK, not by any code in this project. On sign-in/registration, the SDK writes a refresh token to the platform's secure storage (Android Keystore-backed storage, iOS Keychain). On every app launch, it silently reads that token and exchanges it for a fresh session before `FirebaseAuth.instance.currentUser` is even read.

[AccountSheet](../lib/widgets/account_sheet.dart)'s `StreamBuilder<User?>` listens to `authStateChanges` (with `initialData: authService.currentUser`), so it reflects the restored session as soon as it builds.

The session lasts until the user signs out, deletes their account, or the refresh token is revoked (password change, manual revocation in the Firebase console, app data cleared/uninstalled).

### Firestore setup (one-time, per developer machine)

The security rules file (`firestore.rules`) lives in the repo root and is the access-control mechanism for the cloud favorites feature. It must be deployed separately; committing it to git does **not** push it to Firebase automatically. Two CLI commands are needed:

1. **Select the active Firebase project** (only needed once per machine, or after `firebase logout`):

   ```bash
   firebase use lm-plus-locator
   ```

2. **Deploy the security rules**:

   ```bash
   firebase deploy --only firestore:rules
   ```

   This reads `firestore.rules` and uploads it to the Firestore service. Until this is done (or if the rules are accidentally overwritten in the console), all Firestore reads and writes will fail with `PERMISSION_DENIED`.

Before running either command, the Firestore database itself must exist. If starting from a fresh Firebase project, create it first: Firebase Console → Build → Firestore Database → Create database → choose region `europe-west1 (Belgium)` → production mode.

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
4. **Security Rules and App Check are critical for Realtime Database, Cloud Firestore, and Cloud Storage**: this app now uses Cloud Firestore (for favorites sync). The `firestore.rules` file in the repo root locks the database down so that only an authenticated user can read or write their own `userFavorites/{uid}` document; all other paths are denied. These rules are deployed alongside the app and are the actual access-control mechanism; the API key in `firebase_options.dart` plays no role in enforcing them.

This project's setup matches all four, so the Firebase config files can stay in version control.

## Known Android log noise

When running the app on Android in debug mode, the logcat output contains recurring warnings that look alarming but are harmless. This section documents the most common ones.

### `E/GoogleApiManager: Failed to get service from broker`

Full logcat output:

```
E/GoogleApiManager: Failed to get service from broker.
E/GoogleApiManager: java.lang.SecurityException: Unknown calling package name 'com.google.android.gms'.
```

**What GMS is**: GMS stands for **Google Mobile Services**, the proprietary suite of Google apps and APIs that ship on most Android devices (Play Store, Play Services, Maps, Firebase, etc.). The `com.google.android.gms` package is Google Play Services specifically: the background process that Firebase, geolocator, and many other Flutter plugins communicate with on Android.

**What this error actually is**: This is GMS failing to connect to one of its own internal broker services. It is an IPC (inter-process communication) fault entirely within Google's own code; no line in this stack trace refers to `me.symon.lmplusLocator`, and no app-level code calls `GoogleApiManager` directly.

**Is it harmful?** No. The logcat line immediately after the exception confirms it:

```
W/GoogleApiManager: Not showing notification since connectionResult is not user-facing
```

GMS itself classifies this failure as invisible to users and requiring no action. It is a known, logged-by-Google issue that appears in debug builds across a large number of Flutter + Firebase projects, on both physical devices and emulators. It has been confirmed as harmless by the Flutter team, the FlutterFire team, and Google's own issue tracker:

- [flutter/flutter#178332](https://github.com/flutter/flutter/issues/178332) (Flutter issue tracker)
- [firebase/flutterfire#13440](https://github.com/firebase/flutterfire/issues/13440) (FlutterFire issue)
- [firebase/flutterfire#13485](https://github.com/firebase/flutterfire/issues/13485) (FlutterFire issue)
- [Google Issue Tracker #397255623](https://issuetracker.google.com/issues/397255623)
- [Google Issue Tracker #376437033](https://issuetracker.google.com/issues/376437033)

### `W/FlagRegistrar` / `W/FlagStore`: Phenotype API not available

GMS uses an internal feature-flagging system called **Phenotype** to remotely configure its own behaviour. In development environments (and on some devices), this system isn't reachable, so GMS logs a warning when it can't fetch flag updates. This has no effect on the app.

### `Skipped N frames!`

Android's Choreographer logs this when the main thread takes more than 16 ms between frames (the 60 fps budget). In debug builds, Flutter's JIT compiler, Firebase initialization, and `FavoritesService.initialize()` all run on the first launch frame, causing measurable startup-frame skips. This disappears entirely in release builds, where Dart is compiled ahead-of-time (AOT) with no JIT overhead.

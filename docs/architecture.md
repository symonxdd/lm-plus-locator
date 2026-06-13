# Architecture

## Why Flutter?

This app is a small, single-developer side project that still needs to run well on both Android and iOS, talk to the device's camera/GPS, and support four languages and light/dark theming — without becoming a maintenance burden. Flutter was a good fit for a few reasons:

- **One codebase, two app stores.** The bulk of the UI, navigation, and business logic (locator search, distance sorting, opening-hours logic) is written once and ships to Android and iOS alike — there's no Kotlin/Swift code to keep in sync.
- **Everything this app needs is "off the shelf".** Location (`geolocator`), reverse geocoding (`geocoding`), runtime permissions (`permission_handler`), camera + share sheet (`image_picker`, `share_plus`), local persistence (`shared_preferences`), and auth (`firebase_auth`) are all mature, well-maintained plugins — no custom native modules were needed anywhere.
- **Material 3 + localization come built in.** `flutter_localizations` plus ARB files gave nl/fr/de/en support with generated, type-safe accessors (`l10n.xxx`), and Material 3 theming (`ColorScheme.fromSeed`, `InputDecorationTheme`, etc.) made consistent light/dark styling straightforward.
- **Hot reload makes UI iteration fast.** Tweaking layouts, theming, or copy and seeing the result in under a second is a big productivity win for the kind of UI-polish work this app gets a lot of.
- **Dart is a pleasant, statically-typed language** with good null-safety and tooling (`flutter analyze`, DevTools), and a single language for the whole app is simpler than context-switching between platforms.
- **Backed by Google with a large ecosystem** — long-term viability and community support for a project that may sit untouched for stretches between updates.

The main trade-off is the debug-mode performance overhead discussed elsewhere (see the README's "Build modes" section) — but for development that's a worthwhile trade for the iteration speed, and it disappears entirely in release builds.

## Tech stack

- **Flutter** (Material 3) — UI framework, targeting Android and iOS
- **Firebase Auth** — optional email/password sign-in
- **geolocator** / **geocoding** / **permission_handler** — device location and reverse geocoding
- **Nominatim (OpenStreetMap)** — free address-search/autocomplete API, called directly via `http`
- **shared_preferences** — persisting the user's theme & language choice
- **image_picker** / **share_plus** — camera capture and OS share sheet (Photo Share tab)
- **flutter_localizations** + ARB files — translations for nl/fr/de/en

No external state-management package is used — screens are `StatefulWidget`s using `setState`, since the app's state is simple and mostly screen-local.

## App shell & navigation

`main.dart` builds a single `MaterialApp` whose `home` is `RootScreen`.

[RootScreen](../lib/screens/root_screen.dart) is the only "real" screen with a `Navigator` route — it shows an `AppBar` (with the head-office info and settings buttons) and a bottom `NavigationBar` switching between two tabs via `IndexedStack`:

1. **Locator** — `HomeScreen`
2. **Photo Share** — `PhotoShareScreen`

Both tabs are kept alive in the `IndexedStack`, so switching tabs doesn't reset their state.

Everything else (address search, account, settings, info sheets) is a **modal bottom sheet** opened with `showModalBottomSheet`, not a pushed route. Because of this:

- Sheets that contain a focusable `TextField` (address search, login/register) must manually pad themselves by `MediaQuery.of(context).viewInsets.bottom` so the keyboard doesn't cover the input — `showModalBottomSheet` does **not** do this automatically. See [AddressSearchSheet](../lib/widgets/address_search_sheet.dart) and [AccountSheet](../lib/widgets/account_sheet.dart).
- `HomeScreen` itself has multiple "screens" (hero / loading / results / error) inside one widget, switched via an internal `_LocatorStatus` enum. A `PopScope` intercepts the system back button so that, from any non-idle state, back returns to the hero screen first instead of leaving the app. See [home_screen.dart](../lib/screens/home_screen.dart).

## Theming

[lib/theme/app_theme.dart](../lib/theme/app_theme.dart) defines `AppTheme.light` / `AppTheme.dark`, both Material 3 `ThemeData` built from a single seed color (`Colors.blue`). It also defines:

- A shared `InputDecorationTheme` giving all text fields a filled, rounded, borderless-at-rest look (a colored border appears on focus/error).
- `systemOverlayStyle(theme)` — keeps the Android status/navigation bar icons legible and the nav bar tinted to match the app's surface color, for the edge-to-edge layout enabled in `main.dart`.

[lib/theme/app_colors.dart](../lib/theme/app_colors.dart) defines `ctaColors(context)` — the background/foreground color pair used for the app's primary "call to action" buttons (navy in light mode, sky blue in dark mode — the two colors from the app icon).

`main.dart` picks `AppTheme.light` or `AppTheme.dark` based on the resolved `ThemeMode` (system/light/dark), persisted via `ThemeService`.

## Localization

Translations live as ARB files in `lib/l10n/` (`app_nl.arb`, `app_en.arb`, `app_fr.arb`, `app_de.arb`); the `app_localizations*.dart` files are generated from these by `flutter gen-l10n` (triggered automatically on build via `generate: true` in `pubspec.yaml`).

Dutch (`nl`) is the fallback if the device language isn't one of the four supported. The user can also pick a language manually via Settings, persisted by `LocaleService`.

## Persistence

Two tiny services wrap `shared_preferences`:

- [LocaleService](../lib/services/locale_service.dart) — the manually-selected app language
- [ThemeService](../lib/services/theme_service.dart) — the manually-selected theme mode

Both default to "follow the device" (`null` locale / `ThemeMode.system`) until the user picks something in Settings.

## Firebase / Auth

`main.dart` initializes Firebase using `firebase_options.dart` (generated by the FlutterFire CLI). [AuthService](../lib/services/auth_service.dart) is a thin wrapper around `FirebaseAuth` for email/password sign-in and registration, used by [AccountSheet](../lib/widgets/account_sheet.dart). An account is entirely optional — the locator works fully signed out.

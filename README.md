# LM+ Locator

An unofficial Flutter companion app for finding the nearest [LM Plus](https://www.lm-ml.be/nl/lm-plus) (Liberale Mutualiteit) office or mailbox in Belgium — by GPS or by address — complete with opening hours, distance, and one-tap directions.

## Documentation

- [docs/README.md](docs/README.md) — start here: what the app does, tech stack, and where everything lives
- [docs/architecture.md](docs/architecture.md) — how the app is wired together
- [docs/features.md](docs/features.md) — feature-by-feature walkthrough
- [docs/data-pipeline.md](docs/data-pipeline.md) — how `assets/lm_offices.json` is scraped and kept up to date

## Getting started

### Requirements

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel) — run `flutter doctor` after installing to check your setup
- **Android**: Android Studio (for the Android SDK and an emulator), or a physical device with USB debugging enabled
- **iOS**: a Mac with Xcode and CocoaPods (`sudo gem install cocoapods`)
- A code editor — VS Code (with the Flutter extension) or Android Studio both work well

After cloning, install dependencies once:

```bash
flutter pub get
```

### Running the app (development)

```bash
flutter run
```

This launches the app in **debug mode** on a connected device or emulator, with hot reload (`r`) and hot restart (`R`) available in the terminal.

### Build modes

Flutter has three build modes, selected via a flag on `flutter run` (or `flutter build`):

| Mode | Command | Use for |
|---|---|---|
| **Debug** (default) | `flutter run` | Day-to-day development — hot reload, assertions, debugging tools. Noticeably slower/less smooth UI than a real build. |
| **Profile** | `flutter run --profile` | Checking real-world performance/FPS without doing a full release build. Most DevTools/profiling features still work. |
| **Release** | `flutter run --release` | Final, optimized build — what you'd actually ship. No hot reload. |

### Building a release

```bash
# Android — installable APK
flutter build apk --release

# Android — Play Store bundle (AAB)
flutter build appbundle --release

# iOS — requires macOS + Xcode, with signing configured
flutter build ipa --release
```

Artifacts end up under `build/app/outputs/` (Android) or `build/ios/` (iOS).

### Optional: setting up Firebase (for the account / sign-in feature)

The locator works fully without this — skip it unless you're working on the optional email/password sign-in feature. Firebase's free **Spark** plan is more than enough; no billing setup required.

1. **On the Firebase console** ([console.firebase.google.com](https://console.firebase.google.com)):
   - Create a new (free) project
   - Go to **Build → Authentication → Sign-in method** and enable the **Email/Password** provider
2. **On your machine**:
   - Install the Firebase CLI: `npm install -g firebase-tools`, then sign in with `firebase login`
   - Install the FlutterFire CLI: `dart pub global activate flutterfire_cli`
   - From the project root, run `flutterfire configure` and select your Firebase project plus the platforms you need (Android/iOS)

This generates/updates `lib/firebase_options.dart`, `android/app/google-services.json`, and `ios/Runner/GoogleService-Info.plist`. Once those are in place, `flutter run` picks them up automatically and the Account sheet's sign-in/registration will work against your Firebase project.

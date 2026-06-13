# LM+ Locator

An unofficial Flutter companion app for finding the nearest [LM Plus](https://www.lm-ml.be/nl/lm-plus) (Liberale Mutualiteit) office or mailbox in Belgium, by GPS or by address, complete with opening hours, distance, and one-tap directions.

## Documentation

- [docs/README.md](docs/README.md): start here for what the app does, the tech stack, and where everything lives
- [docs/architecture.md](docs/architecture.md): how the app is wired together
- [docs/features.md](docs/features.md): feature-by-feature walkthrough
- [docs/data-pipeline.md](docs/data-pipeline.md): how `assets/lm_offices.json` is scraped and kept up to date

These same files are also rendered as a small documentation website using [Starlight](https://starlight.astro.build/). See [docs-site/README.md](docs-site/README.md) for how to run it locally (`npm install` then `npm run dev` inside `docs-site/`).

## Getting started

### Requirements

- The [Flutter SDK](https://docs.flutter.dev/get-started/install), installed via the official guide. Afterwards, run `flutter doctor` to check that everything's set up correctly.
- A way to run the app: an Android emulator (set up through Android Studio) or a physical Android/iOS device with developer mode/USB debugging enabled.
- A code editor. VS Code (with the Flutter extension) or Android Studio both work well.

You do **not** need a Mac or an iOS device to develop this app. On Windows or Linux you can build and run the Android version fully. Building for iOS additionally requires a Mac with Xcode and CocoaPods (`sudo gem install cocoapods`).

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
| **Debug** (default) | `flutter run` | Day-to-day development: hot reload, assertions, debugging tools. Noticeably slower and less smooth than a real build. |
| **Profile** | `flutter run --profile` | Checking real-world performance/FPS without doing a full release build. Most DevTools/profiling features still work. |
| **Release** | `flutter run --release` | The final, optimized build you'd actually ship. No hot reload. |

### Building a release

```bash
# Android: installable APK
flutter build apk --release

# Android: Play Store bundle (AAB)
flutter build appbundle --release

# iOS: requires macOS + Xcode, with signing configured
flutter build ipa --release
```

Artifacts end up under `build/app/outputs/` (Android) or `build/ios/` (iOS).

### Optional: setting up Firebase (for the account / sign-in feature)

The locator works fully without this. Skip it unless you're working on the optional email/password sign-in feature. Firebase's free **Spark** plan is more than enough; no billing setup required.

1. **On the Firebase console** ([console.firebase.google.com](https://console.firebase.google.com)):
   - Create a new (free) project
   - Go to **Build → Authentication → Sign-in method** and enable the **Email/Password** provider
2. **On your machine**:
   - Install the Firebase CLI: `npm install -g firebase-tools`, then sign in with `firebase login`
   - Install the FlutterFire CLI: `dart pub global activate flutterfire_cli`
   - From the project root, run `flutterfire configure` and select your Firebase project plus the platforms you need (Android/iOS)

This generates/updates `lib/firebase_options.dart`, `android/app/google-services.json`, and `ios/Runner/GoogleService-Info.plist`. Once those are in place, `flutter run` picks them up automatically and the Account sheet's sign-in/registration will work against your Firebase project.

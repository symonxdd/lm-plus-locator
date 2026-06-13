# LM+ Locator

An unofficial Flutter companion app for finding the nearest [LM Plus](https://www.lm-ml.be/nl/lm-plus) (Liberale Mutualiteit) office or mailbox in Belgium — by GPS or by address — complete with opening hours, distance, and one-tap directions.

## Documentation

- [docs/README.md](docs/README.md) — start here: what the app does, tech stack, and where everything lives
- [docs/architecture.md](docs/architecture.md) — how the app is wired together
- [docs/features.md](docs/features.md) — feature-by-feature walkthrough
- [docs/data-pipeline.md](docs/data-pipeline.md) — how `assets/lm_offices.json` is scraped and kept up to date

## Getting started

This is a standard Flutter project.

```bash
flutter pub get
flutter run
```

The optional account feature requires a configured Firebase project (see `lib/firebase_options.dart`); the locator itself works without one.

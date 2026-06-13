---
title: LM+ Locator documentation
description: Documentation for LM+ Locator, an unofficial Flutter app for finding LM Plus offices and mailboxes in Belgium.
---

LM+ Locator is an **unofficial** Flutter app that helps members of [LM Plus](https://www.lm-ml.be/nl/lm-plus) (Liberale Mutualiteit, a Belgian health insurance fund) find their nearest office or mailbox drop-off point.

## What it does

- **Find the nearest office** using the device's GPS, or by typing an address (with live autocomplete)
- **Browse offices and mailboxes** sorted by distance, with opening hours and an "open now" status
- **Open any location in Maps** (Google Maps / Apple Maps) with one tap
- **Multilingual**: Dutch, French, German, English, following the device language by default
- **Light/dark theme**, following the system by default
- **Optional account** (email/password via Firebase), not required to use the locator
- An experimental **photo-share** tab for taking and sharing a photo

## Where to go next

| Doc | What's in it |
|---|---|
| [architecture.md](architecture.md) | Tech stack, project structure, navigation, theming, state & persistence |
| [features.md](features.md) | How each feature works, screen by screen, with source file references |
| [data-pipeline.md](data-pipeline.md) | Where the office data comes from and how to refresh it |

## Quick map of the codebase

| Path | Contains |
|---|---|
| `lib/main.dart` | App entry point, theme/locale bootstrapping |
| `lib/screens/` | Top-level screens (`RootScreen`, `HomeScreen`, `PhotoShareScreen`) |
| `lib/widgets/` | Reusable widgets and bottom sheets |
| `lib/services/` | Stateless helper classes wrapping platform/plugin/API calls |
| `lib/models/` | Plain data classes (`Office`, `AddressSuggestion`, ...) |
| `lib/theme/` | App-wide colors and `ThemeData` |
| `lib/l10n/` | Translations (`.arb` files) and generated localization code |
| `assets/lm_offices.json` | The office/mailbox dataset bundled with the app |
| `scripts/` | Python scripts to (re)build that dataset and the app icon |

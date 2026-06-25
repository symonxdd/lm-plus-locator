---
title: Privacy Policy
description: What data LM+ Locator collects, how it's used, and how to delete your account.
---

_Last updated: 2026-06-14_

LM+ Locator is an independent, unofficial companion app for finding LM Plus offices and mailboxes in Belgium. It is not affiliated with LM+ / Liberale Mutualiteit. This page explains what data the app collects and how it's used.

## Location

The app can use your device's GPS (via the `geolocator` and `geocoding` plugins) to find the office or mailbox nearest to you. Your location is:

- requested only when you tap "Use my location"
- used locally on your device to calculate distances and sort results
- never transmitted to, or stored on, any server operated by this app

You can deny location access entirely; the app remains fully usable via manual address search.

## Address search

If you search by address instead of using GPS, the text you type is sent to the free [OpenStreetMap Nominatim](https://nominatim.org/) search API to find matching addresses and their coordinates. This is a third-party service run by the OpenStreetMap Foundation, see their [Nominatim usage policy](https://operations.osmfoundation.org/policies/nominatim/) for how they handle requests. Only the address text you type is sent, no account or device identifier.

## Account (optional)

The app has an optional sign-in feature, used for nothing else right now. If you choose to create an account:

- Your email address and password are sent directly to **Firebase Authentication** (a Google service). This app's developer never sees or stores your password.
- Signing in is entirely optional. The locator works fully without an account.
- You can permanently delete your account at any time from **Account → Delete account**.

## Send Document (experimental)

The Send Document tab lets you take a photo of a document with your camera and send it by email. Tapping send opens your device's native Mail app with the photo already attached and the recipient pre-filled; nothing is sent until you confirm in that screen. This app does not upload the photo anywhere itself - it only hands it to your device's own Mail app.

## What this app does not do

- No analytics, tracking, or advertising
- No crash reporting
- No data is sold or shared with third parties beyond what's described above (Firebase Authentication, OpenStreetMap Nominatim)

## Data retention

- **Location**: never stored
- **Account email**: stored by Firebase Authentication until you delete your account
- **App preferences** (theme, language): stored locally on your device, removed when you uninstall the app

## Children's privacy

This app is not directed at children and does not knowingly collect personal information from children.

## Changes to this policy

If this policy changes, the updated version will be published at this same URL with an updated "Last updated" date above.

## Contact

This is an independent, single-developer open-source project. Questions or requests, including data deletion requests, can be raised via [GitHub Issues](https://github.com/symonxdd/lm-plus-locator/issues).

# Office data pipeline

The app's office/mailbox list is bundled as a static asset: [assets/lm_offices.json](../assets/lm_offices.json) (297 entries as of writing). It's loaded once at runtime by [OfficeService.loadOffices()](../lib/services/office_service.dart) and never fetched from the network — so the app works fully offline once the user's coordinates are known.

## Format

Each entry maps to an [Office](../lib/models/office.dart):

```json
{
  "name": "LM Plus Aalst",
  "address": "Capucienenlaan 93 E",
  "city": "Aalst",
  "postal_code": "9300",
  "phone": "053 21 58 16",
  "lat": 50.9338912,
  "lng": 4.0295921,
  "type": "office",
  "opening_hours": {
    "1": [[900, 1200], [1300, 1630]],
    "2": [[900, 1200]],
    "6": [],
    "0": []
  }
}
```

- `type` is `"office"` or `"mailbox"` (mailboxes typically have no `opening_hours`).
- `opening_hours` maps weekday (`"0"` = Sunday .. `"6"` = Saturday) to a list of `[start, end]` time slots in `HHMM` integer form (e.g. `900` = 09:00). An empty list means closed all day. A missing entry means "unknown" (e.g. by-appointment offices).

## Regenerating the data

Two Python scripts in [scripts/](../scripts/) scrape https://www.lm-ml.be/nl/kantoren (31 pages, 12 offices/page):

| Script | Use it to... | What it touches |
|---|---|---|
| `scrape_offices.py` | Do a **full rebuild** | Scrapes everything (name/address/phone/type/hours) *and* geocodes each address via Nominatim. Slow (one geocoding request per office, rate-limited) — only needed when offices are added, removed, or moved. |
| `update_office_metadata.py` | **Refresh type & opening hours** | Re-scrapes the listing pages and merges just `type`/`opening_hours` into the existing JSON by matching on name/address/postal code/city. Leaves coordinates untouched — much faster, safe to re-run periodically. |

Both write back to `assets/lm_offices.json`. Run with:

```bash
python scripts/scrape_offices.py
# or, for a lighter refresh:
python scripts/update_office_metadata.py
```

Requires `requests` and (for the full scrape) `beautifulsoup4`.

## App icon

[scripts/generate_app_icon.py](../scripts/generate_app_icon.py) draws the app icon (a navy map-pin "blob" with a light-blue "+") and writes `assets/icon/icon.png` and `assets/icon/icon_foreground.png`. After running it, regenerate the platform-specific icons with:

```bash
dart run flutter_launcher_icons
```

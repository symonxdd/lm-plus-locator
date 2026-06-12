"""Refresh office type and opening-hours metadata in assets/lm_offices.json
without re-geocoding.

Re-scrapes https://www.lm-ml.be/nl/kantoren (paginated, like
scrape_offices.py) and merges the "type" (office/mailbox) and
"opening_hours" fields into the existing JSON, matching entries by
name/address/postal_code/city. Coordinates and other existing fields are
left untouched.

Usage:
    python scripts/update_office_metadata.py
"""

from __future__ import annotations

import json
import sys
import time
from pathlib import Path

import requests

from scrape_offices import BASE_URL, NUM_PAGES, SCRAPE_HEADERS, fetch_page

OUTPUT_PATH = Path(__file__).resolve().parent.parent / "assets" / "lm_offices.json"


def _key(office: dict) -> tuple[str, str, str, str]:
    return (office["name"], office["address"], office["postal_code"], office["city"])


def main() -> None:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

    session = requests.Session()

    print(f"Scraping {NUM_PAGES} pages from {BASE_URL} for type/opening-hours metadata ...")
    scraped_by_key: dict[tuple[str, str, str, str], dict] = {}
    for page in range(NUM_PAGES):
        print(f"Fetching page {page}/{NUM_PAGES - 1} ...")
        try:
            page_offices = fetch_page(session, page)
        except requests.RequestException as exc:
            print(f"  failed to fetch page {page}: {exc}")
            continue

        for office in page_offices:
            scraped_by_key[_key(office)] = office
        time.sleep(1)

    print(f"\nScraped metadata for {len(scraped_by_key)} entries. Merging into {OUTPUT_PATH} ...")

    with OUTPUT_PATH.open(encoding="utf-8") as f:
        offices = json.load(f)

    updated = 0
    unmatched = []
    for office in offices:
        scraped = scraped_by_key.get(_key(office))
        if scraped is None:
            unmatched.append(office["name"])
            continue

        office["type"] = scraped["type"]
        if "opening_hours" in scraped:
            office["opening_hours"] = scraped["opening_hours"]
        else:
            office.pop("opening_hours", None)
        updated += 1

    with OUTPUT_PATH.open("w", encoding="utf-8") as f:
        json.dump(offices, f, ensure_ascii=False, indent=2)

    print(f"\nDone. Updated {updated}/{len(offices)} entries.")
    if unmatched:
        print(f"Could not match {len(unmatched)} entries (left unchanged):")
        for name in unmatched:
            print(f"  - {name}")


if __name__ == "__main__":
    main()

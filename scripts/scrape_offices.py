"""Scrape LM Plus office locations and geocode them for the Flutter app.

Scrapes https://www.lm-ml.be/nl/kantoren (paginated, 12 results/page),
geocodes each address via the Nominatim OpenStreetMap API and writes the
result to assets/lm_offices.json.

Usage:
    python scripts/scrape_offices.py
"""

from __future__ import annotations

import json
import sys
import time
from pathlib import Path

import requests
from bs4 import BeautifulSoup

BASE_URL = "https://www.lm-ml.be/nl/kantoren"
NOMINATIM_URL = "https://nominatim.openstreetmap.org/search"
NUM_PAGES = 31
OUTPUT_PATH = Path(__file__).resolve().parent.parent / "assets" / "lm_offices.json"

SCRAPE_HEADERS = {
    "User-Agent": "Mozilla/5.0 (compatible; lm_plus_locator-scraper/1.0)",
}
NOMINATIM_HEADERS = {
    "User-Agent": "lm_plus_locator-scraper/1.0 (Flutter app office locator)",
}


def fetch_page(session: requests.Session, page: int) -> list[dict]:
    """Fetch one listing page and return raw office dicts (without coordinates)."""
    url = f"{BASE_URL}?page={page}"
    response = session.get(url, headers=SCRAPE_HEADERS, timeout=30)
    response.raise_for_status()
    soup = BeautifulSoup(response.text, "html.parser")

    offices = []
    for article in soup.select("article.node--view-mode-teaser.node--office"):
        name_span = article.select_one('span[property="schema:name"]')
        address_line = article.select_one(".address-line1-element")
        postal_code = article.select_one(".postal-code-element")
        city = article.select_one(".locality-element")
        phone = article.select_one(".field--name-field-office-phone .field__item")

        if not (name_span and address_line and postal_code and city):
            print(f"  [page {page}] skipping incomplete entry, missing fields")
            continue

        location_name = name_span.get("content", "").strip()
        offices.append(
            {
                "name": f"LM Plus {location_name}",
                "address": address_line.get_text(strip=True),
                "city": city.get_text(strip=True),
                "postal_code": postal_code.get_text(strip=True),
                "phone": phone.get_text(strip=True) if phone else "",
            }
        )

    return offices


def geocode(session: requests.Session, office: dict) -> tuple[float, float] | None:
    """Geocode an office address via Nominatim. Returns (lat, lng) or None."""
    query = f"{office['address']}, {office['postal_code']} {office['city']}, Belgium"
    params = {"q": query, "format": "json", "limit": 1}

    try:
        response = session.get(
            NOMINATIM_URL, params=params, headers=NOMINATIM_HEADERS, timeout=30
        )
        response.raise_for_status()
        results = response.json()
    except (requests.RequestException, ValueError) as exc:
        print(f"  geocoding error for '{query}': {exc}")
        return None

    if not results:
        print(f"  no geocoding result for '{query}'")
        return None

    return float(results[0]["lat"]), float(results[0]["lon"])


def main() -> None:
    # Avoid UnicodeEncodeError on Windows consoles when printing accented city names.
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

    session = requests.Session()

    print(f"Scraping {NUM_PAGES} pages from {BASE_URL} ...")
    raw_offices: list[dict] = []
    for page in range(NUM_PAGES):
        print(f"Fetching page {page}/{NUM_PAGES - 1} ...")
        try:
            page_offices = fetch_page(session, page)
        except requests.RequestException as exc:
            print(f"  failed to fetch page {page}: {exc}")
            continue

        print(f"  found {len(page_offices)} offices")
        raw_offices.extend(page_offices)
        time.sleep(1)

    print(f"\nScraped {len(raw_offices)} offices total. Geocoding ...")

    geocoded_offices: list[dict] = []
    for i, office in enumerate(raw_offices, start=1):
        print(f"[{i}/{len(raw_offices)}] geocoding '{office['name']}' ...")
        coords = geocode(session, office)
        time.sleep(1)

        if coords is None:
            print(f"  skipping '{office['name']}' (no coordinates)")
            continue

        lat, lng = coords
        geocoded_offices.append({**office, "lat": lat, "lng": lng})

    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    with OUTPUT_PATH.open("w", encoding="utf-8") as f:
        json.dump(geocoded_offices, f, ensure_ascii=False, indent=2)

    print(f"\nDone. Wrote {len(geocoded_offices)} offices to {OUTPUT_PATH}")


if __name__ == "__main__":
    main()

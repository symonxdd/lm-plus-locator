"""Generates the LM+ Locator app icon assets.

Produces:
  - assets/icon/icon.png            (white background, for iOS/legacy Android/web)
  - assets/icon/icon_foreground.png (transparent background, Android adaptive icon)

Both show a navy (#2C398F) map-pin shape with a light-blue (#85D1F5) "+" inside
the pin's head, using the LM+ brand colors.

Run with: python scripts/generate_app_icon.py
Then regenerate platform icons with: dart run flutter_launcher_icons
"""

import math
from pathlib import Path

from PIL import Image, ImageDraw

SCALE = 4
SIZE = 1024 * SCALE

WHITE = (255, 255, 255, 255)
NAVY = (44, 57, 143, 255)  # #2C398F - LM+ "M" color
LIGHT_BLUE = (133, 209, 245, 255)  # #85D1F5 - LM+ "L" color
TRANSPARENT = (0, 0, 0, 0)

# Pin geometry (in 1024-space)
CX, CY = 512, 400
R = 200  # circle (pin head) radius
APEX_DIST = 500  # distance from circle center to the pin's bottom point

# Plus sign geometry (in 1024-space, centered on the circle)
PLUS_ARM = 130
PLUS_THICKNESS = 30


def _scaled(*coords):
    return [c * SCALE for c in coords]


def draw_pin(draw: ImageDraw.ImageDraw, color):
    # Circle (pin head)
    draw.ellipse(
        _scaled(CX - R, CY - R, CX + R, CY + R),
        fill=color,
    )

    # Tail: a triangle whose top two corners sit exactly on the circle,
    # at the tangent points from the apex. This makes the straight tail
    # edges continue smoothly into the circle's curve (classic map-pin
    # / teardrop shape), with no gaps or notches at the seam.
    alpha = math.acos(R / APEX_DIST)
    tangent_y = CY + R * math.cos(alpha)
    tangent_dx = R * math.sin(alpha)

    apex = (CX, CY + APEX_DIST)
    left = (CX - tangent_dx, tangent_y)
    right = (CX + tangent_dx, tangent_y)

    draw.polygon(
        [
            (left[0] * SCALE, left[1] * SCALE),
            (apex[0] * SCALE, apex[1] * SCALE),
            (right[0] * SCALE, right[1] * SCALE),
        ],
        fill=color,
    )


def draw_plus(draw: ImageDraw.ImageDraw, color):
    half_thick = PLUS_THICKNESS / 2
    # Vertical bar
    draw.rectangle(
        _scaled(
            CX - half_thick, CY - PLUS_ARM,
            CX + half_thick, CY + PLUS_ARM,
        ),
        fill=color,
    )
    # Horizontal bar
    draw.rectangle(
        _scaled(
            CX - PLUS_ARM, CY - half_thick,
            CX + PLUS_ARM, CY + half_thick,
        ),
        fill=color,
    )


def render(background):
    image = Image.new("RGBA", (SIZE, SIZE), background)
    draw = ImageDraw.Draw(image)
    draw_pin(draw, NAVY)
    draw_plus(draw, LIGHT_BLUE)
    return image.resize((1024, 1024), Image.Resampling.LANCZOS)


def main():
    out_dir = Path(__file__).resolve().parent.parent / "assets" / "icon"
    out_dir.mkdir(parents=True, exist_ok=True)

    render(WHITE).save(out_dir / "icon.png")
    render(TRANSPARENT).save(out_dir / "icon_foreground.png")
    print(f"Wrote {out_dir / 'icon.png'} and {out_dir / 'icon_foreground.png'}")


if __name__ == "__main__":
    main()

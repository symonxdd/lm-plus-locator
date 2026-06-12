"""Generates the LM+ Locator app icon assets.

Produces:
  - assets/icon/icon.png            (white background, for iOS/legacy Android/web)
  - assets/icon/icon_foreground.png (transparent background, Android adaptive icon)

Both show a navy (#2C398F) map-pin "blob" shape with a light-blue (#85D1F5)
"+" inside the pin's head, using the LM+ brand colors.

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

# Pin geometry (in 1024-space). The pin is built from two circles - a big
# "head" and a small "tip" - joined by their external tangent lines, giving
# a smooth, rounded "blob" silhouette (no sharp point).
CX = 512
HEAD_CY, HEAD_R = 420, 230
TIP_CY, TIP_R = 760, 60

# Plus sign geometry (in 1024-space, centered on the pin's head)
PLUS_ARM = 140
PLUS_THICKNESS = 60


def _scaled(*coords):
    return [c * SCALE for c in coords]


def draw_pin(draw: ImageDraw.ImageDraw, color):
    # Head and tip circles.
    draw.ellipse(
        _scaled(CX - HEAD_R, HEAD_CY - HEAD_R, CX + HEAD_R, HEAD_CY + HEAD_R),
        fill=color,
    )
    draw.ellipse(
        _scaled(CX - TIP_R, TIP_CY - TIP_R, CX + TIP_R, TIP_CY + TIP_R),
        fill=color,
    )

    # Connect them with their external tangent lines, so the join is smooth
    # on both circles (no gaps, no notches).
    d = TIP_CY - HEAD_CY
    beta = math.asin((HEAD_R - TIP_R) / d)
    dx, dy = math.cos(beta), math.sin(beta)

    right_head = (CX + HEAD_R * dx, HEAD_CY + HEAD_R * dy)
    right_tip = (CX + TIP_R * dx, TIP_CY + TIP_R * dy)
    left_head = (CX - HEAD_R * dx, HEAD_CY + HEAD_R * dy)
    left_tip = (CX - TIP_R * dx, TIP_CY + TIP_R * dy)

    draw.polygon(
        [
            (right_head[0] * SCALE, right_head[1] * SCALE),
            (right_tip[0] * SCALE, right_tip[1] * SCALE),
            (left_tip[0] * SCALE, left_tip[1] * SCALE),
            (left_head[0] * SCALE, left_head[1] * SCALE),
        ],
        fill=color,
    )


def draw_plus(draw: ImageDraw.ImageDraw, color):
    half_thick = PLUS_THICKNESS / 2
    radius = half_thick  # fully rounded ends for a soft, modern look
    # Vertical bar
    draw.rounded_rectangle(
        _scaled(
            CX - half_thick, HEAD_CY - PLUS_ARM,
            CX + half_thick, HEAD_CY + PLUS_ARM,
        ),
        radius=radius * SCALE,
        fill=color,
    )
    # Horizontal bar
    draw.rounded_rectangle(
        _scaled(
            CX - PLUS_ARM, HEAD_CY - half_thick,
            CX + PLUS_ARM, HEAD_CY + half_thick,
        ),
        radius=radius * SCALE,
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

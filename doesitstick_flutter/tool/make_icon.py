"""Draws the Did It Stick app icon: Stick, the sunny sticky note, with a sprout.

    python3 tool/make_icon.py

Writes assets/icon/ (full icon, adaptive foreground/background, favicon
preview). flutter_launcher_icons turns them into every platform's sizes.
Colors are the app's tokens (lib/theme/tokens.dart). Needs Pillow + numpy.
"""

import math
import os

import numpy as np
from PIL import Image, ImageDraw, ImageFilter

OUT = os.path.join(os.path.dirname(__file__), "..", "assets", "icon")
S = 4096  # draw big, scale down for clean edges

GRAPE_TOP = (122, 92, 255)
GRAPE_BOTTOM = (78, 51, 207)
SUN = (255, 201, 60)
SUN_FOLD = (238, 170, 30)
SUN_EDGE = (255, 222, 120)
MINT = (45, 201, 138)
MINT_LIGHT = (95, 224, 168)
MINT_DARK = (31, 160, 108)


def gradient_background(size):
    y, x = np.mgrid[0:size, 0:size] / size
    t = np.clip(0.55 * y + 0.45 * x, 0, 1)[..., None]
    rgb = np.array(GRAPE_TOP) * (1 - t) + np.array(GRAPE_BOTTOM) * t
    # A soft glow behind the note.
    r = np.hypot(x - 0.5, y - 0.46)
    glow = np.clip(1 - r / 0.55, 0, 1)[..., None] ** 2 * 26
    rgb = np.clip(rgb + glow, 0, 255)
    return Image.fromarray(rgb.astype("uint8"), "RGB").convert("RGBA")


def bezier(p0, p1, p2, p3, n=120):
    pts = []
    for i in range(n + 1):
        t = i / n
        a = (1 - t) ** 3
        b = 3 * (1 - t) ** 2 * t
        c = 3 * (1 - t) * t ** 2
        d = t ** 3
        pts.append((a * p0[0] + b * p1[0] + c * p2[0] + d * p3[0],
                    a * p0[1] + b * p1[1] + c * p2[1] + d * p3[1]))
    return pts


def leaf(base, tip, width):
    """A lens-shaped leaf from base to tip, bulging by width on each side."""
    bx, by = base
    tx, ty = tip
    dx, dy = tx - bx, ty - by
    length = math.hypot(dx, dy)
    nx, ny = -dy / length, dx / length
    c1 = (bx + dx * 0.25 + nx * width, by + dy * 0.25 + ny * width)
    c2 = (bx + dx * 0.75 + nx * width, by + dy * 0.75 + ny * width)
    c3 = (bx + dx * 0.75 - nx * width, by + dy * 0.75 - ny * width)
    c4 = (bx + dx * 0.25 - nx * width, by + dy * 0.25 - ny * width)
    return bezier(base, c1, c2, tip) + bezier(tip, c3, c4, base)[1:]


def note_layer(size, scale):
    """Stick: the tilted sticky note with its sprout, on a transparent layer.
    [scale] is the note's width as a fraction of the canvas."""
    layer = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    w = size * scale
    cx, cy = size / 2, size * 0.52
    note = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    d = ImageDraw.Draw(note)
    x0, y0, x1, y1 = cx - w / 2, cy - w / 2, cx + w / 2, cy + w / 2
    radius = w * 0.09
    fold = w * 0.24
    # Note body: a rounded square with the bottom-right corner cut off.
    d.rounded_rectangle((x0, y0, x1, y1), radius=radius, fill=SUN)
    # The sticky strip at the top, a shade lighter.
    strip = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    ImageDraw.Draw(strip).rounded_rectangle((x0, y0, x1, y1), radius=radius,
                                            fill=SUN_EDGE)
    strip_mask = Image.new("L", (size, size), 0)
    ImageDraw.Draw(strip_mask).rectangle((x0, y0, x1, y0 + w * 0.13), fill=255)
    note.paste(strip, (0, 0), strip_mask)
    # Cut the corner (draw writes pixels, so transparent erases), then fold it.
    d.polygon([(x1 - fold, y1 + 2), (x1 + 2, y1 - fold), (x1 + 2, y1 + 2)],
              fill=(0, 0, 0, 0))
    d.polygon([(x1, y1 - fold), (x1 - fold, y1), (x1 - fold * 0.9, y1 - fold * 0.9)],
              fill=SUN_FOLD)

    # The sprout: one smooth stem and two leaves, centred on the note.
    sx, sy = cx - w * 0.02, cy + w * 0.30
    top = (cx + w * 0.01, cy - w * 0.04)
    stem = bezier((sx, sy), (sx - w * 0.05, sy - w * 0.13),
                  (top[0] + w * 0.04, top[1] + w * 0.12), top, n=400)
    r = w * 0.042
    for px, py in stem:  # stamping discs gives a perfectly smooth stroke
        d.ellipse((px - r, py - r, px + r, py + r), fill=MINT_DARK)
    d.polygon(leaf(top, (cx - w * 0.32, cy - w * 0.24), w * 0.125, ), fill=MINT)
    d.polygon(leaf(top, (cx + w * 0.32, cy - w * 0.31), w * 0.135), fill=MINT_LIGHT)
    vein = int(w * 0.02)
    d.line([top, (cx - w * 0.21, cy - w * 0.18)], fill=MINT_DARK, width=vein)
    d.line([top, (cx + w * 0.21, cy - w * 0.235)], fill=MINT, width=vein)

    note = note.rotate(-7, resample=Image.BICUBIC, center=(cx, cy))

    # Soft shadow under the note.
    alpha = note.split()[3]
    shadow = Image.new("RGBA", (size, size), (40, 20, 110, 0))
    shadow.putalpha(alpha.point(lambda a: int(a * 0.45)))
    shadow = shadow.transform(
        shadow.size, Image.AFFINE, (1, 0, -size * 0.0, 0, 1, -size * 0.03))
    shadow = shadow.filter(ImageFilter.GaussianBlur(size * 0.03))
    layer = Image.alpha_composite(layer, shadow)
    return Image.alpha_composite(layer, note)


def save(img, name, px):
    img.resize((px, px), Image.LANCZOS).save(os.path.join(OUT, name))


def rounded(img, radius_frac):
    mask = Image.new("L", img.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle(
        (0, 0, img.size[0] - 1, img.size[1] - 1),
        radius=int(img.size[0] * radius_frac), fill=255)
    out = img.copy()
    out.putalpha(mask)
    return out


def main():
    os.makedirs(OUT, exist_ok=True)
    bg = gradient_background(S)
    # Full-bleed icon (iOS masks it; legacy Android; web).
    full = Image.alpha_composite(bg, note_layer(S, 0.62))
    save(full.convert("RGB"), "icon.png", 1024)
    # Android adaptive: background + foreground kept inside the safe zone.
    save(bg.convert("RGB"), "background.png", 1024)
    save(note_layer(S, 0.42), "foreground.png", 1024)
    # Web maskable: content inside the 80% safe circle.
    maskable = Image.alpha_composite(bg, note_layer(S, 0.50))
    save(maskable.convert("RGB"), "maskable.png", 1024)
    # Favicon: rounded tile, the note a little bigger so it reads at 16 px.
    fav = rounded(Image.alpha_composite(bg, note_layer(S, 0.70)), 0.22)
    save(fav, "favicon.png", 256)
    print("written to", os.path.abspath(OUT))


if __name__ == "__main__":
    main()

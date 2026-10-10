"""Makes phone-style photos of grade 3-5 worksheets for end-to-end tests.

One photo per supported concept, plus one non-math page (expected: "other").
Each is a printed sheet with a child's handwritten answers (some wrong),
tilted on a table under uneven light, saved as JPEG like a phone camera would.

    python3 tool/make_worksheet_photos.py

Writes to test/fixtures/worksheets/. Needs Pillow and numpy; uses macOS fonts.
"""

import math
import os
import random

import numpy as np
from PIL import Image, ImageDraw, ImageFilter, ImageFont

OUT = os.path.join(os.path.dirname(__file__), "..", "test", "fixtures", "worksheets")
FONTS = "/System/Library/Fonts/Supplemental/"
W, H = 1700, 2200  # sheet size before the photo effects


def font(name, size):
    return ImageFont.truetype(FONTS + name, size)


PRINT = font("Arial.ttf", 46)
PRINT_SMALL = font("Arial.ttf", 36)
TITLE = font("Arial Bold.ttf", 62)
HAND = font("Bradley Hand Bold.ttf", 60)

# Problems as printed, the child's written answer, and the method sketch.
SHEETS = {
    "addRegroup": (
        "Adding 3-Digit Numbers",
        "Use partial sums. Show your work.",
        [("278 + 146 =", "424"), ("355 + 267 =", "622"), ("419 + 383 =", "792"),
         ("186 + 538 =", "724"), ("647 + 175 =", "822"), ("293 + 459 =", "752")],
        None,
    ),
    "subtractCountUp": (
        "Subtraction: Count Up",
        "Use an open number line to find the difference.",
        [("403 − 178 =", "225"), ("512 − 287 =", "225"), ("600 − 345 =", "265"),
         ("731 − 456 =", "275"), ("820 − 394 =", "426"), ("905 − 619 =", "286")],
        "numberline",
    ),
    "multiply2x1": (
        "Multiplication Practice",
        "Use the box method. Split the big number into tens and ones.",
        [("46 × 7 =", "322"), ("23 × 4 =", "92"), ("58 × 6 =", "338"),
         ("35 × 8 =", "280"), ("72 × 3 =", "216"), ("64 × 5 =", "320")],
        "box2",
    ),
    "multiply2x2": (
        "2-Digit × 2-Digit",
        "Use the area model with 4 boxes.",
        [("23 × 45 =", "1035"), ("31 × 24 =", "744"), ("42 × 36 =", "1512"),
         ("27 × 53 =", "1421"), ("18 × 64 =", "1152"), ("56 × 32 =", "1792")],
        "box4",
    ),
    "divideByOneDigit": (
        "Division with Partial Quotients",
        "Take away friendly chunks. Add up the groups.",
        [("156 ÷ 6 =", "26"), ("144 ÷ 4 =", "36"), ("231 ÷ 7 =", "33"),
         ("168 ÷ 8 =", "21"), ("195 ÷ 5 =", "38"), ("252 ÷ 9 =", "28")],
        None,
    ),
    "equivalentFractions": (
        "Equivalent Fractions",
        "Multiply the top and bottom by the same number.",
        [("2/3 = ?/12", "8"), ("3/4 = ?/8", "6"), ("1/5 = ?/10", "2"),
         ("5/6 = ?/18", "15"), ("2/7 = ?/14", "4"), ("3/8 = ?/24", "9")],
        "fractionbars",
    ),
}


def sheet(title, instructions, problems, sketch, rng):
    img = Image.new("RGB", (W, H), (250, 249, 244))
    d = ImageDraw.Draw(img)
    d.text((110, 90), "Name:", font=PRINT, fill=(30, 30, 30))
    d.line((260, 140, 760, 140), fill=(60, 60, 60), width=3)
    d.text((290, 70), "Sam", font=HAND, fill=(40, 45, 110))
    d.text((960, 90), "Date:", font=PRINT, fill=(30, 30, 30))
    d.line((1090, 140, 1590, 140), fill=(60, 60, 60), width=3)
    d.text((110, 220), title, font=TITLE, fill=(15, 15, 15))
    d.text((110, 320), instructions, font=PRINT_SMALL, fill=(40, 40, 40))
    d.line((110, 390, 1590, 390), fill=(120, 120, 120), width=2)
    for i, (problem, answer) in enumerate(problems):
        col, row = i % 2, i // 2
        x, y = 130 + col * 760, 470 + row * 540
        d.text((x, y), f"{i + 1})  {problem}", font=PRINT, fill=(20, 20, 20))
        bbox = d.textbbox((x, y), f"{i + 1})  {problem}", font=PRINT)
        # Child's answer, slightly off the line like real handwriting.
        d.text((bbox[2] + 22 + rng.randint(-6, 6), y - 12 + rng.randint(-6, 6)),
               answer, font=HAND, fill=(40, 45, 110))
        draw_sketch(d, sketch, problem, x + 30, y + 110, rng)
    return img


def draw_sketch(d, sketch, problem, x, y, rng):
    ink = (60, 65, 120)
    if sketch == "box2":
        tens, ones = problem.split(" ")[0][0] + "0", problem.split(" ")[0][1]
        d.rectangle((x, y, x + 240, y + 150), outline=ink, width=4)
        d.rectangle((x + 240, y, x + 380, y + 150), outline=ink, width=4)
        d.text((x + 80, y - 62), tens, font=HAND, fill=ink)
        d.text((x + 290, y - 62), ones, font=HAND, fill=ink)
    elif sketch == "box4":
        d.rectangle((x, y, x + 400, y + 260), outline=ink, width=4)
        d.line((x + 240, y, x + 240, y + 260), fill=ink, width=4)
        d.line((x, y + 150, x + 400, y + 150), fill=ink, width=4)
    elif sketch == "numberline":
        d.line((x, y + 120, x + 560, y + 120), fill=ink, width=4)
        for k in range(3):
            a, b = x + 20 + k * 180, x + 190 + k * 180
            d.arc((a, y + 30, b, y + 200), 200, 340, fill=ink, width=4)
    elif sketch == "fractionbars":
        for k in range(3):
            d.rectangle((x + k * 120, y + 40, x + k * 120 + 120, y + 120),
                        outline=ink, width=4)
        d.rectangle((x, y + 40, x + 240, y + 120), fill=(200, 205, 235))
        for k in range(3):
            d.rectangle((x + k * 120, y + 40, x + k * 120 + 120, y + 120),
                        outline=ink, width=4)
    # A few stray pencil marks.
    for _ in range(rng.randint(0, 2)):
        sx, sy = x + rng.randint(0, 500), y + rng.randint(0, 250)
        d.line((sx, sy, sx + rng.randint(10, 40), sy + rng.randint(-10, 10)),
               fill=(120, 120, 130), width=2)


def reading_sheet():
    img = Image.new("RGB", (W, H), (250, 249, 244))
    d = ImageDraw.Draw(img)
    d.text((110, 90), "Name:", font=PRINT, fill=(30, 30, 30))
    d.text((290, 70), "Sam", font=HAND, fill=(40, 45, 110))
    d.text((110, 220), "Reading: The Lost Kite", font=TITLE, fill=(15, 15, 15))
    story = ("Mia ran to the hill with her red kite. The wind was strong and "
             "the kite flew high above the trees. Suddenly the string broke! "
             "The kite drifted over the river and landed in Mr. Lee's garden.")
    y = 360
    for line in wrap(story, 52):
        d.text((110, y), line, font=PRINT, fill=(25, 25, 25))
        y += 70
    for i, q in enumerate(["Where did Mia go?", "What color was the kite?",
                           "Where did the kite land?"]):
        d.text((110, y + 80 + i * 260), f"{i + 1}. {q}", font=PRINT, fill=(20, 20, 20))
        d.line((140, y + 220 + i * 260, 1550, y + 220 + i * 260), fill=(90, 90, 90), width=2)
    d.text((170, y + 145), "to the hill", font=HAND, fill=(40, 45, 110))
    d.text((170, y + 405), "red", font=HAND, fill=(40, 45, 110))
    return img


def wrap(text, width):
    words, line, out = text.split(), "", []
    for w in words:
        if len(line) + len(w) + 1 > width:
            out.append(line)
            line = w
        else:
            line = f"{line} {w}".strip()
    return out + [line]


def find_coeffs(dst, src):
    """Perspective coefficients mapping output points to input points."""
    m = []
    for (x, y), (u, v) in zip(dst, src):
        m.append([x, y, 1, 0, 0, 0, -u * x, -u * y])
        m.append([0, 0, 0, x, y, 1, -v * x, -v * y])
    a = np.array(m, dtype=float)
    b = np.array(src, dtype=float).reshape(8)
    return np.linalg.solve(a, b).tolist()


def photograph(page, rng):
    """Lays the sheet on a wooden table, tilts it and adds camera effects."""
    out_w, out_h = 1500, 2000
    # Wood-ish table: brown base with soft grain.
    yy, xx = np.mgrid[0:out_h, 0:out_w]
    grain = (np.sin(xx / 9.0 + np.sin(yy / 60.0) * 3) * 10
             + np.sin(xx / 2.3) * 3)
    table = np.stack([150 + grain, 105 + grain * 0.8, 70 + grain * 0.6], -1)
    table = Image.fromarray(np.clip(table, 0, 255).astype("uint8"))

    # Where the sheet's corners land in the photo (slightly skewed).
    j = lambda: rng.randint(-40, 40)
    corners = [(130 + j(), 120 + j()), (out_w - 140 + j(), 100 + j()),
               (out_w - 110 + j(), out_h - 130 + j()), (110 + j(), out_h - 100 + j())]
    coeffs = find_coeffs(corners, [(0, 0), (W, 0), (W, H), (0, H)])
    warped = page.transform((out_w, out_h), Image.PERSPECTIVE, coeffs,
                            Image.BICUBIC, fillcolor=None)
    mask = Image.new("L", page.size, 255).transform(
        (out_w, out_h), Image.PERSPECTIVE, coeffs, Image.BICUBIC)

    # Soft shadow under the paper.
    shadow = mask.filter(ImageFilter.GaussianBlur(25))
    shaded = Image.composite(Image.new("RGB", table.size, (60, 40, 25)), table,
                             shadow.point(lambda p: int(p * 0.45)))
    shaded.paste(warped, (0, 0), mask)

    # Uneven room light: brighter on one side, a little vignette.
    arr = np.asarray(shaded).astype(float)
    angle = rng.uniform(0, 2 * math.pi)
    ramp = np.cos(angle) * (xx / out_w - 0.5) + np.sin(angle) * (yy / out_h - 0.5)
    light = 0.92 + 0.2 * ramp
    r = np.hypot(xx - out_w / 2, yy - out_h / 2) / math.hypot(out_w / 2, out_h / 2)
    light *= 1 - 0.25 * r ** 2
    arr = arr * light[..., None]
    arr += np.random.default_rng(rng.randint(0, 9999)).normal(0, 4, arr.shape)
    photo = Image.fromarray(np.clip(arr, 0, 255).astype("uint8"))
    return photo.filter(ImageFilter.GaussianBlur(0.8))


def main():
    os.makedirs(OUT, exist_ok=True)
    for i, (concept, (title, instr, problems, sketch)) in enumerate(SHEETS.items()):
        rng = random.Random(100 + i)
        path = os.path.join(OUT, f"{concept}.jpg")
        photograph(sheet(title, instr, problems, sketch, rng), rng).save(
            path, quality=82)
        print(path)
    rng = random.Random(99)
    path = os.path.join(OUT, "other_reading.jpg")
    photograph(reading_sheet(), rng).save(path, quality=82)
    print(path)


if __name__ == "__main__":
    main()

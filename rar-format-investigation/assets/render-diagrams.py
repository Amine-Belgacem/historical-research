"""Render the RAR project figures as editable SVG and README-ready PNG.

Requires Pillow. Original research files are read only for sample validation.
"""
from pathlib import Path
from html import escape
from PIL import Image, ImageDraw, ImageFont
import os

HERE = Path(__file__).resolve().parent
ORIGINALS = HERE.parent / "originals"
FONT_DIR = Path(os.environ.get("WINDIR", "C:/Windows")) / "Fonts"
INK = "#17243a"
MUTED = "#526278"
LINE = "#d4dce7"
BG = "#ffffff"
BLUE = "#dbeafe"
TEAL = "#ccf0e8"
GREEN = "#dff1d8"
ORANGE = "#ffead0"
PURPLE = "#e9e2fb"
SLATE = "#edf1f6"


def font(size, bold=False, mono=False):
    filename = "consolab.ttf" if mono and bold else "consola.ttf" if mono else "segoeuib.ttf" if bold else "segoeui.ttf"
    candidates = [FONT_DIR / filename, Path("/usr/share/fonts/truetype/dejavu") / ("DejaVuSansMono.ttf" if mono else "DejaVuSans-Bold.ttf" if bold else "DejaVuSans.ttf")]
    for candidate in candidates:
        if candidate.exists():
            return ImageFont.truetype(str(candidate), size)
    return ImageFont.truetype("DejaVuSans.ttf", size)


class Figure:
    def __init__(self, width, height, title, description):
        self.width, self.height = width, height
        self.image = Image.new("RGB", (width, height), BG)
        self.draw = ImageDraw.Draw(self.image)
        self.svg = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}" role="img" aria-labelledby="title description">', f'<title id="title">{escape(title)}</title>', f'<desc id="description">{escape(description)}</desc>', f'<rect width="{width}" height="{height}" fill="{BG}"/>']

    def rect(self, x, y, width, height, fill=SLATE, stroke=LINE, radius=0):
        self.draw.rounded_rectangle((x, y, x + width, y + height), radius, fill, stroke, 1)
        self.svg.append(f'<rect x="{x}" y="{y}" width="{width}" height="{height}" rx="{radius}" fill="{fill}" stroke="{stroke}"/>')

    def text(self, x, baseline, value, size=24, fill=INK, bold=False, mono=False, anchor="start"):
        value = str(value)
        face = font(size, bold, mono)
        measured = self.draw.textlength(value, font=face)
        left = x if anchor == "start" else x - measured / 2 if anchor == "middle" else x - measured
        if left < 0 or left + measured > self.width:
            raise ValueError(f"Text exceeds figure bounds: {value}")
        self.draw.text((left, baseline), value, font=face, fill=fill, anchor="ls")
        family = "Consolas, 'DejaVu Sans Mono', monospace" if mono else "'Segoe UI', Arial, sans-serif"
        self.svg.append(f'<text x="{x}" y="{baseline}" font-family="{family}" font-size="{size}" font-weight="{700 if bold else 400}" fill="{fill}" text-anchor="{anchor}">{escape(value)}</text>')

    def line(self, x1, y1, x2, y2, fill=LINE, width=2):
        self.draw.line((x1, y1, x2, y2), fill=fill, width=width)
        self.svg.append(f'<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" stroke="{fill}" stroke-width="{width}"/>')

    def arrow(self, x1, y, x2):
        self.line(x1, y, x2 - 8, y, MUTED, 3)
        points = [(x2, y), (x2 - 10, y - 6), (x2 - 10, y + 6)]
        self.draw.polygon(points, fill=MUTED)
        self.svg.append(f'<polygon points="{x2},{y} {x2 - 10},{y - 6} {x2 - 10},{y + 6}" fill="{MUTED}"/>')

    def hex_row(self, values, x, y, cell=64, gap=12, fill=BLUE):
        for index, value in enumerate(values):
            left = x + index * (cell + gap)
            self.rect(left, y, cell, 54, fill)
            self.text(left + cell / 2, y + 36, value, 27, mono=True, bold=True, anchor="middle")

    def save(self, name):
        (HERE / f"{name}.svg").write_text("\n".join(self.svg + ["</svg>"]) + "\n", encoding="utf-8")
        self.image.save(HERE / f"{name}.png", optimize=True)


def read_note(name):
    content = (ORIGINALS / name).read_bytes()
    try:
        return content.decode("utf-8")
    except UnicodeDecodeError:
        return content.decode("cp1252")


def validate_samples():
    main = read_note("WinRAR_Reverse_Engineering_Notes_2008.txt").lower()
    content = read_note("WinRAR_Password_Content_HEX_Analysis_2008.txt").lower()
    assert "52/61/72/21/1a/07/00" in main
    assert "02/b7/ef/dc/83/2c/ba/53/38/1d/33/05" in main
    compact = "".join(content.split())
    assert "d1/1c/bd/73/24/99/18/31/69/2a/e9/e7/ac/c2/a8/88/" in compact
    assert "1b/0f/34/67/89/9c/00/21/f4/4f/3b/52/c5/23/8b/1f/" in compact


def structure():
    fig = Figure(1440, 1160, "RAR structure and research field map", "A RAR 3.x archive sequence, two rows mapping the fixed 32-byte file header, variable metadata, and fields investigated through hex analysis.")
    fig.text(80, 80, "RAR FILE STRUCTURE", 44, bold=True)
    fig.text(80, 125, "RAR 3.x format map  |  Hex investigation, 2008", 27, fill=MUTED)
    fig.line(80, 153, 1360, 153)
    fig.text(80, 203, "01  ARCHIVE SEQUENCE", 27, bold=True)
    blocks = [(80, 195, "Signature", "7 bytes", BLUE), (307, 215, "Archive header", "13+ bytes", SLATE), (554, 255, "File header", "32+ bytes", TEAL), (841, 260, "Packed file data", "Variable length", PURPLE), (1133, 227, "Next block", "Files / end", SLATE)]
    for i, (x, width, label, detail, color) in enumerate(blocks):
        fig.rect(x, 235, width, 105, color)
        fig.text(x + width / 2, 278, label, 25, bold=True, anchor="middle")
        fig.text(x + width / 2, 316, detail, 23, fill=MUTED, anchor="middle")
        if i < len(blocks) - 1:
            fig.arrow(x + width + 5, 287, blocks[i + 1][0] - 5)
    fig.text(80, 385, "52 61 72 21 1A 07 00", 28, mono=True, bold=True)
    fig.text(640, 385, "The marker recorded in the research notebook", 24, fill=MUTED)
    fig.text(80, 460, "02  FIXED FILE HEADER", 27, bold=True)
    fig.text(80, 498, "Offsets are relative to the file header; the fixed part occupies 32 bytes.", 24, fill=MUTED)
    row1 = [(0, 2, "Header CRC", SLATE), (2, 1, "Type", SLATE), (3, 2, "Flags", ORANGE), (5, 2, "Header size", SLATE), (7, 4, "Packed size", SLATE), (11, 4, "Unpacked size", SLATE), (15, 1, "OS", SLATE)]
    row2 = [(16, 4, "File CRC", BLUE), (20, 4, "DOS date / time", GREEN), (24, 1, "Ver.", SLATE), (25, 1, "Method", TEAL), (26, 2, "Name size", SLATE), (28, 4, "Attributes", SLATE)]
    for row, y, base in [(row1, 550, 0), (row2, 715, 16)]:
        for offset, count, label, color in row:
            x = 144 + (offset - base) * 72
            width = count * 72
            offset_label = f"+{offset:02X}" if count == 1 else f"+{offset:02X}–{offset + count - 1:02X}"
            fig.text(x + width / 2, y - 15, offset_label, 22, mono=True, fill=MUTED, anchor="middle")
            fig.rect(x, y, width, 92, color)
            fig.text(x + width / 2, y + 38, label, 20 if count == 1 else 22 if count == 2 else 26, bold=True, anchor="middle")
            fig.text(x + width / 2, y + 72, f"{count} B", 22, mono=True, fill=MUTED, anchor="middle")
    fig.text(80, 875, "03  VARIABLE METADATA AND CONTENTS", 27, bold=True)
    tails = [(80, 280, "Large-size fields"), (388, 220, "Filename"), (636, 320, "Salt / extended time"), (984, 376, "Packed file data")]
    for index, (x, width, label) in enumerate(tails):
        fig.rect(x, 905, width, 64, PURPLE if index == 3 else SLATE)
        fig.text(x + width / 2, 945, label, 25, bold=True, anchor="middle")
        if index < 3:
            fig.arrow(x + width + 5, 937, tails[index + 1][0] - 5)
    fig.text(80, 1012, "Filename length and flags determine the optional fields. Shown with readable headers.", 24, fill=MUTED)
    fig.line(80, 1045, 1360, 1045)
    fig.text(80, 1090, "Research focus: CRC, timestamps, compression methods, and protected-file differences.", 25, bold=True)
    fig.text(80, 1130, "Format: RAR 3.30 technical information. Hex examples: original 2008 notebooks.", 22, fill=MUTED)
    fig.save("rar-structure")


def comparisons():
    fig = Figure(1440, 1320, "Hex comparisons from the 2008 RAR notebooks", "The RAR signature, CRC byte order, compression method bytes, and two 16-byte data regions transcribed from the original research notes.")
    fig.text(80, 80, "HEX ANALYSIS  /  2008", 44, bold=True)
    fig.text(80, 125, "Controlled samples  •  byte comparisons  •  manual editing", 27, fill=MUTED)
    fig.line(80, 153, 1360, 153)
    fig.text(80, 210, "01  ARCHIVE SIGNATURE", 27, bold=True)
    fig.hex_row("52 61 72 21 1A 07 00".split(), 80, 238, cell=70, gap=12)
    fig.text(790, 270, "52 61 72 21 = Rar!", 30, mono=True, bold=True)
    fig.text(790, 308, "Seven-byte marker from the notebook", 24, fill=MUTED)
    fig.line(80, 352, 1360, 352)
    fig.text(80, 408, "02  CRC BYTE ORDER", 27, bold=True)
    fig.text(80, 447, "Stored bytes", 24, fill=MUTED)
    fig.hex_row("B7 EF DC 83".split(), 80, 465, cell=88, gap=12)
    fig.arrow(525, 492, 725)
    fig.text(565, 550, "Little-endian", 24, fill=MUTED)
    fig.text(820, 447, "Displayed CRC32", 24, fill=MUTED)
    fig.rect(820, 465, 450, 64, BLUE)
    fig.text(1045, 508, "83DCEFB7", 35, mono=True, bold=True, anchor="middle")
    fig.line(80, 590, 1360, 590)
    fig.text(80, 646, "03  COMPRESSION METHODS", 27, bold=True)
    methods = [("30", "Store"), ("31", "Fastest"), ("32", "Fast"), ("33", "Normal"), ("34", "Good"), ("35", "Best")]
    for i, (value, label) in enumerate(methods):
        x = 80 + i * 216
        fig.rect(x, 680, 196, 62, TEAL)
        fig.text(x + 98, 723, value, 34, mono=True, bold=True, anchor="middle")
        fig.text(x + 98, 780, label, 25, anchor="middle")
    fig.line(80, 825, 1360, 825)
    fig.text(80, 882, "04  PROTECTED-SAMPLE COMPARISON", 27, bold=True)
    fig.text(80, 925, "Sample A  /  16-byte region", 25, fill=MUTED)
    fig.hex_row("D1 1C BD 73 24 99 18 31 69 2A E9 E7 AC C2 A8 88".split(), 100, 950, cell=64, gap=12, fill=BLUE)
    fig.text(80, 1060, "Sample B  /  16-byte region", 25, fill=MUTED)
    fig.hex_row("1B 0F 34 67 89 9C 00 21 F4 4F 3B 52 C5 23 8B 1F".split(), 100, 1085, cell=64, gap=12, fill=PURPLE)
    fig.text(80, 1190, "Data regions transcribed from the password/content hex-analysis notebook.", 24, fill=MUTED)
    fig.line(80, 1230, 1360, 1230)
    fig.text(80, 1280, "The research used hexadecimal comparison and direct byte editing to relate changes to behavior.", 23, bold=True)
    fig.save("hex-comparisons")


if __name__ == "__main__":
    validate_samples()
    structure()
    comparisons()
    print("Rendered 2 SVG figures and 2 PNG previews; notebook sample checks passed.")

#!/usr/bin/env python3
"""Generate the final defense PPTX from slides/final_ppt.md.

The generator uses only Python standard library OpenXML writing. It does not
embed images, screenshots, videos, logs, or private materials.
"""

from __future__ import annotations

import html
import re
import zipfile
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "slides" / "final_ppt.md"
OUTPUT = ROOT / "slides" / "final_defense_ppt.pptx"

SLIDE_W = 12192000
SLIDE_H = 6858000
EMU = 914400

NAVY = "0B1F3A"
DEEP = "123C69"
PANEL = "102A4C"
BLUE = "1E88E5"
CYAN = "21C4D6"
GREEN = "23A36D"
AMBER = "F0A202"
WHITE = "FFFFFF"
LIGHT = "EAF4FF"
MUTED = "AFC4D8"


@dataclass
class SlideData:
    number: int
    title: str
    key: str
    bullets: list[str]
    visual: str
    notes: str


class SlideBuilder:
    def __init__(self) -> None:
        self.shape_id = 1
        self.parts: list[str] = []

    def next_id(self) -> int:
        self.shape_id += 1
        return self.shape_id

    @staticmethod
    def xywh(x: float, y: float, w: float, h: float) -> tuple[int, int, int, int]:
        return int(x * EMU), int(y * EMU), int(w * EMU), int(h * EMU)

    def rect(
        self,
        x: float,
        y: float,
        w: float,
        h: float,
        fill: str = DEEP,
        line: str = CYAN,
        radius: bool = False,
    ) -> None:
        self.text_box("", x, y, w, h, fill=fill, line=line, font_size=1, radius=radius)

    def text_box(
        self,
        text: str,
        x: float,
        y: float,
        w: float,
        h: float,
        *,
        fill: str = DEEP,
        line: str = BLUE,
        color: str = WHITE,
        font_size: int = 18,
        bold: bool = False,
        align: str = "l",
        valign: str = "ctr",
        margin: int = 91440,
        radius: bool = True,
    ) -> None:
        sid = self.next_id()
        ox, oy, cx, cy = self.xywh(x, y, w, h)
        geom = "roundRect" if radius else "rect"
        body = paragraphs(text, color=color, font_size=font_size, bold=bold, align=align)
        self.parts.append(
            f"""
<p:sp>
  <p:nvSpPr><p:cNvPr id="{sid}" name="Shape {sid}"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr>
  <p:spPr>
    <a:xfrm><a:off x="{ox}" y="{oy}"/><a:ext cx="{cx}" cy="{cy}"/></a:xfrm>
    <a:prstGeom prst="{geom}"><a:avLst/></a:prstGeom>
    <a:solidFill><a:srgbClr val="{fill}"/></a:solidFill>
    <a:ln w="12700"><a:solidFill><a:srgbClr val="{line}"/></a:solidFill></a:ln>
  </p:spPr>
  <p:txBody><a:bodyPr wrap="square" anchor="{valign}" lIns="{margin}" tIns="{margin}" rIns="{margin}" bIns="{margin}"/><a:lstStyle/>{body}</p:txBody>
</p:sp>
"""
        )

    def bare_text(
        self,
        text: str,
        x: float,
        y: float,
        w: float,
        h: float,
        *,
        color: str = WHITE,
        font_size: int = 18,
        bold: bool = False,
        align: str = "l",
        valign: str = "ctr",
    ) -> None:
        self.text_box(
            text,
            x,
            y,
            w,
            h,
            fill=NAVY,
            line=NAVY,
            color=color,
            font_size=font_size,
            bold=bold,
            align=align,
            valign=valign,
            margin=0,
            radius=False,
        )

    def xml(self) -> str:
        return f"""<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:sld xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main">
  <p:cSld>
    <p:bg><p:bgPr><a:solidFill><a:srgbClr val="{NAVY}"/></a:solidFill><a:effectLst/></p:bgPr></p:bg>
    <p:spTree>
      <p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr>
      <p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="{SLIDE_W}" cy="{SLIDE_H}"/><a:chOff x="0" y="0"/><a:chExt cx="{SLIDE_W}" cy="{SLIDE_H}"/></a:xfrm></p:grpSpPr>
      {''.join(self.parts)}
    </p:spTree>
  </p:cSld>
  <p:clrMapOvr><a:masterClrMapping/></p:clrMapOvr>
</p:sld>
"""


def escape_text(text: str) -> str:
    return html.escape(text, quote=False)


def paragraphs(
    text: str,
    *,
    color: str,
    font_size: int,
    bold: bool,
    align: str,
) -> str:
    lines = text.splitlines() or [""]
    out = []
    for line in lines:
        line = escape_text(line)
        b_attr = ' b="1"' if bold else ""
        out.append(
            f"""
<a:p>
  <a:pPr algn="{align}"/>
  <a:r>
    <a:rPr lang="zh-CN" sz="{font_size * 100}"{b_attr}>
      <a:solidFill><a:srgbClr val="{color}"/></a:solidFill>
      <a:latin typeface="Microsoft YaHei"/><a:ea typeface="Microsoft YaHei"/><a:cs typeface="Microsoft YaHei"/>
    </a:rPr>
    <a:t>{line}</a:t>
  </a:r>
  <a:endParaRPr lang="zh-CN" sz="{font_size * 100}"/>
</a:p>
"""
        )
    return "".join(out)


def section_between(block: str, start: str, stops: Iterable[str]) -> str:
    idx = block.find(start)
    if idx < 0:
        return ""
    body = block[idx + len(start) :]
    stop_positions = [body.find(stop) for stop in stops if body.find(stop) >= 0]
    if stop_positions:
        body = body[: min(stop_positions)]
    return body.strip()


def parse_slides(markdown: str) -> list[SlideData]:
    blocks = markdown.split("\n## Slide ")[1:]
    slides: list[SlideData] = []
    for raw in blocks:
        heading, *rest = raw.splitlines()
        match = re.match(r"^(\d+)\.\s+(.+)$", heading)
        if not match:
            raise ValueError(f"Cannot parse slide heading: {heading}")
        block = "\n".join(rest)
        bullets_raw = section_between(block, "**Bullet content**", ["**Suggested visual**"])
        bullets = [
            line.strip()[2:].strip()
            for line in bullets_raw.splitlines()
            if line.strip().startswith("- ")
        ]
        slides.append(
            SlideData(
                number=int(match.group(1)),
                title=match.group(2).strip(),
                key=" ".join(section_between(block, "**Key message**", ["**Bullet content**"]).split()),
                bullets=bullets,
                visual=" ".join(section_between(block, "**Suggested visual**", ["**Speaker notes**"]).split()),
                notes=section_between(block, "**Speaker notes**", []),
            )
        )
    if len(slides) != 16:
        raise ValueError(f"Expected 16 slides, found {len(slides)}")
    return slides


def bullet_text(bullets: list[str], limit: int | None = None) -> str:
    chosen = bullets if limit is None else bullets[:limit]
    return "\n".join(f"• {item}" for item in chosen)


def add_header(b: SlideBuilder, data: SlideData) -> None:
    b.rect(0, 0, 13.333, 0.16, fill=CYAN, line=CYAN, radius=False)
    b.bare_text(data.title, 0.45, 0.27, 10.6, 0.38, font_size=21, bold=True)
    b.bare_text(f"OUC xv6 Lab Kit | {data.number}/16", 10.8, 0.31, 2.1, 0.2, color=MUTED, font_size=8, align="r")


def add_base(b: SlideBuilder, data: SlideData) -> None:
    add_header(b, data)
    b.text_box(data.key, 0.55, 0.88, 12.2, 0.72, fill=DEEP, line=BLUE, color=LIGHT, font_size=14, bold=True)
    b.bare_text(bullet_text(data.bullets), 0.72, 1.86, 6.35, 4.85, font_size=12, valign="t")
    b.bare_text("source: slides/final_ppt.md", 0.55, 6.95, 3.3, 0.2, color=MUTED, font_size=7)


def add_visual_title(b: SlideBuilder, title: str) -> None:
    b.text_box(title, 7.45, 1.86, 5.05, 0.45, fill=PANEL, line=BLUE, color=CYAN, font_size=11, bold=True, align="c")


def card(b: SlideBuilder, text: str, x: float, y: float, w: float, h: float, fill: str = DEEP, font_size: int = 11, color: str = WHITE) -> None:
    b.text_box(text, x, y, w, h, fill=fill, line=CYAN, color=color, font_size=font_size, bold=True, align="c")


def add_visual(b: SlideBuilder, data: SlideData) -> None:
    if data.number == 1:
        b.rect(0, 0, 13.333, 7.5, fill=NAVY, line=NAVY, radius=False)
        b.rect(0, 0, 13.333, 0.24, fill=CYAN, line=CYAN, radius=False)
        b.bare_text("OUC xv6 Lab Kit", 0.8, 1.05, 11.7, 0.8, font_size=34, bold=True, align="c")
        b.bare_text(data.key, 1.35, 1.95, 10.65, 0.8, color=LIGHT, font_size=16, align="c")
        card(b, "Lab0-Lab5", 1.35, 3.35, 3.15, 0.78, fill=DEEP, font_size=16)
        card(b, "integrated 0001-0007", 5.1, 3.35, 3.15, 0.78, fill=DEEP, font_size=15)
        card(b, "rain/root/z2996 PASS", 8.85, 3.35, 3.15, 0.78, fill=DEEP, font_size=14)
        b.bare_text(bullet_text(data.bullets, 4), 1.65, 4.72, 10.0, 1.1, font_size=12, align="c")
        b.bare_text("2026 OS Function Challenge proj54", 4.2, 6.82, 4.9, 0.24, color=MUTED, font_size=9, align="c")
        return

    add_visual_title(b, visual_title(data.number))
    dispatch = {
        2: visual_weights,
        3: visual_flow,
        4: visual_architecture,
        5: visual_roadmap,
        6: visual_syscall,
        7: visual_proc,
        8: visual_pgcount,
        9: visual_fd,
        10: visual_capstone,
        11: visual_patches,
        12: visual_evidence,
        13: visual_manifest,
        14: visual_comparison,
        15: visual_innovation,
        16: visual_summary,
    }
    dispatch.get(data.number, visual_generic)(b, data)


def visual_title(number: int) -> str:
    titles = {
        2: "scoring fit",
        3: "reproduction flow",
        4: "architecture",
        5: "Lab0-Lab5 roadmap",
        6: "syscall path",
        7: "proc[] snapshot",
        8: "eager vs lazy",
        9: "fd table -> file table",
        10: "capstone checklist",
        11: "integrated sequence",
        12: "final full verification",
        13: "evidence manifest",
        14: "differentiation",
        15: "teaching value",
        16: "final boundary",
    }
    return titles.get(number, "visual cue")


def visual_weights(b: SlideBuilder, _: SlideData) -> None:
    items = [("文档\n50%", CYAN), ("实现\n30%", BLUE), ("测试\n10%", GREEN), ("创新\n10%", AMBER)]
    for i, (text, color) in enumerate(items):
        card(b, text, 7.8 + (i % 2) * 2.05, 2.55 + (i // 2) * 1.35, 1.65, 0.98, fill=color, font_size=16, color=NAVY)
    b.bare_text("文档体系优先，功能实现适度，验证证据可追溯。", 7.75, 5.6, 4.4, 0.45, color=LIGHT, font_size=11, align="c")


def visual_flow(b: SlideBuilder, _: SlideData) -> None:
    for i, step in enumerate(["doctor", "apply + make", "boot/run", "summary", "manifest"]):
        card(b, step, 7.78, 2.42 + i * 0.58, 1.85, 0.38, fill=GREEN if i == 4 else DEEP, font_size=10)
    card(b, "QEMU timeout\ncleanup", 10.05, 2.68, 1.75, 0.9, fill=BLUE, font_size=10)
    card(b, "copy-to-lead\nsummary", 10.05, 4.1, 1.75, 0.9, fill=DEEP, font_size=10)


def visual_architecture(b: SlideBuilder, _: SlideData) -> None:
    for i, step in enumerate(["xv6 baseline", "labs", "integrated patches", "verify scripts", "evidence"]):
        card(b, step, 7.65, 2.35 + i * 0.62, 3.65, 0.4, fill=BLUE if i == 0 else DEEP, font_size=10)


def visual_roadmap(b: SlideBuilder, _: SlideData) -> None:
    labs = ["Lab0", "Lab1", "Lab2", "Lab3", "Lab4", "Lab5"]
    for i, lab in enumerate(labs):
        card(b, lab, 7.72 + (i % 3) * 1.38, 2.55 + (i // 3) * 1.25, 1.05, 0.68, fill=GREEN if i == 5 else BLUE, font_size=12)
    b.bare_text("env -> syscall -> proc -> pagetable -> file/fd -> capstone", 7.75, 5.45, 4.35, 0.45, color=LIGHT, font_size=10, align="c")


def visual_syscall(b: SlideBuilder, _: SlideData) -> None:
    for i, step in enumerate(["user program", "usys stub", "syscall.c", "sys_* handler", "return"]):
        card(b, step, 7.75, 2.3 + i * 0.55, 3.35, 0.36, fill=BLUE if i == 0 else DEEP, font_size=10)
    card(b, "hello=22\nadd2=23", 11.35, 3.0, 0.78, 1.1, fill=GREEN, font_size=9)


def visual_proc(b: SlideBuilder, _: SlideData) -> None:
    rows = [("pid", "state"), ("1", "RUNNING"), ("2", "SLEEPING"), ("3", "RUNNABLE")]
    for r, row in enumerate(rows):
        for c, cell in enumerate(row):
            card(b, cell, 7.8 + c * 1.65, 2.45 + r * 0.58, 1.45, 0.38, fill=BLUE if r == 0 else DEEP, font_size=10)
    card(b, "lock protected\nstate read", 9.45, 5.0, 1.9, 0.72, fill=GREEN, font_size=10)


def visual_pgcount(b: SlideBuilder, _: SlideData) -> None:
    b.bare_text("eager sbrk", 7.85, 2.36, 1.8, 0.25, color=CYAN, font_size=10, bold=True, align="c")
    b.bare_text("lazy sbrklazy", 10.05, 2.36, 1.8, 0.25, color=CYAN, font_size=10, bold=True, align="c")
    card(b, "mapped", 8.0, 2.85, 1.25, 0.45, fill=GREEN, font_size=10)
    card(b, "mapped", 8.0, 3.5, 1.25, 0.45, fill=GREEN, font_size=10)
    card(b, "delta = 2", 7.86, 4.48, 1.55, 0.48, fill=BLUE, font_size=11)
    card(b, "reserve\n0", 10.2, 2.85, 1.35, 0.55, fill=DEEP, font_size=10)
    card(b, "touch 1\n1", 10.2, 3.6, 1.35, 0.55, fill=BLUE, font_size=10)
    card(b, "touch 2\n2", 10.2, 4.35, 1.35, 0.55, fill=GREEN, font_size=10)


def visual_fd(b: SlideBuilder, _: SlideData) -> None:
    card(b, "proc.ofile[]\nfd 0/1/2/3", 7.78, 2.75, 1.75, 0.98, fill=BLUE, font_size=10)
    card(b, "struct file\nref > 0", 10.05, 2.75, 1.55, 0.98, fill=DEEP, font_size=10)
    card(b, "global ftable", 10.0, 4.25, 1.9, 0.55, fill=GREEN, font_size=10)
    card(b, "fdcount: current proc\nfcount: global table", 7.95, 5.25, 3.75, 0.55, fill=DEEP, font_size=9)


def visual_capstone(b: SlideBuilder, _: SlideData) -> None:
    for i, step in enumerate(["clean baseline", "apply 0001-0007", "make + boot", "all user tests", "report"]):
        card(b, step, 7.8, 2.35 + i * 0.58, 3.55, 0.38, fill=GREEN if i == 4 else DEEP, font_size=10)


def visual_patches(b: SlideBuilder, _: SlideData) -> None:
    labels = ["0001", "0002", "0003", "0004", "0005", "0006", "0007"]
    for i, label in enumerate(labels):
        card(b, label, 7.65 + (i % 4) * 1.1, 2.45 + (i // 4) * 0.95, 0.85, 0.52, fill=GREEN if i >= 5 else BLUE, font_size=10)
    card(b, "teammate-verify.sh --full", 8.0, 4.85, 3.65, 0.62, fill=DEEP, font_size=11)


def visual_evidence(b: SlideBuilder, _: SlideData) -> None:
    users = [("rain", "lead local"), ("root", "teammate A"), ("z2996", "teammate B")]
    for i, (user, role) in enumerate(users):
        card(b, f"{user}\n{role}\nPASS", 7.7 + i * 1.48, 2.65, 1.25, 1.5, fill=GREEN, font_size=10)
    b.bare_text("commit e8e2fb9\nintegrated 0001-0007", 8.0, 4.7, 3.7, 0.72, color=LIGHT, font_size=11, align="c")


def visual_manifest(b: SlideBuilder, _: SlideData) -> None:
    for i, item in enumerate(["final video", "SHA256", "teammate summaries", "historical boundary", "no raw files in Git"]):
        card(b, item, 7.85, 2.32 + i * 0.58, 3.8, 0.38, fill=GREEN if item == "SHA256" else DEEP, font_size=10)


def visual_comparison(b: SlideBuilder, _: SlideData) -> None:
    rows = [("uCore/rCore", "完整课程/生态"), ("YatSen/F-Tutorials", "材料组织参考"), ("本项目", "OUC+xv6+复现证据")]
    for r, row in enumerate(rows):
        for c, cell in enumerate(row):
            card(b, cell, 7.66 + c * 2.05, 2.55 + r * 0.74, 1.85, 0.44, fill=GREEN if r == 2 else DEEP, font_size=9)
    b.bare_text("URL/license 未确认项保持待核对", 7.8, 5.35, 3.95, 0.35, color=AMBER, font_size=10, align="c")


def visual_innovation(b: SlideBuilder, _: SlideData) -> None:
    items = ["课程体系", "patch workflow", "teammate verify", "QEMU cleanup", "evidence manifest", "AI transparency"]
    for i, item in enumerate(items):
        card(b, item, 7.72 + (i % 2) * 1.95, 2.35 + (i // 2) * 0.86, 1.65, 0.5, fill=BLUE if i < 2 else DEEP, font_size=9)


def visual_summary(b: SlideBuilder, _: SlideData) -> None:
    cols = [("已完成", "Lab0-Lab5\n0001-0007\n三方 PASS"), ("边界", "非 LTP\n非完整 FS/MM\n非长期稳定性"), ("后续", "平台方式\n隐私复核\n引用核对")]
    for i, (head, body) in enumerate(cols):
        card(b, head, 7.62 + i * 1.45, 2.55, 1.18, 0.42, fill=GREEN if i == 0 else BLUE, font_size=10)
        card(b, body, 7.53 + i * 1.45, 3.15, 1.36, 1.28, fill=DEEP, font_size=8)
    b.bare_text("可教 · 可复现 · 可验证 · 可扩展", 7.7, 5.28, 4.2, 0.4, color=CYAN, font_size=12, bold=True, align="c")


def visual_generic(b: SlideBuilder, data: SlideData) -> None:
    card(b, data.visual, 7.8, 2.7, 4.25, 2.6, fill=PANEL, font_size=11)


def build_slide(data: SlideData) -> str:
    b = SlideBuilder()
    if data.number == 1:
        add_visual(b, data)
    else:
        add_base(b, data)
        add_visual(b, data)
    return b.xml()


def build_notes_slide(data: SlideData) -> str:
    b = SlideBuilder()
    b.rect(0, 0, 7.5, 10.0, fill="FFFFFF", line="FFFFFF", radius=False)
    b.bare_text(f"Speaker Notes - Slide {data.number}: {data.title}", 0.45, 0.35, 6.6, 0.35, color=NAVY, font_size=14, bold=True)
    b.text_box(data.notes, 0.45, 0.9, 6.6, 2.2, fill="F4F8FC", line="D5E4F2", color=NAVY, font_size=12, align="l", valign="t")
    return f"""<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:notes xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main">
  <p:cSld><p:spTree><p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr><p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="6858000" cy="9144000"/><a:chOff x="0" y="0"/><a:chExt cx="6858000" cy="9144000"/></a:xfrm></p:grpSpPr>{''.join(b.parts)}</p:spTree></p:cSld>
  <p:clrMapOvr><a:masterClrMapping/></p:clrMapOvr>
</p:notes>
"""


def content_types(count: int) -> str:
    overrides = [
        '<Override PartName="/ppt/presentation.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.presentation.main+xml"/>',
        '<Override PartName="/ppt/slideMasters/slideMaster1.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.slideMaster+xml"/>',
        '<Override PartName="/ppt/slideLayouts/slideLayout1.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.slideLayout+xml"/>',
        '<Override PartName="/ppt/notesMasters/notesMaster1.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.notesMaster+xml"/>',
        '<Override PartName="/ppt/theme/theme1.xml" ContentType="application/vnd.openxmlformats-officedocument.theme+xml"/>',
        '<Override PartName="/docProps/core.xml" ContentType="application/vnd.openxmlformats-package.core-properties+xml"/>',
        '<Override PartName="/docProps/app.xml" ContentType="application/vnd.openxmlformats-officedocument.extended-properties+xml"/>',
    ]
    for i in range(1, count + 1):
        overrides.append(f'<Override PartName="/ppt/slides/slide{i}.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.slide+xml"/>')
        overrides.append(f'<Override PartName="/ppt/notesSlides/notesSlide{i}.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.notesSlide+xml"/>')
    return f"""<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  {''.join(overrides)}
</Types>
"""


def rels_root() -> str:
    return """<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="ppt/presentation.xml"/>
  <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" Target="docProps/core.xml"/>
  <Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties" Target="docProps/app.xml"/>
</Relationships>
"""


def presentation_xml(count: int) -> str:
    slide_ids = "".join(f'<p:sldId id="{255 + i}" r:id="rId{i + 1}"/>' for i in range(1, count + 1))
    return f"""<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:presentation xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main">
  <p:sldMasterIdLst><p:sldMasterId id="2147483648" r:id="rId1"/></p:sldMasterIdLst>
  <p:sldIdLst>{slide_ids}</p:sldIdLst>
  <p:sldSz cx="{SLIDE_W}" cy="{SLIDE_H}" type="wide"/>
  <p:notesSz cx="6858000" cy="9144000"/>
  <p:defaultTextStyle/>
</p:presentation>
"""


def presentation_rels(count: int) -> str:
    rels = ['<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideMaster" Target="slideMasters/slideMaster1.xml"/>']
    for i in range(1, count + 1):
        rels.append(f'<Relationship Id="rId{i + 1}" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide" Target="slides/slide{i}.xml"/>')
    return f"""<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">{''.join(rels)}</Relationships>
"""


def slide_rels(i: int) -> str:
    return f"""<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout" Target="../slideLayouts/slideLayout1.xml"/>
  <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/notesSlide" Target="../notesSlides/notesSlide{i}.xml"/>
</Relationships>
"""


def notes_rels(i: int) -> str:
    return f"""<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide" Target="../slides/slide{i}.xml"/>
  <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/notesMaster" Target="../notesMasters/notesMaster1.xml"/>
</Relationships>
"""


def master_xml() -> str:
    return f"""<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:sldMaster xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main">
  <p:cSld><p:spTree><p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr><p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="{SLIDE_W}" cy="{SLIDE_H}"/><a:chOff x="0" y="0"/><a:chExt cx="{SLIDE_W}" cy="{SLIDE_H}"/></a:xfrm></p:grpSpPr></p:spTree></p:cSld>
  <p:clrMap bg1="lt1" tx1="dk1" bg2="lt2" tx2="dk2" accent1="accent1" accent2="accent2" accent3="accent3" accent4="accent4" accent5="accent5" accent6="accent6" hlink="hlink" folHlink="folHlink"/>
  <p:sldLayoutIdLst><p:sldLayoutId id="2147483649" r:id="rId1"/></p:sldLayoutIdLst>
  <p:txStyles><p:titleStyle/><p:bodyStyle/><p:otherStyle/></p:txStyles>
</p:sldMaster>
"""


def master_rels() -> str:
    return """<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout" Target="../slideLayouts/slideLayout1.xml"/>
  <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme" Target="../theme/theme1.xml"/>
</Relationships>
"""


def layout_xml() -> str:
    return f"""<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:sldLayout xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main" type="blank" preserve="1">
  <p:cSld name="Blank"><p:spTree><p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr><p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="{SLIDE_W}" cy="{SLIDE_H}"/><a:chOff x="0" y="0"/><a:chExt cx="{SLIDE_W}" cy="{SLIDE_H}"/></a:xfrm></p:grpSpPr></p:spTree></p:cSld>
  <p:clrMapOvr><a:masterClrMapping/></p:clrMapOvr>
</p:sldLayout>
"""


def layout_rels() -> str:
    return """<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideMaster" Target="../slideMasters/slideMaster1.xml"/>
</Relationships>
"""


def notes_master_xml() -> str:
    return """<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:notesMaster xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main">
  <p:cSld><p:spTree><p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr><p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="6858000" cy="9144000"/><a:chOff x="0" y="0"/><a:chExt cx="6858000" cy="9144000"/></a:xfrm></p:grpSpPr></p:spTree></p:cSld>
  <p:clrMap bg1="lt1" tx1="dk1" bg2="lt2" tx2="dk2" accent1="accent1" accent2="accent2" accent3="accent3" accent4="accent4" accent5="accent5" accent6="accent6" hlink="hlink" folHlink="folHlink"/>
  <p:notesStyle/><p:txStyles><p:titleStyle/><p:bodyStyle/><p:otherStyle/></p:txStyles>
</p:notesMaster>
"""


def notes_master_rels() -> str:
    return """<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme" Target="../theme/theme1.xml"/>
</Relationships>
"""


def theme_xml() -> str:
    return f"""<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<a:theme xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" name="OUC xv6">
  <a:themeElements>
    <a:clrScheme name="OUC"><a:dk1><a:srgbClr val="{NAVY}"/></a:dk1><a:lt1><a:srgbClr val="FFFFFF"/></a:lt1><a:dk2><a:srgbClr val="{DEEP}"/></a:dk2><a:lt2><a:srgbClr val="{LIGHT}"/></a:lt2><a:accent1><a:srgbClr val="{BLUE}"/></a:accent1><a:accent2><a:srgbClr val="{CYAN}"/></a:accent2><a:accent3><a:srgbClr val="{GREEN}"/></a:accent3><a:accent4><a:srgbClr val="{AMBER}"/></a:accent4><a:accent5><a:srgbClr val="{MUTED}"/></a:accent5><a:accent6><a:srgbClr val="{PANEL}"/></a:accent6><a:hlink><a:srgbClr val="{CYAN}"/></a:hlink><a:folHlink><a:srgbClr val="{BLUE}"/></a:folHlink></a:clrScheme>
    <a:fontScheme name="OUC"><a:majorFont><a:latin typeface="Microsoft YaHei"/><a:ea typeface="Microsoft YaHei"/><a:cs typeface="Microsoft YaHei"/></a:majorFont><a:minorFont><a:latin typeface="Microsoft YaHei"/><a:ea typeface="Microsoft YaHei"/><a:cs typeface="Microsoft YaHei"/></a:minorFont></a:fontScheme>
    <a:fmtScheme name="OUC"><a:fillStyleLst><a:solidFill><a:schemeClr val="accent1"/></a:solidFill></a:fillStyleLst><a:lnStyleLst><a:ln w="12700"><a:solidFill><a:schemeClr val="accent2"/></a:solidFill></a:ln></a:lnStyleLst><a:effectStyleLst><a:effectStyle><a:effectLst/></a:effectStyle></a:effectStyleLst><a:bgFillStyleLst><a:solidFill><a:schemeClr val="dk1"/></a:solidFill></a:bgFillStyleLst></a:fmtScheme>
  </a:themeElements>
  <a:objectDefaults/><a:extraClrSchemeLst/>
</a:theme>
"""


def core_props() -> str:
    return """<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcmitype="http://purl.org/dc/dcmitype/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <dc:title>OUC xv6 Lab Kit Final Defense</dc:title>
  <dc:creator>OUC Blue System Team</dc:creator>
  <dc:subject>OS Function Challenge proj54</dc:subject>
  <cp:keywords>xv6-riscv; OUC; proj54; reproducibility</cp:keywords>
  <dcterms:created xsi:type="dcterms:W3CDTF">2026-06-07T00:00:00Z</dcterms:created>
  <dcterms:modified xsi:type="dcterms:W3CDTF">2026-06-07T00:00:00Z</dcterms:modified>
</cp:coreProperties>
"""


def app_props(count: int) -> str:
    return f"""<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Properties xmlns="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties" xmlns:vt="http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes">
  <Application>Codex generated OpenXML</Application>
  <PresentationFormat>On-screen Show (16:9)</PresentationFormat>
  <Slides>{count}</Slides>
  <Notes>{count}</Notes>
  <Company>Ocean University of China</Company>
</Properties>
"""


def write_pptx(slides: list[SlideData]) -> None:
    with zipfile.ZipFile(OUTPUT, "w", compression=zipfile.ZIP_DEFLATED) as z:
        z.writestr("[Content_Types].xml", content_types(len(slides)))
        z.writestr("_rels/.rels", rels_root())
        z.writestr("ppt/presentation.xml", presentation_xml(len(slides)))
        z.writestr("ppt/_rels/presentation.xml.rels", presentation_rels(len(slides)))
        z.writestr("ppt/slideMasters/slideMaster1.xml", master_xml())
        z.writestr("ppt/slideMasters/_rels/slideMaster1.xml.rels", master_rels())
        z.writestr("ppt/slideLayouts/slideLayout1.xml", layout_xml())
        z.writestr("ppt/slideLayouts/_rels/slideLayout1.xml.rels", layout_rels())
        z.writestr("ppt/notesMasters/notesMaster1.xml", notes_master_xml())
        z.writestr("ppt/notesMasters/_rels/notesMaster1.xml.rels", notes_master_rels())
        z.writestr("ppt/theme/theme1.xml", theme_xml())
        z.writestr("docProps/core.xml", core_props())
        z.writestr("docProps/app.xml", app_props(len(slides)))
        for slide in slides:
            z.writestr(f"ppt/slides/slide{slide.number}.xml", build_slide(slide))
            z.writestr(f"ppt/slides/_rels/slide{slide.number}.xml.rels", slide_rels(slide.number))
            z.writestr(f"ppt/notesSlides/notesSlide{slide.number}.xml", build_notes_slide(slide))
            z.writestr(f"ppt/notesSlides/_rels/notesSlide{slide.number}.xml.rels", notes_rels(slide.number))


def main() -> None:
    slides = parse_slides(SOURCE.read_text(encoding="utf-8"))
    write_pptx(slides)
    print(f"[OK] wrote {OUTPUT}")
    print(f"[OK] slides: {len(slides)}")
    print(f"[OK] size: {OUTPUT.stat().st_size} bytes")


if __name__ == "__main__":
    main()

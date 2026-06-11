# Evidence Manifest

> 维护时间：2026-06-11，stage16 final defense PPT rebuild。
> 本文件是最终提交证据索引，不保存原始证据文件。视频、截图、console log、summary 原件均保存在仓库外，Git 仓库只保存文字摘要、外部位置、文件大小和 SHA256。

## Manifest Purpose

This manifest lets judges and teammates locate the final evidence set without committing raw evidence into Git. It records:

- current final engineering commit and integrated suite identity;
- lead and teammate full verification summaries;
- final video metadata and SHA256;
- external asset package location;
- historical evidence boundaries;
- non-committed evidence policy.

## Current Final Evidence: `db85947 / 0001-0009`

| 字段 | 内容 |
| --- | --- |
| final engineering commit | `db85947 feat(course): add lab runner and grading helpers` |
| evidence documentation commit | `caf8ced docs: record final db85947 evidence` |
| current integrated suite | `0001-0009` |
| historical checkpoint | `e8e2fb9 / 0001-0007` only as historical evidence |
| final verification | `rain / root / z2996` full verification all PASS |
| grade-summaries | 3 clean PASS, 0 needs attention |
| evidence SHA256 check | 14/14 matched |

## Integrated Suite Map

| Sequence | Content | Syscall numbers |
| --- | --- | --- |
| `0001-0007` | hello/add2/pstate/pcount/fcount/pgcount/fdcount | 22-28 |
| `0008` | Lab3 advanced `memstat()` address-space observation through `argaddr + copyout + struct ABI` | `SYS_memstat = 29` |
| `0009` | Lab4 advanced `fdinfo()` fd metadata observation through `argint + argaddr + copyout + struct ABI` | `SYS_fdinfo = 30` |

Boundary: `memstat` is not a complete memory-management implementation; `fdinfo` is not a complete file-system implementation; timeout capture is not long-term stability testing.

## Current Final Verification Summary

| Role | User | Mode | Result | External evidence |
| --- | --- | --- | --- | --- |
| team lead local verification | `rain` | full | PASS | `teammate_reproduction/db85947_final_0001_0009/teamlead_rain_db85947_full_20260610-221236.summary.txt` |
| teammate A | `root` | full | PASS | `teammate_reproduction/db85947_final_0001_0009/teammateA_root_db85947_full_20260611-080653.summary.txt` |
| teammate B | `z2996` | full | PASS | `teammate_reproduction/db85947_final_0001_0009/teammateB_z2996_db85947_full_20260610-221859.summary.txt` |

Current final verification covers:

```text
doctor/check-env/baseline/apply+make/boot/hello/add2test/pstatetest/pcounttest/pchildtest/fcounttest/pgcounttest/fdcounttest/memstattest/fdinfotest/overall
```

All listed items are recorded as PASS in the final external summaries. Raw summary files are ignored and not committed.

## Current Final Evidence Hashes

| Evidence file | SHA256 |
| --- | --- |
| `videos/20260611_final_integrated_0001_0009_demo.mp4` | `2A2C9863C185846225A98AC874499867A71588CED2020A64249CBF99C7BC0365` |
| `teammate_reproduction/db85947_final_0001_0009/teamlead_rain_db85947_full_20260610-221236.summary.txt` | `C0CBC292DD7C49E7016F4117871CC5F256D3554611E13DB5E8590020BB1DFD50` |
| `teammate_reproduction/db85947_final_0001_0009/teammateA_root_db85947_full_20260611-080653.summary.txt` | `8ED5BDE02B4B14DB94A12BE3C5EA29A76D933DB5649FB6335007BF0C291FFF87` |
| `teammate_reproduction/db85947_final_0001_0009/teammateA_root_db85947_full_20260611-081141.screenshot.jpg` | `86A57BED2A317CD3AB115676923FEFEC3422799793C7F233040B45C41675733C` |
| `teammate_reproduction/db85947_final_0001_0009/teammateB_z2996_db85947_full_20260610-221859.summary.txt` | `5F0973FB54B012C259F6A2E08F6C322F224E356EAFC4BB8A8F684474F941255E` |
| `teammate_reproduction/db85947_final_0001_0009/teammateB_z2996_db85947_full_20260610-222133.screenshot.png` | `E9AEF330994C496C2FD4A257596594732CBA3C0FCE2449C200187A9856FE6150` |

## Current Final Video Evidence

| 字段 | 内容 |
| --- | --- |
| filename | `20260611_final_integrated_0001_0009_demo.mp4` |
| repository display path | `videos/20260611_final_integrated_0001_0009_demo.mp4` |
| external path | `D:\Edge Download\CSCC\proj54_submission_assets\videos` |
| size | `31,529,984 bytes` |
| duration | `00:03:12` |
| resolution | `2560×1440` |
| frame rate | `60 fps` |
| created | `2026-06-11 08:26:36` |
| modified | `2026-06-11 08:29:50` |
| SHA256 | `2A2C9863C185846225A98AC874499867A71588CED2020A64249CBF99C7BC0365` |
| scope | current final integrated `0001-0009` verification demo for commit `db85947` |

## Final Presentation Deliverable

| 字段 | 内容 |
| --- | --- |
| PPT source | `slides/final_ppt.md` |
| PPT outline | `slides/final_ppt_outline.md` |
| PPT generator | `slides/generate_final_ppt.ps1` |
| PPTX file | `slides/final_defense_ppt.pptx` |
| PPTX size | `114,159 bytes` |
| slide count | 16 |
| speaker notes count | 16 |
| media embedding | none detected in `ppt/media/` after generation |
| review status | requires final human review and rehearsal before defense |

The PPTX is a presentation artifact, not raw verification evidence. It cites the final video metadata and SHA256 but does not embed the video, screenshots, summaries, console logs, or private materials.

## External Asset Package

| 字段 | 内容 |
| --- | --- |
| package directory | `proj54_submission_assets` |
| Baidu link | <https://pan.baidu.com/s/1Xt-G6VgP04eEAumqiMo7Uw?pwd=1234> |
| extraction code | `1234` |
| verification command after download | `XV6_EVIDENCE_BASE=<local path>/proj54_submission_assets bash scripts/check-evidence-sha256.sh` |

Expected external directories:

- `D:\Edge Download\CSCC\proj54_submission_assets\videos`
- `D:\Edge Download\CSCC\proj54_submission_assets\teammate_reproduction\db85947_final_0001_0009`
- `D:\Edge Download\CSCC\proj54_submission_assets\teammate_reproduction\e8e2fb9_final_0001_0007`
- `D:\Edge Download\CSCC\proj54_submission_assets\teammate_reproduction\historical_1ba9db6_0001_0005`

## Historical Evidence

### `e8e2fb9 / 0001-0007`

This is a historical stable checkpoint, superseded by current final `db85947 / 0001-0009`.

| Evidence | Status |
| --- | --- |
| lead `rain` full verify | PASS for `e8e2fb9 / 0001-0007` only |
| teammate `root` full verify | PASS for `e8e2fb9 / 0001-0007` only |
| teammate `z2996` full verify | PASS for `e8e2fb9 / 0001-0007` only |
| `20260606_final_integrated_0001_0007_demo.mp4` | historical video only |

Historical `0001-0007` video SHA256:

```text
0FF2D3581552B3FD3A2630E827251CF46C36BC3BE8F8B9D9DDB691FC0668A93B
```

### Earlier `1ba9db6 / 0001-0005` Evidence

Older teammate records and the three `20260606_*` videos are retained only as historical evidence for earlier workflows. They do not cover current final `db85947 / 0001-0009`.

## Non-Committed Evidence Policy

- Videos are not committed.
- Screenshots are not committed.
- Raw logs are not committed.
- Raw summary files are not committed.
- External xv6 source is not committed.
- `.claude/`, `.vscode/`, archives, private screenshots, passwords, tokens, and platform-private materials are not committed.
- Git stores metadata, summaries, source Markdown, generator code, and the final PPTX only.

## Remaining Manual Items

- Platform upload method: 待按官方要求确认。
- Video and screenshot privacy review: confirmed OK by user manual review.
- Teammate real names and OS versions: not fabricated; add only if required and confirmed.
- Final PPT rehearsal: still required before live defense.

# Demo Video Record

> 维护时间：2026-06-11，stage16 final defense PPT rebuild。
> 本文件只记录视频元数据、外部位置、SHA256 和提交边界，不保存视频文件本体。

## Current Status

| 项目 | 状态 |
| --- | --- |
| current integrated suite | `0001-0009` |
| final engineering commit | `db85947 feat(course): add lab runner and grading helpers` |
| evidence documentation commit | `caf8ced docs: record final db85947 evidence` |
| current final video | 已录制：`20260611_final_integrated_0001_0009_demo.mp4` |
| external asset package | `proj54_submission_assets` |
| video files tracked by Git | no |
| privacy review | 视频和截图已由用户人工确认 OK |
| platform upload method | 待按比赛平台要求确认 |

## Current Final Video: `db85947` / Integrated `0001-0009`

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
| Git policy | video file is stored outside Git and is not committed |
| hash check | `bash scripts/check-evidence-sha256.sh` reported `14/14 matched` in the final evidence set |

## External Asset Package

| 字段 | 内容 |
| --- | --- |
| package directory | `proj54_submission_assets` |
| Baidu link | <https://pan.baidu.com/s/1Xt-G6VgP04eEAumqiMo7Uw?pwd=1234> |
| extraction code | `1234` |
| expected contents | final video, teammate reproduction summaries/screenshots, historical evidence files |
| repository policy | only metadata and SHA256 are recorded in Git |

## Historical Video: `e8e2fb9` / Integrated `0001-0007`

This video is a historical stable checkpoint. It does not cover current final `db85947 / 0001-0009`.

| 字段 | 内容 |
| --- | --- |
| filename | `20260606_final_integrated_0001_0007_demo.mp4` |
| external path | `D:\Edge Download\CSCC\proj54_submission_assets\videos` |
| size | `12,120,565 bytes` |
| duration | `00:01:32` |
| resolution | `2560x1440` |
| frame rate | `60 fps` |
| created | `2026-06-07 07:59:04` |
| modified | `2026-06-07 08:00:37` |
| SHA256 | `0FF2D3581552B3FD3A2630E827251CF46C36BC3BE8F8B9D9DDB691FC0668A93B` |
| scope | integrated `0001-0007` verification demo for commit `e8e2fb9` |

## Earlier Historical Videos

The following videos only cover earlier `0001-0005` or stage7-stage8 workflows. They are kept as historical evidence and do not cover `db85947 / 0001-0009`.

| 文件名 | 用途 | 大小 | 时长 | 分辨率 | 帧率 | SHA256 |
| --- | --- | ---: | --- | --- | --- | --- |
| `20260606_auto_verify_demo.mp4` | historical auto verify demo | `13,355,208 bytes` | `00:01:48` | `2560x1440` | `60 fps` | `8EBC5974364780076172B19C9272B860DC56BF66DE9D08D5ECC8D20C8A236088` |
| `20260606_full_verify_demo.mp4` | historical full verify demo | `10,726,170 bytes` | `00:01:23` | `2560x1440` | `60 fps` | `1963B9FD66E6A25E9EADAA3C81FFC35E360F9D699F2C7CF6C707E85680B1EFE5` |
| `20260606_manual_xv6_shell_demo.mp4` | historical manual xv6 shell demo | `15,537,988 bytes` | `00:01:57` | `2560x1440` | `60 fps` | `2CD5DE43D3C262AB26A2A4251AE991ED973FA6A04FA8FD0B0178789563F5EE0B` |

## Compliance Boundary

- Do not commit `.mp4`, screenshots, raw logs, raw summaries, archives, or large binary evidence files.
- `slides/final_defense_ppt.pptx` does not embed the final video. It only cites the file name, external package, and SHA256.
- Video and screenshot privacy review has been manually confirmed OK by the user; platform upload method still needs final confirmation.
- `fcount()` / `fdcount()` / `fdinfo()` are file-table and fd-table observation experiments, not a complete file system.
- timeout capture proves expected-output matching and cleanup behavior for the reproduction scripts; it is not long-term stability testing.

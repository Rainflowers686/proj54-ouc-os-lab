# Demo Video Record

> 维护时间：2026-06-07（stage10a final evidence manifest）。
> 本文件只记录视频元数据和提交状态，不保存视频文件。

## Current Status

| 项目 | 状态 |
| --- | --- |
| final integrated `0001-0007` 视频 | 已录制并记录 SHA256 |
| historical videos | 保留 3 段历史视频元数据 |
| 视频文件是否入库 | 不入库 |
| 视频外部保存位置 | `D:\Edge Download\CSCC\proj54_submission_assets\videos` |
| 比赛平台提交方式 | 待确认 |
| 是否含隐私/密码/token | pending final manual review |

## Final Integrated `0001-0007` Video Evidence

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
| scope | final integrated `0001-0007` verification demo for commit `e8e2fb9` |
| Git policy | video file is stored outside Git and is not committed |

说明：该视频用于最终 commit `e8e2fb9 feat(integrated): add lab3 pgcount and lab4 fdcount workflow` 的 integrated `0001-0007` 演示。仓库只记录元数据与 SHA256；原始 `.mp4` 不入 Git。

## Historical Videos

以下三段视频录制于 final integrated `0001-0007` 之前，只覆盖 earlier integrated `0001-0005` / stage7-stage8 workflow，不覆盖 final `e8e2fb9`。

| 文件名 | 用途 | 大小 | 时长 | 分辨率 | 帧率 | SHA256 | Git 状态 |
| --- | --- | ---: | --- | --- | --- | --- | --- |
| `20260606_auto_verify_demo.mp4` | historical auto verify demo | `13,355,208 bytes` | `00:01:48` | `2560x1440` | `60 fps` | `8EBC5974364780076172B19C9272B860DC56BF66DE9D08D5ECC8D20C8A236088` | 不提交 Git |
| `20260606_full_verify_demo.mp4` | historical full verify demo | `10,726,170 bytes` | `00:01:23` | `2560x1440` | `60 fps` | `1963B9FD66E6A25E9EADAA3C81FFC35E360F9D699F2C7CF6C707E85680B1EFE5` | 不提交 Git |
| `20260606_manual_xv6_shell_demo.mp4` | historical manual xv6 shell demo | `15,537,988 bytes` | `00:01:57` | `2560x1440` | `60 fps` | `2CD5DE43D3C262AB26A2A4251AE991ED973FA6A04FA8FD0B0178789563F5EE0B` | 不提交 Git |

## Submission Notes

- 视频文件位于仓库外：`D:\Edge Download\CSCC\proj54_submission_assets\videos`。
- 本仓库只记录视频文件名、用途、大小、时长、分辨率、帧率、外部位置和 SHA256，不提交 `.mp4` 本体。
- 平台提交方式仍需按比赛官方要求确认。
- raw video files are stored outside Git and should be reviewed before platform upload.
- 最终上传前必须人工检查视频画面中没有 token、password、cookie、报名材料、私人聊天、未公开账号或其他隐私信息。
- 当前隐私复核状态：`pending final manual review`。

## Compliance Boundary

- 不提交 `.mp4`、`.mov`、`.avi`、`.mkv` 等视频文件到 Git。
- 不提交截图、压缩包或大型二进制文件到 Git。
- 视频中展示的运行结果必须来自真实命令；录屏证据和 timeout 自动捕获证据要分开描述。
- `fcount()` / `fdcount()` 只展示 file table / fd table 观察，不描述为完整文件系统实验。
- timeout/fast-exit 只说明复现脚本能捕获预期输出并退出，不描述为长期稳定性测试。

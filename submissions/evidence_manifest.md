# Evidence Manifest

> 维护时间：2026-06-07（stage10a final evidence manifest）。
> 本文件是最终证据索引，不保存原始证据文件。

## Manifest Purpose

本 manifest 集中记录最终提交证据的文字摘要、外部文件位置、文件大小、时间和 SHA256。它不是 raw evidence storage；视频、截图、console log、summary 原件仍保存在仓库外，不提交 Git。

## Final Commit

```text
e8e2fb9 feat(integrated): add lab3 pgcount and lab4 fdcount workflow
```

## Final Integrated Suite

| 序列 | 内容 |
| --- | --- |
| `0001-0007` | final integrated suite |
| `0006` | Lab3 `pgcount()` 页表映射数量观察 + eager/lazy allocation 对比 |
| `0007` | Lab4 v0.2 `fdcount()` 当前进程 fd table 观察 |
| Lab5 | capstone 综合复现实验，不是新增内核机制 |

## Final Verification Summary

| 角色 | user | mode | commit | integrated suite | result | 证据记录 |
| --- | --- | --- | --- | --- | --- | --- |
| team lead local verification | `rain` | `full` | `e8e2fb9` | `0001-0007` | PASS | `submissions/teammate_reproduction_record.md` |
| teammate A | `root` | `full` | `e8e2fb9` | `0001-0007` | PASS | external summary + screenshot metadata recorded |
| teammate B | `z2996` | `full` | `e8e2fb9` | `0001-0007` | PASS | external console log + screenshot metadata recorded |

所有 final verification 均覆盖：

```text
doctor/check-env/baseline/apply+make/boot/hello/add2test/pstatetest/pcounttest/pchildtest/fcounttest/pgcounttest/fdcounttest/overall
```

结果均为 PASS。

## Final Video Evidence

| 字段 | 内容 |
| --- | --- |
| filename | `20260606_final_integrated_0001_0007_demo.mp4` |
| external path | `D:\Edge Download\CSCC\proj54_submission_assets\videos` |
| size | `12,120,565 bytes` |
| duration | `00:01:32` |
| resolution | `2560x1440` |
| frame rate | `60 fps` |
| SHA256 | `0FF2D3581552B3FD3A2630E827251CF46C36BC3BE8F8B9D9DDB691FC0668A93B` |
| scope | final integrated `0001-0007` verification demo for commit `e8e2fb9` |

## Historical Evidence

| 证据 | 范围 | 状态 |
| --- | --- | --- |
| old teammate summaries at `1ba9db6` | earlier integrated `0001-0005` / stage7-stage8 workflow | historical / superseded |
| `20260606_auto_verify_demo.mp4` | earlier integrated `0001-0005` / stage7-stage8 workflow | historical / superseded |
| `20260606_full_verify_demo.mp4` | earlier integrated `0001-0005` / stage7-stage8 workflow | historical / superseded |
| `20260606_manual_xv6_shell_demo.mp4` | earlier integrated `0001-0005` / stage7-stage8 workflow | historical / superseded |

这些 historical evidence 不覆盖最终 commit `e8e2fb9` 的 integrated `0001-0007`。

## External Evidence Directories

| 目录 | 内容 |
| --- | --- |
| `D:\Edge Download\CSCC\proj54_submission_assets\videos` | final video and historical videos |
| `D:\Edge Download\CSCC\proj54_submission_assets\teammate_reproduction\e8e2fb9_final_0001_0007` | final teammate reproduction summary/log/screenshot evidence |
| `D:\Edge Download\CSCC\proj54_submission_assets\teammate_reproduction\historical_1ba9db6_0001_0005` | historical teammate evidence for earlier workflow |

## Non-Committed Evidence Policy

- Videos are not committed.
- Screenshots are not committed.
- Raw logs are not committed.
- Raw summary files are not committed.
- Git repository stores metadata and summaries only.
- `external/xv6-riscv/`, `logs/*.log`, `logs/*.summary.txt`, `logs/*.console.txt`, `.claude/`, `.vscode/`, videos, screenshots and large binary files must stay out of Git.

## Integrity Notes

- SHA256 hashes allow external file verification.
- No token/password/cookie should be included in final evidence files.
- Platform upload method still needs final confirmation.
- Privacy review status for videos/screenshots remains `pending final manual review` unless manually confirmed later.
- timeout capture is evidence of expected-output matching, not long-running stability testing.
- `fcount()` / `fdcount()` are file table / fd table observation experiments, not a complete file system.
- Lab5 is a capstone reproduction experiment, not a new kernel mechanism.

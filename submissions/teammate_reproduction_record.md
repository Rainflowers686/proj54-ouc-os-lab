# Teammate Reproduction Record

> 维护时间：2026-06-07（stage10a final evidence manifest）。
> 本文件只记录队友复现 summary 的文字摘要和外部证据元数据，不提交原始 `logs/` 文件、summary 文件、截图、终端历史或隐私材料。

## 记录目的

本记录用于证明最终 integrated `0001-0007` 工作流已经在队长本机和两位队友环境中完成 `full` verification。仓库只保留人工整理后的摘要、外部文件名、路径和 SHA256，避免把原始日志、截图、视频、账号信息或机器隐私提交到 Git。

正式复现命令：

```bash
bash scripts/xv6/teammate-verify.sh --full
```

## Final Verification For `e8e2fb9` / Integrated `0001-0007`

最终工程 commit：

```text
e8e2fb9 feat(integrated): add lab3 pgcount and lab4 fdcount workflow
```

最终 integrated suite：`0001-0007`

覆盖检查项：

| 检查项 | 结果 |
| --- | --- |
| doctor | PASS |
| check-env | PASS |
| baseline | PASS |
| apply+make | PASS |
| boot | PASS |
| hello | PASS |
| add2test | PASS |
| pstatetest | PASS |
| pcounttest | PASS |
| pchildtest | PASS |
| fcounttest | PASS |
| pgcounttest | PASS |
| fdcounttest | PASS |
| overall | PASS |

### A. Team Lead Local Verification

> 这是队长本机验证，不写成队友独立复现。

| 字段 | 内容 |
| --- | --- |
| user | `rain` |
| repo root | `/mnt/d/Edge Download/CSCC/proj54-ouc-os-lab` |
| current commit | `e8e2fb9 feat(integrated): add lab3 pgcount and lab4 fdcount workflow` |
| mode | `full` |
| summary file | `logs/teammate-verify-20260606-232145.summary.txt` |
| result | doctor/check-env/baseline/apply+make/boot/hello/add2test/pstatetest/pcounttest/pchildtest/fcounttest/pgcounttest/fdcounttest/overall 全 PASS |
| Git policy | raw summary file is ignored and not committed |

### B. Teammate A Final Verification

| 字段 | 内容 |
| --- | --- |
| 复现人 | 队友 A（终端 user: `root`，真实姓名待补充） |
| time | `2026-06-06T23:52:59+08:00` |
| repo root | `/root/workspace/proj54-ouc-os-lab` |
| current commit | `e8e2fb9 feat(integrated): add lab3 pgcount and lab4 fdcount workflow` |
| mode | `full` |
| user | `root` |
| interrupted | `NO` |
| summary file | `logs/teammate-verify-20260606-235139.summary.txt` |
| result | doctor/check-env/baseline/apply+make/boot/hello/add2test/pstatetest/pcounttest/pchildtest/fcounttest/pgcounttest/fdcounttest/overall 全 PASS |

外部证据文件（不入 Git）：

| 类型 | 文件 | SHA256 |
| --- | --- | --- |
| summary text | `D:\Edge Download\CSCC\proj54_submission_assets\teammate_reproduction\e8e2fb9_final_0001_0007\teammateA_root_e8e2fb9_full_20260606-235139.summary.txt` | `36E7A57554B524B11E99DF523AF54BCCBC2AA3E1682172899F5DA4A5EDAF90BE` |
| screenshot | `teammateA_root_e8e2fb9_full_20260606-235641.screenshot.png` | `4A3679274CA18B2E8BAEB9023C8D6DF7BE76738A5126C0F47ADAA3954ADC19D2` |

### C. Teammate B Final Verification

| 字段 | 内容 |
| --- | --- |
| 复现人 | 队友 B（终端 user: `z2996`，真实姓名待补充） |
| user | `z2996` |
| repo root shown as | `~/workspace/proj54-ouc-os-lab` |
| current commit | `e8e2fb9 feat(integrated): add lab3 pgcount and lab4 fdcount workflow` |
| mode | `full` |
| summary file shown | `logs/teammate-verify-20260607-114807.summary.txt` |
| result | doctor/check-env/baseline/apply+make/boot/hello/add2test/pstatetest/pcounttest/pchildtest/fcounttest/pgcounttest/fdcounttest/overall 全 PASS |

外部证据文件（不入 Git）：

| 类型 | 文件 | SHA256 |
| --- | --- | --- |
| console log | `D:\Edge Download\CSCC\proj54_submission_assets\teammate_reproduction\e8e2fb9_final_0001_0007\teammateB_z2996_e8e2fb9_full_20260607-114807.console.log` | `108A6F254E47049B54CAFDE007542A14BFC2586AC3BA18039E66B3EDF2A9A40E` |
| screenshot | `teammateB_z2996_e8e2fb9_full_20260607-115137.screenshot.png` | `7089C1175D6CE49AE8ADA712552C8053FFEE1643B9A3776899FD396D12C085EF` |

说明：队友 B 记录按用户提供的截图/log 摘要整理。若最终材料需要真实姓名、系统版本或更详细机器信息，应由队友补充，不在仓库中编造。

## Historical Evidence: `1ba9db6` / Earlier Integrated `0001-0005`

以下两份旧队友 full PASS summary 是 historical / superseded evidence，只能证明较早 commit `1ba9db6 tooling: speed up verification and clean repo hygiene` 上的 earlier integrated `0001-0005` / stage7-stage8 workflow，不覆盖最终 commit `e8e2fb9` 的 integrated `0001-0007`。

### Historical Teammate A / root

| 字段 | 内容 |
| --- | --- |
| 复现人 | 队友 A（终端 user: `root`，真实姓名待补充） |
| 时间 | `2026-06-06T19:15:02+08:00` |
| repo root | `/root/workspace/proj54-ouc-os-lab` |
| current commit | `1ba9db6 tooling: speed up verification and clean repo hygiene` |
| mode | `full` |
| interrupted | `NO` |
| summary file | `logs/teammate-verify-20260606-191352.summary.txt`（原始文件不入仓） |
| result | doctor/check-env/baseline/apply+make/boot/hello/add2test/pstatetest/pcounttest/pchildtest/fcounttest/overall 全 PASS |

### Historical Teammate B / z2996

| 字段 | 内容 |
| --- | --- |
| 复现人 | 队友 B（终端 user: `z2996`，真实姓名待补充） |
| 时间 | 来自截图/日志；精确时间戳待核对 |
| repo root | `/home/z2996/workspace/proj54-ouc-os-lab` |
| current commit | `1ba9db6 tooling: speed up verification and clean repo hygiene` |
| mode | `full` |
| interrupted | 待补充 |
| summary file | 截图/日志中显示为 `logs/teammate-verify-20260606-201839.summary.txt` 或相关 teammate summary log；精确原始文件不入仓 |
| result | doctor/check-env/baseline/apply+make/boot/hello/add2test/pstatetest/pcounttest/pchildtest/fcounttest/overall 全 PASS |

说明：历史队友 B 的记录基于队友提供的截图/log 摘要整理。若截图与日志中的时间戳或 summary 文件名存在不完全一致，最终报告中应写明“z2996 teammate full summary, timestamp from screenshot/log, exact raw file not committed”，不要补造不存在的原始文件。

## 诚信边界

- 不提交 `logs/*.log`。
- 不提交 `logs/*.summary.txt`。
- 不提交 `logs/*.console.txt`。
- 不提交截图、录屏、终端历史或个人隐私材料。
- 不记录 token、password、cookie、报名材料或未公开账号信息。
- 本记录基于队长本机 summary、队友提供的 summary 文本/截图/log 摘要和用户提供的 SHA256 元数据整理。
- 未知的真实姓名、系统版本和平台提交细节保持“待补充/待核对”，不编造。

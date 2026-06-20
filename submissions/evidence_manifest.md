# 证据清单（Evidence Manifest）

> 维护时间：2026-06-11，stage16 最终答辩 PPT 重做后同步。
> 本文件是最终提交证据索引，不保存原始证据文件。视频、截图、console log、summary 原件均保存在仓库外，Git 仓库只保存文字摘要、外部位置、文件大小和 SHA256。

## 目标

本文件用于让评委、队友和队长快速定位最终证据集，同时避免把原始视频、截图、summary、console log 等大文件或隐私材料提交进 Git。这里记录：

- 当前最终工程验证范围与 integrated suite 身份；
- 队长和两位队友的 full verification 摘要；
- 最终演示视频的元数据和 SHA256；
- 外部证据资产包位置；
- 历史证据 的边界；
- 不提交原始证据的仓库卫生策略。

## 适用对象

本文适用于评审、队长、队友、提交材料维护者和隐私复核人员。读者可通过本文确认当前正式验证范围、外部证据资产包、SHA256 核验命令和历史证据的使用边界。

## 内容范围

本文只记录证据索引和证据元数据，包括工程验证范围、证据文档状态、integrated suite、三方 full verification、最终视频、PPT 产物、外部资产包、历史证据和禁止入库材料。本文不保存视频、截图、summary 原件、console log 或外部 xv6 源码。

## 结构规范

证据条目必须包含范围、文件名、状态、外部位置和 SHA256；当前正式证据与历史证据必须分层；PPTX、视频和 summary 必须区分“展示材料”“原始证据”和“证据索引”。新增证据前，应同步检查 `scripts/check-evidence-sha256.sh`、`submissions/demo_record.md`、`submissions/teammate_reproduction_record.md` 和根 README 中的事实描述。

## 当前最终证据：`integrated 0001-0009`

| 字段 | 内容 |
| --- | --- |
| 当前 integrated suite | `0001-0009` |
| 历史证据范围 | `historical integrated 0001-0007`，只作为历史证据 |
| final verification | `rain / root / z2996` full verification 全部 PASS |
| grade-summaries | 3 clean PASS, 0 needs attention |
| evidence SHA256 check | 14/14 matched |

## integrated 补丁序列映射

| 序列 | 内容 | syscall 编号 |
| --- | --- | --- |
| `0001-0007` | hello/add2/pstate/pcount/fcount/pgcount/fdcount | 22-28 |
| `0008` | Lab3 进阶 `memstat()`：通过 `argaddr + copyout + struct ABI` 观察地址空间统计 | `SYS_memstat = 29` |
| `0009` | Lab4 进阶 `fdinfo()`：通过 `argint + argaddr + copyout + struct ABI` 观察单个 fd 元数据 | `SYS_fdinfo = 30` |

边界：`memstat` 不是完整内存管理实现；`fdinfo` 不是完整文件系统实现；timeout 捕获只能说明复现脚本能匹配预期输出，不能写成长期稳定性测试。

## 当前最终验证摘要

| 角色 | user | mode | result | 外部证据 |
| --- | --- | --- | --- | --- |
| 队长本机验证 | `rain` | full | PASS | 外部证据资产包中的当前 `integrated 0001-0009` 队长 summary |
| 队友 A | `root` | full | PASS | 外部证据资产包中的当前 `integrated 0001-0009` 队友 A summary |
| 队友 B | `z2996` | full | PASS | 外部证据资产包中的当前 `integrated 0001-0009` 队友 B summary |

当前正式 full verification 覆盖以下检查项：

```text
doctor/check-env/baseline/apply+make/boot/hello/add2test/pstatetest/pcounttest/pchildtest/fcounttest/pgcounttest/fdcounttest/memstattest/fdinfotest/overall
```

以上检查项均在外部 summary 中记录为 PASS。原始 summary 文件被 ignore，不提交到 Git。

## 当前最终证据哈希

| 证据文件 | SHA256 |
| --- | --- |
| `videos/20260611_final_integrated_0001_0009_demo.mp4` | `2A2C9863C185846225A98AC874499867A71588CED2020A64249CBF99C7BC0365` |
| 当前 `integrated 0001-0009` 队长 `rain` summary | `C0CBC292DD7C49E7016F4117871CC5F256D3554611E13DB5E8590020BB1DFD50` |
| 当前 `integrated 0001-0009` 队友 A `root` summary | `8ED5BDE02B4B14DB94A12BE3C5EA29A76D933DB5649FB6335007BF0C291FFF87` |
| 当前 `integrated 0001-0009` 队友 A `root` screenshot | `86A57BED2A317CD3AB115676923FEFEC3422799793C7F233040B45C41675733C` |
| 当前 `integrated 0001-0009` 队友 B `z2996` summary | `5F0973FB54B012C259F6A2E08F6C322F224E356EAFC4BB8A8F684474F941255E` |
| 当前 `integrated 0001-0009` 队友 B `z2996` screenshot | `E9AEF330994C496C2FD4A257596594732CBA3C0FCE2449C200187A9856FE6150` |

## 当前最终视频证据

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
| scope | integrated `0001-0009` verification demo |

## 最终答辩 PPT 产物

| 字段 | 内容 |
| --- | --- |
| PPT source | `slides/final_ppt.md` |
| PPT outline | `slides/final_ppt_outline.md` |
| PPT generator | `slides/generate_final_ppt.ps1` |
| PPTX file | `slides/final_defense_ppt.pptx` |
| PPTX size | `114,409 bytes` |
| slide count | 16 |
| speaker notes count | 16 |
| media embedding | 生成后 `ppt/media/` 未检测到嵌入媒体 |
| review status | 答辩前仍需人工最终审阅和排练 |

PPTX 是答辩展示材料，不是原始验证证据。它只引用最终视频元数据和 SHA256，不嵌入视频、截图、summary、console log 或隐私材料。

## 外部证据资产包

| 字段 | 内容 |
| --- | --- |
| package directory | `proj54_submission_assets` |
| Baidu link | <https://pan.baidu.com/s/1Xt-G6VgP04eEAumqiMo7Uw?pwd=1234> |
| extraction code | `1234` |
| 下载后核验命令 | `XV6_EVIDENCE_BASE=<local path>/proj54_submission_assets bash scripts/check-evidence-sha256.sh` |

预期外部目录：

- `D:\Edge Download\CSCC\proj54_submission_assets\videos`
- `D:\Edge Download\CSCC\proj54_submission_assets\teammate_reproduction\` 下的当前 `integrated 0001-0009` 证据目录
- `D:\Edge Download\CSCC\proj54_submission_assets\teammate_reproduction\` 下的历史 `integrated 0001-0007` 证据目录
- `D:\Edge Download\CSCC\proj54_submission_assets\teammate_reproduction\` 下的早期 `integrated 0001-0005` 证据目录

具体外部文件路径由 `scripts/check-evidence-sha256.sh` 维护并执行核验。本文正文只说明证据范围、哈希和值得核验的对象。

## 历史证据

### `historical integrated 0001-0007`

这是历史稳定证据，已被当前正式 `integrated 0001-0009` 覆盖。

| 证据 | 状态 |
| --- | --- |
| 队长 `rain` full verify | 只覆盖 `historical integrated 0001-0007` |
| 队友 `root` full verify | 只覆盖 `historical integrated 0001-0007` |
| 队友 `z2996` full verify | 只覆盖 `historical integrated 0001-0007` |
| `20260606_final_integrated_0001_0007_demo.mp4` | 仅作为 historical video |

historical `0001-0007` 视频 SHA256：

```text
0FF2D3581552B3FD3A2630E827251CF46C36BC3BE8F8B9D9DDB691FC0668A93B
```

### 更早的 `earlier integrated 0001-0005` 证据

更早的队友记录和三段 `20260606_*` 视频只作为早期工作流的历史证据保留，不覆盖当前正式 `integrated 0001-0009`。

## 不提交原始证据的边界

- 不提交视频本体。
- 不提交截图本体。
- 不提交 raw logs。
- 不提交 raw summary 文件。
- 不提交外部 xv6 源码。
- 不提交 `.claude/`、`.vscode/`、压缩包、私人截图、密码、token 或平台隐私材料。
- Git 仓库只保存元数据、摘要、Markdown 源稿、生成器代码和最终 PPTX。

## 剩余人工确认项

- 平台提交方式：待按官方要求确认。
- 视频和截图隐私复核：用户已人工确认 OK。
- 队友真实姓名和系统版本：不编造，如官方要求再补充。
- 最终 PPT 排练：答辩前仍需人工排练。

## 语言风格

本文使用证据管理语言，只记录可由命令、文件、哈希或人工确认支撑的事实。不得使用“长期稳定”“完全可靠”“完整内存管理”“完整文件系统”等超出证据范围的表述。

## 质量标准

本文应能支撑 README、技术报告、PPT、提交 checklist 和验收说明中的所有证据声明。任何 PASS、SHA256、视频元数据或队友复现结论都应能回到外部资产包或验证脚本输出。

## 边界条件

不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

# OUC xv6 Lab Kit

面向中国海洋大学操作系统课程的 xv6-riscv 分阶段实验指导、参考实现与可复现验证体系。

## 赛事与赛题

| 项目     | 内容                                                       |
| -------- | ---------------------------------------------------------- |
| 比赛     | 2026 全国大学生计算机系统能力大赛 - 操作系统设计赛（全国） |
| 赛道     | OS 功能挑战赛道                                            |
| 赛题     | proj54：面向操作系统课程的操作系统竞赛和实验               |
| 队伍     | 中国海洋大学“蓝色系统队”                                 |
| 项目定位 | 教学型实验包                                               |

本项目围绕“课程实验可教、可复现、可验证、可扩展”推进。当前不盲目新增内核功能，而是把 lab0/lab1/lab2/lab3/lab4、综合 patch、验证脚本、队友复现和提交文档整理成评委可快速理解的材料体系。

## 完成状态

| 模块                          | 当前状态                      | 说明                                                                                                                  |
| ----------------------------- | ----------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| lab0 baseline/build/boot      | 已完成                        | 环境检查、xv6 baseline metadata、make、boot evidence                                                                  |
| lab1 hello/add2               | 已完成                        | `hello()`、`add2(int,int)` syscall 入门与参数传递                                                                 |
| lab2 pstate/pcount/pchildtest | 已完成                        | 进程状态观察、状态计数、子进程状态观察                                                                                |
| lab3 pgcount                  | integrated 已完成             | 页表映射数量观察；eager/lazy allocation 对比；integrated `0006`                                                       |
| lab4 fcount/fdcount           | v0.2 已完成                   | 全局 file table 与当前进程 fd table 观察；不是完整文件系统实验                                                        |
| lab5 capstone                 | 已完成文档闭环                | 综合复现实验；组织 clean baseline、integrated `0001-0007`、make/boot/全部用户程序验证，不新增内核机制                 |
| integrated-labs 0001-0007     | 已完成                        | clean baseline 可顺序应用并 make；同一构建验证 hello/add2/pstate/pcount/pchild/fcount/pgcount/fdcount                 |
| verification scripts          | 已更新                        | `doctor.sh`、`teammate-verify.sh`、`local-verify.sh`、`cleanup-qemu.sh`；full/quick 覆盖 pgcounttest 和 fdcounttest |
| 队长本机验证                  | final full PASS               | `e8e2fb9` / integrated `0001-0007` local/full PASS；summary/raw logs 不入库                                           |
| 视频记录                      | final 视频已记录              | final integrated `0001-0007` 视频已记录大小、时长、SHA256；视频文件在仓库外，不提交 Git                             |
| 队友独立复现                  | final full PASS               | root 与 z2996 两份 `e8e2fb9` / integrated `0001-0007` full PASS 已记录；旧 `1ba9db6` 只作 historical evidence         |

## 评委快速复现

所有真实 `make` / QEMU / boot / 命令验证必须在 WSL2 Ubuntu 或等价 Linux 中执行。

```bash
bash scripts/xv6/doctor.sh
bash scripts/xv6/teammate-verify.sh --full
```

如果已经看到过 `[OK] make completed successfully`，二次重测可用：

```bash
bash scripts/xv6/teammate-verify.sh --quick
```

队长录屏前本地预检：

```bash
bash scripts/xv6/local-verify.sh --quick
```

卡住或误按 `Ctrl+Z` 后：

```bash
bash scripts/xv6/cleanup-qemu.sh
```

`teammate-verify.sh` 会输出 `COPY THIS SUMMARY TO TEAM LEAD` 块，并把 summary 写入 ignored 的 `logs/teammate-verify-*.summary.txt`。

## 正式文档导航

正式提交/评委入口位于 `docs/final/`：

| 文档                                                     | 内容                                           |
| -------------------------------------------------------- | ---------------------------------------------- |
| `docs/final/00_project_overview.md`                    | 项目定位、评分权重对应、完成状态、同类项目对比 |
| `docs/final/01_environment_setup.md`                   | WSL2/xv6 环境搭建与仓库卫生                    |
| `docs/final/02_lab0_baseline_build_boot.md`            | baseline build 与 boot 实验                    |
| `docs/final/03_lab1_hello_add2.md`                     | hello/add2 系统调用实验                        |
| `docs/final/04_lab2_process_observation.md`            | pstate/pcount/pchildtest 进程观察实验          |
| `docs/final/04b_lab3_page_table_observation.md`        | pgcount 页表映射数量观察实验                   |
| `docs/final/05_lab4_file_table_observation.md`         | fcount/fdcount 文件表与 fd 表观察实验          |
| `docs/final/06_testing_and_verification.md`            | 测试覆盖总表与证据边界                         |
| `docs/final/07_teammate_reproduction_guide.md`         | 队友复现指南                                   |
| `docs/final/08_design_decisions_and_tradeoffs.md`      | 设计取舍与风险控制                             |
| `docs/final/09_ai_usage_and_contribution_statement.md` | AI 使用与贡献说明                              |
| `docs/final/10_reference_and_license_statement.md`     | 引用与许可证说明                               |
| `docs/final/11_known_limits_and_future_work.md`        | 已知限制与后续计划                             |
| `docs/final/technical_report_v1.0.md`                  | 正式技术报告 v1.0 草案                         |
| `slides/final_ppt_outline.md`                          | 最终答辩 PPT 大纲                              |
| `slides/final_ppt.md`                                  | 最终答辩 PPT 源稿                              |
| `slides/final_defense_ppt.pptx`                        | 最终答辩 PPT 成稿                              |

提交材料索引见 `submissions/draft-report-index.md`；运行 `bash scripts/collect-report.sh` 可重新生成。

## 视频说明

最终 integrated `0001-0007` 视频已录制并记录 SHA256。旧三段视频保留为 historical evidence，只覆盖 earlier integrated `0001-0005` / stage7-stage8 workflow。所有视频文件保存在仓库外，不提交 Git。当前仓库只记录视频文件名、用途、大小、时长、SHA256、外部位置和边界说明：

```text
submissions/demo_record.md
submissions/evidence_manifest.md
```

视频不得包含 token、密码、个人隐私、报名材料或未公开账号信息；最终上传前隐私复核状态仍按 `pending final manual review` 处理，除非人工确认。

## 诚信与边界

- 不提交 `external/xv6-riscv/`、`logs/*.log`、`logs/*.summary.txt`、`.claude/`、`.vscode/`、视频、大文件或隐私材料。
- `patches/integrated-labs/0001-0007` 是当前已验证综合序列；`0006` 为 Lab3 `pgcount()`，`0007` 为 Lab4 v0.2 `fdcount()`。
- Lab5 是 capstone 综合复现实验，不是新的内核机制。
- timeout 自动捕获只证明脚本在真实 QEMU 输出中匹配到预期文本，不等同于长期稳定性测试。
- `fcount()` / `fdcount()` 只是 file table / fd table 计数观察，不是完整文件系统实验。
- `pcount(RUNNING)` 和 `fcount(...)` 的具体数字不固定；`pchildtest` 状态受调度时序影响。
- final commit `e8e2fb9` 已收到队长本机、队友 root、队友 z2996 三份 `--full` verification PASS 摘要；原始 summary/log/screenshot 不入仓。
- 旧 commit `1ba9db6` 的两份队友 PASS 与旧三段视频只作为 historical/superseded evidence，不覆盖 final integrated `0001-0007`。
- AI 可辅助规划、审查和文档/脚本落地；make/QEMU/PASS 结果必须来自真实命令。

## 已知限制与后续计划

- lab3 当前已进入 integrated `0006`，但仍只是页表映射数量观察，不是完整内存管理实验。
- lab4 当前为 file table / fd table 观察 v0.2，后续可扩展 inode、open-file summary 等内容。
- lab5 当前是 capstone 文档和综合复现闭环，不新增内核功能。
- 技术报告 v1.0、PPT 源稿和 PPTX 成稿已基于 `docs/final/` 整理；最终答辩前仍需人工审阅和排练。
- 队友真实姓名/系统版本、平台提交方式、视频/截图最终隐私复核、同类项目参考 URL 仍需最终补齐或人工确认。

# OUC xv6 Lab Kit

OUC xv6 Lab Kit 是面向操作系统课程的 xv6-riscv 分阶段实验包。项目把环境准备、系统调用、进程观察、页表观察、文件表观察和综合复现组织成一条可学习、可验证、可提交的实验路径，目标是让第一次接触内核实验的学生能从干净 xv6 源码开始，逐步理解 user/kernel 边界，并完成一次有证据的 full verification。

当前最终工程状态为 `db85947 / integrated 0001-0009`。该版本统一提供 `hello`、`add2`、`pstate`、`pcount`、`fcount`、`pgcount`、`fdcount`、`memstat` 和 `fdinfo`，syscall 编号为 22 到 30。rain、root、z2996 三方 `teammate-verify.sh --full` 已登记为 PASS，最终演示视频与 SHA256 已写入 [submissions/evidence_manifest.md](submissions/evidence_manifest.md)。

## 目标

本项目服务于 2026 全国大学生计算机系统能力大赛 OS 设计赛（全国）OS 功能挑战赛道 proj54。proj54 的核心是“面向操作系统课程的操作系统竞赛和实验”，因此本项目不追求把 xv6 改造成复杂内核，也不声称 LTP 覆盖，而是构建一套学生能学、教师能布置、助教能验收、评审能复现的课程实验体系。

项目采用“文档 + patch + 脚本 + 证据”的组织方式。`labs/` 提供学习路径，`patches/` 保存可回放实现，`scripts/` 提供复现与验收工具，`docs/` 保存正式文档和历史审查，`submissions/` 保存提交清单与证据索引。第三方 xv6 源码不进入仓库，本仓库只保存本队增量。

## 适用对象

本项目适合三类读者。学生可以按 Lab0 到 Lab5 顺序学习 xv6 入门机制；教师和助教可以直接使用 lab 教程、任务书、评分标准和排障手册布置课程；评审和队友复现人员可以通过 integrated patch sequence、验证脚本和 evidence manifest 审查项目状态。

本项目不适合作为“完整 OS 子系统实现”的示例，也不适合作为可直接提交的作业答案。每个 lab 的 `student_tasks.md` 都保留了需要学生独立完成和解释的任务。

## 内容范围

README 覆盖项目概述、适用对象、快速开始、Lab0-Lab5、integrated patch sequence、教师与评审入口、文档体系、仓库结构、证据状态、质量标准、边界条件和推荐阅读。它不替代每个 lab 的教程，也不保存 raw evidence。

## 结构规范

首页先给项目定位和 current final，再给快速开始、学习路径、patch map、提交材料、证据状态和边界条件。后续维护时，应优先更新证据索引和正式文档，再同步 README 中的摘要性事实。

## 语言风格

README 使用面向学生、教师和评审的中文技术说明语言。表达应短、准、可执行，保留必要命令和路径，不使用空泛赞美或无法验证的完成度描述。

## 快速开始

所有 make、QEMU 和 xv6 用户程序验证命令都应在 WSL2 Ubuntu 或等价 Linux 环境中运行。Windows Git Bash 和 PowerShell 可以阅读文档，但不适合直接运行 xv6 构建和 QEMU。

```bash
bash scripts/labctl.sh doctor        # 只读环境体检
bash scripts/labctl.sh setup --yes   # clean xv6 + integrated 0001-0009 + make
bash scripts/labctl.sh boot          # 捕获 boot 证据
bash scripts/labctl.sh test lab1     # 只跑 Lab1 检查
bash scripts/labctl.sh test all      # 跑全部用户程序检查
bash scripts/labctl.sh verify        # full verification，等价 teammate-verify.sh --full
```

`bash scripts/labctl.sh list` 可以查看 lab 与测试程序的对应关系。遇到 QEMU 卡住、timeout、`Ctrl+Z` 挂起或 `/mnt` 路径过慢，先运行 `bash scripts/labctl.sh clean`，再看 [docs/troubleshooting.md](docs/troubleshooting.md)。

## 学习路线

| 阶段 | 入口 | 学习目标 | 验收信号 |
| --- | --- | --- | --- |
| Lab0 | [labs/lab0-env-setup/README.md](labs/lab0-env-setup/README.md) | 建立环境、baseline、make 和 boot evidence | 捕获 `xv6 kernel is booting` 与 `init: starting sh` |
| Lab1 | [labs/lab1-system-call/README.md](labs/lab1-system-call/README.md) | 理解最小 syscall 与 `argint()` 参数读取 | `hello`、`add2test` 通过 |
| Lab2 | [labs/lab2-process-and-scheduling/README.md](labs/lab2-process-and-scheduling/README.md) | 观察进程表、状态枚举、锁和调度时序 | `pstatetest`、`pcounttest`、`pchildtest` 通过 |
| Lab3 | [labs/lab3-memory-and-pagetable/README.md](labs/lab3-memory-and-pagetable/README.md) | 观察页表映射数量，理解 eager/lazy allocation 和 copyout | `pgcounttest`、`memstattest` 通过 |
| Lab4 | [labs/lab4-file-system/README.md](labs/lab4-file-system/README.md) | 区分 fd、`struct file`、全局 file table 和 fd 元数据 | `fcounttest`、`fdcounttest`、`fdinfotest` 通过 |
| Lab5 | [labs/lab5-final-integration/README.md](labs/lab5-final-integration/README.md) | 从 clean baseline 完成综合复现与证据报告 | `teammate-verify.sh --full` overall PASS |

每个 lab 目录都有 `README.md` 和 `student_tasks.md`。前者是教程，后者是作业、验收标准和评分细则。建议先跑通教程中的验证命令，再做任务书中的改动和解释题。

## 你会学到什么

Lab1 让学生看到用户程序如何通过 `user/usys.pl` 生成的 stub、`ecall`、`kernel/syscall.c` 分发表和 `sys_*` 处理函数进入内核。Lab2 把同一条 syscall 路径连接到 `struct proc`、状态枚举和锁。Lab3 让学生区分进程地址空间大小和实际页表映射数量，并通过 `memstat` 看到结构体从内核安全拷回用户态。Lab4 让学生区分用户态 fd、当前进程 `ofile[]`、内核 `struct file` 和全局 file table。Lab5 训练学生把多个实验组织为可复现的工程证据。

这些实验也强调工程习惯：patch 应从声明的 baseline 应用，测试程序应真实计算 delta 而不是打印写死结果，summary 和日志应能追溯，第三方源码、raw logs、视频和隐私材料不应进入 Git。

## Integrated Patch Sequence

独立 patch 服务单 lab 教学，综合演示使用 [patches/integrated-labs/](patches/integrated-labs/) 中的 `0001-0009`。不要把多个 independent patch 直接叠加；它们常为单关教学复用 `SYS_* = 22`，组合路线必须使用 integrated sequence。

| Patch | 内容 | syscall |
| --- | --- | --- |
| `0001` | `hello()` 最小系统调用 | `SYS_hello = 22` |
| `0002` | `add2(int,int)` 参数读取 | `SYS_add2 = 23` |
| `0003` | `pstate(int)` 进程状态观察 | `SYS_pstate = 24` |
| `0004` | `pcount(int)` 与子进程状态观察 | `SYS_pcount = 25` |
| `0005` | `fcount()` 全局 file table 观察 | `SYS_fcount = 26` |
| `0006` | `pgcount()` 页表映射数量观察 | `SYS_pgcount = 27` |
| `0007` | `fdcount()` 当前进程 fd table 观察 | `SYS_fdcount = 28` |
| `0008` | `memstat(struct memstat*)` 地址空间结构体返回 | `SYS_memstat = 29` |
| `0009` | `fdinfo(int, struct fdinfo*)` fd 元数据结构体返回 | `SYS_fdinfo = 30` |

从 clean baseline 构建 integrated 版本：

```bash
bash scripts/xv6/apply-integrated-labs.sh --make --yes
```

该命令会重置 ignored 的 `external/xv6-riscv/`，按顺序应用 `0001-0009` 并运行 make。不要在 `external/xv6-riscv/` 中保存未提交的个人改动。

## 教师与助教使用

教师可以按 2 次、3 次或 5 次课使用本项目，具体安排见 [docs/teacher_guide.md](docs/teacher_guide.md)。评分原则见 [docs/grading_and_rubric.md](docs/grading_and_rubric.md)。建议验收时统一收 `bash scripts/xv6/teammate-verify.sh --full` 输出中的 `COPY THIS SUMMARY TO TEAM LEAD` 块，并结合学生 patch、报告和口头抽查判断理解程度。

`scripts/grade-summaries.sh` 可以批量解析 summary，标记 overall 与单项矛盾、缺新测试项、commit 不符和内容雷同等风险。它只是助教验收辅助工具，不自动打分。

## 评审与提交材料入口

评审或提交材料维护者可从以下文件进入：

- [docs/final/technical_report_v1.0.md](docs/final/technical_report_v1.0.md)：正式技术报告。
- [docs/final/](docs/final/)：项目概述、环境、各 lab、验证、复现、设计取舍、AI 使用、许可证和限制。
- [submissions/evidence_manifest.md](submissions/evidence_manifest.md)：最终证据索引。
- [submissions/submission_checklist.md](submissions/submission_checklist.md)：提交前自查清单。
- [slides/final_ppt.md](slides/final_ppt.md)：答辩 PPT 源稿。
- [slides/final_defense_ppt.pptx](slides/final_defense_ppt.pptx)：生成后的答辩 PPTX。

外部证据资产包不进入 Git。当前登记的外部目录为 `proj54_submission_assets`，百度网盘链接为 <https://pan.baidu.com/s/1Xt-G6VgP04eEAumqiMo7Uw?pwd=1234>，提取码 `1234`。下载后可运行：

```bash
XV6_EVIDENCE_BASE=<local path>/proj54_submission_assets bash scripts/check-evidence-sha256.sh
```

证据索引和 SHA256 以仓库内 [submissions/evidence_manifest.md](submissions/evidence_manifest.md) 及核验脚本为准，网盘只是原始大文件的存放位置。

## 文档体系

[docs/README.md](docs/README.md) 是文档导航，说明学生、教师、评审和历史追溯人员该读哪些文件。[docs/documentation_standard.md](docs/documentation_standard.md) 是本项目文档写作规范，规定目标、适用对象、内容范围、结构规范、语言风格、质量标准和边界条件。`docs/final/` 是正式提交文档，`docs/00` 到 `docs/25` 主要是历史计划、审查和过程记录。

后续维护文档时，应先确认当前工程事实，再更新正式文档和历史记录。旧阶段文档只能解释“当时为什么这样做”，不能覆盖 current final。

## 仓库结构

| 路径 | 作用 |
| --- | --- |
| `labs/` | 学生学习路径，每个 lab 有教程和任务书 |
| `patches/` | 独立 lab patch 与 integrated patch sequence |
| `scripts/` | 环境检查、应用补丁、启动 QEMU、运行测试、验收和门禁脚本 |
| `docs/` | 课程文档、正式提交文档、历史审查和排障材料 |
| `submissions/` | 提交清单、证据索引和复现记录 |
| `slides/` | 答辩 PPT 源稿、生成器和 PPTX |
| `videos/` | 视频说明；视频本体在外部证据资产包 |
| `external/` | 第三方 xv6 baseline 信息；源码本体不入 Git |
| `logs/` | 日志说明；raw logs 和 summary 原件不提交 |
| `references/` | 延伸阅读和参考资料说明 |

## 当前证据状态

| 项目 | 状态 |
| --- | --- |
| current final | `db85947 / integrated 0001-0009` |
| 证据文档 commit | `caf8ced docs: record final db85947 evidence` |
| full verification | rain、root、z2996 三方 PASS |
| grade-summaries | 3 clean PASS，0 needs attention |
| final video | `20260611_final_integrated_0001_0009_demo.mp4`，SHA256 已登记 |
| evidence hash check | `14/14 matched` |
| historical checkpoint | `e8e2fb9 / 0001-0007`，只作历史证据 |

证据边界必须保持清楚：`e8e2fb9 / 0001-0007` 不覆盖 `memstat` 和 `fdinfo`；`caf8ced` 是证据文档登记提交，不是工程复现基准；最终工程复现仍以 `db85947 / 0001-0009` 为准。

## 质量标准

本项目文档和报告遵循三条标准。技术事实必须可追溯到 patch、脚本、summary、视频元数据或 evidence manifest；复现命令必须能从 clean baseline 解释；历史证据和 current final 必须分离。修改 README 或正式文档后，至少运行：

```bash
git diff --check
bash scripts/check-docs-consistency.sh
bash scripts/check-final-hygiene.sh
```

需要核验外部证据时，再运行 `bash scripts/check-evidence-sha256.sh`，并设置 `XV6_EVIDENCE_BASE` 指向本地证据资产包。

## 边界条件

本项目不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、`.claude/`、`.vscode/`、压缩包、token 或隐私材料。`pgcount()` 和 `memstat()` 是内存/页表观察接口，不是完整内存管理；`fcount()`、`fdcount()` 和 `fdinfo()` 是 file/fd 观察接口，不是完整文件系统；Lab5 是 capstone 综合复现实验，不新增内核机制；timeout 自动捕获只说明一次匹配成功，不代表长期稳定性测试。

## 推荐阅读

完整阅读清单见 [references/README.md](references/README.md)。第一次学习时只建议先看赛题原文、MIT xv6 课程主页和 xv6-riscv book；完成 Lab1-Lab2 后，再根据兴趣阅读 rCore、uCore、PKE 和往届作品。外部资料用于理解课程组织和背景，不是本项目实现来源。

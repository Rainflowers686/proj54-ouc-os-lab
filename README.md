# OUC xv6 Lab Kit

OUC xv6 Lab Kit 是面向操作系统课程的 xv6-riscv 分阶段实验包。项目把环境准备、系统调用、进程观察、页表观察、文件表观察和综合复现组织成一条可运行、可讲解、可验收的课程路线。它服务于 2026 全国大学生计算机系统能力大赛 OS 设计赛（全国）OS 功能挑战赛道 proj54，核心目标是把“面向操作系统课程的操作系统竞赛和实验”落实为文档、patch、脚本和证据链。

current final 为 `db85947 feat(course): add lab runner and grading helpers`，integrated suite 为 `0001-0009`。该版本统一提供 `hello`、`add2`、`pstate`、`pcount`、`fcount`、`pgcount`、`fdcount`、`memstat` 和 `fdinfo`，syscall 编号为 22 到 30。rain、root、z2996 三方 `teammate-verify.sh --full` 已登记为 PASS，最终演示视频和 SHA256 记录在 [submissions/evidence_manifest.md](submissions/evidence_manifest.md)。

本仓库不保存第三方 xv6 源码本体。`external/xv6-riscv/` 是本地工作目录并被 Git 忽略，仓库只保存本队编写的 lab 文档、patch、脚本、提交材料和证据索引。

## 项目定位

本项目面向四类读者。学生可以按 Lab0 到 Lab5 学习 xv6 入门机制；教师和助教可以使用教程、任务书、评分标准和排障手册布置课程；队友复现人员可以用一条脚本从 clean baseline 验证 current final；评审可以通过正式报告、证据清单和复现脚本审查项目事实。

项目不把 xv6 改造成复杂内核，也不声称 LTP 覆盖。`pgcount()` 和 `memstat()` 是内存与页表观察接口，不是完整内存管理；`fcount()`、`fdcount()` 和 `fdinfo()` 是 file/fd 观察接口，不是完整文件系统；Lab5 是 capstone 综合复现实验，不新增内核机制。

## 快速开始

所有 xv6 构建、QEMU 和用户程序验证命令建议在 WSL2 Ubuntu 或等价 Linux 环境运行。Windows PowerShell 和 Git Bash 可用于阅读文档，不适合直接承担 xv6 构建与 QEMU 交互。

```bash
bash scripts/labctl.sh doctor        # 只读环境体检
bash scripts/labctl.sh setup --yes   # clean xv6 + integrated 0001-0009 + make
bash scripts/labctl.sh boot          # 捕获 boot 证据
bash scripts/labctl.sh test lab1     # 运行 Lab1 检查
bash scripts/labctl.sh test all      # 运行全部用户程序检查
bash scripts/labctl.sh verify        # full verification
```

`bash scripts/labctl.sh list` 会列出 lab 与测试程序的对应关系。遇到 QEMU 卡住、timeout、`Ctrl+Z` 挂起、`/mnt` 路径构建过慢或 patch 应用失败，先运行：

```bash
bash scripts/labctl.sh clean
bash scripts/labctl.sh doctor
```

常见问题见 [docs/troubleshooting.md](docs/troubleshooting.md)。

## 学习路线

| 阶段 | 入口 | 核心内容 | 验收信号 |
| --- | --- | --- | --- |
| Lab0 | [labs/lab0-env-setup/README.md](labs/lab0-env-setup/README.md) | 环境、baseline、make、QEMU boot | 捕获 `xv6 kernel is booting` 与 `init: starting sh` |
| Lab1 | [labs/lab1-system-call/README.md](labs/lab1-system-call/README.md) | 最小 syscall、`argint()`、user/kernel 边界 | `hello`、`add2test` 通过 |
| Lab2 | [labs/lab2-process-and-scheduling/README.md](labs/lab2-process-and-scheduling/README.md) | `struct proc`、进程状态、锁、调度观察 | `pstatetest`、`pcounttest`、`pchildtest` 通过 |
| Lab3 | [labs/lab3-memory-and-pagetable/README.md](labs/lab3-memory-and-pagetable/README.md) | 页表映射数量、地址空间大小、结构体 copyout | `pgcounttest`、`memstattest` 通过 |
| Lab4 | [labs/lab4-file-system/README.md](labs/lab4-file-system/README.md) | fd table、`struct file`、全局 file table、fd 元数据 | `fcounttest`、`fdcounttest`、`fdinfotest` 通过 |
| Lab5 | [labs/lab5-final-integration/README.md](labs/lab5-final-integration/README.md) | clean baseline 到 full verification 的综合复现 | `teammate-verify.sh --full` overall PASS |

每个 lab 目录都包含 `README.md` 和 `student_tasks.md`。`README.md` 是教程，`student_tasks.md` 是作业、验收标准和评分细则。建议学生先跑通教程中的命令，再完成任务书中的改动、解释题和报告。

## 学习目标

Lab1 让学生看到用户程序如何通过 `user/usys.pl` 生成的 stub、`ecall`、`kernel/syscall.c` 分发表和 `sys_*` 处理函数进入内核。Lab2 把同一条 syscall 路径连接到进程表、状态枚举和锁。Lab3 让学生区分进程地址空间大小与实际页表映射数量，并通过 `memstat` 观察结构体从内核安全拷回用户态。Lab4 让学生区分用户态 fd、当前进程 `ofile[]`、内核 `struct file` 和全局 file table。Lab5 训练学生把多个实验组织为可复现的工程证据。

这条路线强调工程习惯：patch 应从声明的 baseline 应用；测试程序应真实计算 delta，不能打印写死结果；summary、日志和视频元数据应能追溯；第三方源码、raw logs、summary 原件、视频、截图和隐私材料不进入 Git。

## Integrated Patch Sequence

单 lab 教学可使用 `patches/lab*/` 下的 independent patch。最终综合演示和队友复现使用 [patches/integrated-labs/](patches/integrated-labs/) 中的 `0001-0009`。不要把多个 independent patch 直接叠加，因为它们常为单关教学复用 syscall 编号。

integrated sequence 的 xv6 baseline 为 `74f84181a3404d1d6a6ff98d342233979066ebb8`。

| Patch | 内容 | syscall | 用户程序 |
| --- | --- | --- | --- |
| `0001` | `hello()` 最小系统调用 | `SYS_hello = 22` | `hello` |
| `0002` | `add2(int,int)` 参数读取 | `SYS_add2 = 23` | `add2test` |
| `0003` | `pstate(int)` 进程状态观察 | `SYS_pstate = 24` | `pstatetest` |
| `0004` | `pcount(int)` 与子进程状态观察 | `SYS_pcount = 25` | `pcounttest`、`pchildtest` |
| `0005` | `fcount()` 全局 file table 观察 | `SYS_fcount = 26` | `fcounttest` |
| `0006` | `pgcount()` 页表映射数量观察 | `SYS_pgcount = 27` | `pgcounttest` |
| `0007` | `fdcount()` 当前进程 fd table 观察 | `SYS_fdcount = 28` | `fdcounttest` |
| `0008` | `memstat(struct memstat*)` 地址空间结构体返回 | `SYS_memstat = 29` | `memstattest` |
| `0009` | `fdinfo(int, struct fdinfo*)` fd 元数据结构体返回 | `SYS_fdinfo = 30` | `fdinfotest` |

从 clean baseline 构建 integrated 版本：

```bash
bash scripts/xv6/apply-integrated-labs.sh --make --yes
```

该命令会重置 ignored 的 `external/xv6-riscv/`，按顺序应用 `0001-0009` 并运行 `make`。不要在 `external/xv6-riscv/` 保存未备份的个人改动。

## 验证体系

full verification 覆盖环境、baseline、patch 应用、make、boot、用户程序检查和 overall：

```text
doctor/check-env/baseline/apply+make/boot/hello/add2test/pstatetest/pcounttest/pchildtest/fcounttest/pgcounttest/fdcounttest/memstattest/fdinfotest/overall
```

核心命令为：

```bash
bash scripts/xv6/teammate-verify.sh --full
```

`scripts/labctl.sh verify` 是同一验证入口的课程化封装。`scripts/grade-summaries.sh` 可批量解析 summary，标记 overall 与单项矛盾、缺新测试项、commit 不符和内容雷同等风险。它是助教验收辅助工具，不自动打分。

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

## 教师与助教入口

教师可按 2 次、3 次或 5 次课使用本项目，安排建议见 [docs/teacher_guide.md](docs/teacher_guide.md)。评分原则见 [docs/grading_and_rubric.md](docs/grading_and_rubric.md)。建议验收时统一收 `bash scripts/xv6/teammate-verify.sh --full` 输出中的 `COPY THIS SUMMARY TO TEAM LEAD` 块，再结合学生 patch、报告和口头抽查判断理解程度。

课程使用时不要把本仓库直接当作作业答案发布。每个 lab 的 `student_tasks.md` 保留了学生需要独立完成和解释的任务。

## 评审与提交材料入口

评审或提交材料维护者可从以下文件进入：

| 文件 | 作用 |
| --- | --- |
| [docs/final/technical_report_v1.0.md](docs/final/technical_report_v1.0.md) | 正式技术报告 |
| [docs/final/](docs/final/) | 项目概述、环境、lab、验证、复现、设计取舍、AI 使用、许可证和限制 |
| [submissions/evidence_manifest.md](submissions/evidence_manifest.md) | 最终证据索引 |
| [submissions/submission_checklist.md](submissions/submission_checklist.md) | 提交前自查清单 |
| [slides/final_ppt.md](slides/final_ppt.md) | 答辩 PPT 源稿 |
| [slides/final_defense_ppt.pptx](slides/final_defense_ppt.pptx) | 生成后的答辩 PPTX |

外部证据资产包不进入 Git。当前登记的外部目录为 `proj54_submission_assets`，百度网盘链接为 <https://pan.baidu.com/s/1Xt-G6VgP04eEAumqiMo7Uw?pwd=1234>，提取码 `1234`。下载后可运行：

```bash
XV6_EVIDENCE_BASE=<local path>/proj54_submission_assets bash scripts/check-evidence-sha256.sh
```

证据索引和 SHA256 以 [submissions/evidence_manifest.md](submissions/evidence_manifest.md) 及核验脚本为准，网盘只作为原始大文件存放位置。

## 文档体系

[docs/README.md](docs/README.md) 是文档导航，说明学生、教师、评审和历史追溯人员该读哪些文件。[docs/documentation_standard.md](docs/documentation_standard.md) 是本项目文档写作规范。`docs/final/` 是正式提交文档，`docs/00` 到 `docs/25` 主要是历史计划、审查和过程记录。

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
| `tests/` | 各 lab 测试说明 |
| `references/` | 延伸阅读和参考资料说明 |
| `reproducibility/` | 复现说明入口 |

## 质量标准

项目文档和报告遵循五项标准：事实可追溯，命令可复现，读者路径清晰，历史与当前状态分离，边界不夸大。修改 README 或正式文档后，至少运行：

```bash
git diff --check
bash scripts/check-docs-consistency.sh
bash scripts/check-final-hygiene.sh
```

需要核验外部证据时，再运行 `bash scripts/check-evidence-sha256.sh`，并设置 `XV6_EVIDENCE_BASE` 指向本地证据资产包。

## 仓库边界

本项目不提交 `external/xv6-riscv/`、raw logs、summary 原件、console captures、视频、截图、`.claude/`、`.vscode/`、压缩包、token、密码或隐私材料。timeout 自动捕获只说明某次脚本匹配到预期输出，不代表长期稳定性测试。

AI 工具可用于规划、审查和文档辅助，但不能替代真实验证。所有 PASS、视频、summary 和 SHA256 均以实际证据、核验脚本和 [submissions/evidence_manifest.md](submissions/evidence_manifest.md) 为准。

## 推荐阅读

完整阅读清单见 [references/README.md](references/README.md)。第一次学习时建议先看赛题原文、MIT xv6 课程主页和 xv6-riscv book；完成 Lab1-Lab2 后，再根据兴趣阅读 rCore、uCore、PKE 和往届作品。外部资料用于理解课程组织和背景，不是本项目实现来源。

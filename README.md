# OUC xv6 Lab Kit：从零开始的操作系统实验

OUC xv6 Lab Kit 是一套面向 OS 课程的 xv6-riscv 入门实验包：按 Lab0-Lab5 一关一关走，逐步理解 syscall、进程、页表、fd/file 的关系，最后能从干净源码完成一次可复现的完整验证。它不假设你写过内核——做完之后，你能自己给内核加一个系统调用，并讲清它从用户态到内核态的完整路径。

## 如果你是第一次做 OS 实验，先看这里

- 别想着把整个仓库读完再动手，那样大概率三天后还在读文档。
- 先跑 Lab0：把 xv6 编译出来、在 QEMU 里启动、看到 `init: starting sh`。环境通了再谈别的。
- 然后做 Lab1 的 `hello`/`add2`，把"用户程序 → 内核 → 返回"这条链路走通一次，后面所有实验都是这条路的变体。
- 之后按顺序来：Lab2 看进程表，Lab3 看页表和 copyout，Lab4 看 fd/file 三层关系，Lab5 做综合复现。
- 每关先读 `labs/<lab>/README.md`（教程），再做 `student_tasks.md`（作业和验收标准）。
- 卡住了先查 [docs/troubleshooting.md](docs/troubleshooting.md)——里面是我们自己踩过的坑。不要上来就改 `patches/integrated-labs/` 里的最终集成补丁，那是全套验证的基线。

## 这是什么

- 一套基于 [xv6-riscv](https://github.com/mit-pdos/xv6-riscv) 的分阶段实验：Lab0 到 Lab5，外加一条把所有实验合在一个内核里的 integrated patch 路线（`0001-0009`）。
- 每个实验都是"小步增量"：一个 patch、一个用户测试程序、一组能照抄的验证命令。
- 所有实验都能从干净的 xv6 源码一键复现——这不是口号，仓库里有脚本（`scripts/xv6/`）替你做 reset、apply、make、boot、跑测试。
- 仓库不包含 xv6 源码本体（第三方代码不入库），只包含我们写的 patch、脚本、文档和测试记录。

## 适合谁

- 大一/大二，学过一点 C，但没碰过内核的同学。
- 有信息学竞赛背景，或有 C 语言和命令行基础、想提前接触操作系统的自学者——如果能看懂指针和结构体，可以先从 Lab0-Lab2 跟着走一遍；后面的页表、文件表实验再按自己的节奏补。
- 上 OS 课需要做 xv6 实验、想要一套带验收标准的练习的人。
- 想看一个"实验怎么做到可复现、证据怎么留"的完整工程样例的人。

不适合：想找现成大作业答案直接交的人。每个 lab 的 `student_tasks.md` 留了必做任务，答案要你自己写。

## 你会学到什么

按 Lab 顺序，每一关解决一个具体问题：

| 关卡        | 你会搞明白的事                                                                                                                                    |
| ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| Lab0        | xv6 怎么编译、怎么在 QEMU 里启动、`init: starting sh` 之前发生了什么                                                                            |
| Lab1        | 用户程序调用 `hello()` 时，怎么穿过 `usys.pl` 生成的 stub、`ecall`、`syscall.c` 分发表，落到内核函数上；`argint()` 怎么把整数参数取出来 |
| Lab2        | 进程在内核里长什么样（`struct proc`）、状态枚举怎么读、为什么观察进程状态要拿锁                                                                 |
| Lab3        | 进程地址空间和页表映射的区别；`sbrk` 立刻给页（eager）和先记账后给页（lazy）在页表里看起来差多少                                                |
| Lab4        | fd、`struct file`、全局 file table 三层关系；`dup` 为什么让 fd 变多但 file table 不一定变多                                                   |
| Lab3/4 进阶 | 内核怎么把一个结构体安全拷回用户态：`argaddr + copyout + struct ABI`（`memstat`/`fdinfo`），为什么不能直接解引用用户指针                    |
| Lab5        | 把前面所有实验从干净源码一次性复现，写出一份有证据的实验报告（capstone，不新增内核机制）                                                          |

另外你会顺带学到一套工程习惯：为什么实验要可复现、为什么测试程序要自己算 delta 而不是硬编码输出、为什么日志和第三方源码不进 Git。

## 从零开始怎么学

> 所有 make/QEMU 命令都要在 WSL2 Ubuntu 或等价 Linux 里跑，Windows Git Bash 只能看文档。环境装好前别急着跳关。

- **第 0 步：准备环境。** 看 [docs/final/01_environment_setup.md](docs/final/01_environment_setup.md)，装好 `qemu-system-riscv64` 和 RISC-V gcc，然后跑 `bash scripts/xv6/doctor.sh` 体检。
- **第 1 步：Lab0，把 xv6 跑起来。** [labs/lab0-env-setup/README.md](labs/lab0-env-setup/README.md)。看到 `init: starting sh` 这关就过了。
- **第 2 步：Lab1，第一个系统调用。** [labs/lab1-system-call/README.md](labs/lab1-system-call/README.md)。从 `hello()` 到带参数的 `add2(int, int)`。
- **第 3 步：Lab2，观察进程。** [labs/lab2-process-and-scheduling/README.md](labs/lab2-process-and-scheduling/README.md)。`pstate`/`pcount`/`pchildtest`。
- **第 4 步：Lab3，观察页表。** [labs/lab3-memory-and-pagetable/README.md](labs/lab3-memory-and-pagetable/README.md)。`pgcount` 数页，进阶 `memstat` 用 copyout 拷结构体。
- **第 5 步：Lab4，观察文件表。** [labs/lab4-file-system/README.md](labs/lab4-file-system/README.md)。`fcount`/`fdcount` 数数，进阶 `fdinfo` 看单个 fd 的元数据。
- **第 6 步：Lab5，综合复现。** [labs/lab5-final-integration/README.md](labs/lab5-final-integration/README.md)。把全部实验串成一次验收。
- **第 7 步：integrated `0001-0009`。** 一个内核同时装下全部 9 个实验 syscall（编号 22-30），入口见 [patches/integrated-labs/README.md](patches/integrated-labs/README.md)。

每个 lab 目录里有两个文件：`README.md` 是教程，`student_tasks.md` 是练习和验收标准。建议先读教程、跑通验证命令，再做任务。做完一关可以只测这一关：`bash scripts/labctl.sh test lab3`。

## 做实验前建议补的知识

不用全会再开始，缺哪补哪：

- **C 语言**：指针、结构体、头文件和函数声明。Lab3/Lab4 进阶要读 `copyout` 相关代码，指针不熟会很痛苦。
- **Linux shell / WSL**：能进目录、跑脚本、看日志输出。所有 make/QEMU 命令都在 WSL2 Ubuntu 里执行。
- **make 和 QEMU**：知道 `make` 在干什么、QEMU 是模拟器就够，细节实验里会碰到。
- **Git**：至少会 `clone`、`status`、`diff`、`apply`。我们的每个实验就是一个 patch。
- **xv6 教材**：不用通读，跟着实验进度看系统调用、进程、页表、文件描述符对应章节即可。
- **实验习惯**：一次只改一个点；失败了把现象记下来再动下一步；输出贴文本，不要拿截图当唯一证据。

## 推荐阅读

只放最常用的几个，每条都写了什么时候看。完整的分层清单（含往届作品、同学经验帖）在 [references/README.md](references/README.md)。

- [proj0 赛题原文](https://github.com/oscomp/proj0-contest-and-lab-for-os-course?tab=readme-ov-file#%E6%B3%A8%E6%84%8F%E4%BA%8B%E9%A1%B9-1)：这个题本来就是"面向 OS 课程的竞赛和实验"——想理解本项目为什么做成实验包，先看它。
- [MIT 6.1810（原 6.S081）](https://pdos.csail.mit.edu/6.1810/2025/)：xv6 的官方课程。做完 Lab1-Lab2 想系统学一遍时再去，别一开始就跳。
- [xv6-riscv-book-CN](https://github.com/shzhxh/xv6-riscv-book-CN)：xv6 教材中文翻译，英文版读不动时的台阶。
- [rCore Tutorial Book v3](https://rcore-os.github.io/rCore-Tutorial-Book-v3/)：想从"观察 OS"进阶到"从零写 OS"时看，完整得多的课程生态。
- [LearningOS rCore 2025S](https://github.com/LearningOS/rCore-Tutorial-Guide-2025S) / [uCore 2025S](https://github.com/LearningOS/uCore-Tutorial-Guide-2025S)：想跟一个有作业有验收的完整开源课程时选一条路线。
- [PKE 代理内核课程实验](https://gitee.com/hustos/pke-doc)：轻量实验设计思路，和我们"一个 patch 一关"的做法最接近，适合想自己设计实验的人。

## 如果你只想先跑起来

整个课程有一个统一命令入口 `labctl`（它只是封装下面的现有脚本，不重复实现任何逻辑）。在 WSL2 Ubuntu 里：

```bash
bash scripts/labctl.sh doctor        # 环境体检
bash scripts/labctl.sh setup --yes   # 干净源码 + 全部 9 个 patch + make（会重置 ignored 的 external/xv6-riscv/）
bash scripts/labctl.sh boot          # 启动并抓 boot 证据
bash scripts/labctl.sh test lab1     # 只跑 Lab1 的两条检查
bash scripts/labctl.sh test all      # 跑全部 10 条用户程序检查
bash scripts/labctl.sh verify        # 一键 full 验证（等价 teammate-verify.sh --full）
```

`bash scripts/labctl.sh list` 能看到每个 lab 对应哪些测试。想直接用底层脚本也完全可以（`scripts/xv6/` 下的路径都在 labctl help 里标着）。

卡住、报错、或者误按了 `Ctrl+Z`：先跑 `bash scripts/labctl.sh clean`，再看 [docs/troubleshooting.md](docs/troubleshooting.md)。`/mnt/` 路径下第一次 boot 偏慢是正常的。

## 如果你要把它拿去布置课程

- 教学顺序就按 Lab0-Lab5，2 次、3 次、5 次课的三种切法在 [docs/teacher_guide.md](docs/teacher_guide.md)，含每次课讲什么、怎么处理学生环境问题。
- 评分用 [docs/grading_and_rubric.md](docs/grading_and_rubric.md)：每个 lab 的任务书自带 100 分细则和常见扣分点。
- 复现验收统一收 `bash scripts/xv6/teammate-verify.sh --full` 输出的 `COPY THIS SUMMARY TO TEAM LEAD` 块；收齐后 `bash scripts/grade-summaries.sh logs/student-summaries/` 批量解析，它会把 overall 不一致、缺新测试项（旧 suite）、内容雷同的文件标出来——注意这只是辅助验收，最终评分仍按 rubric 和抽查。
- 提前说清边界，免得学生期望错位：这是观察型/入门型实验包，不是完整 OS 子系统实现，也不改调度器和文件系统布局。

## 如果你是评委或在看提交材料

为了方便评审和复现，集中入口如下：

- 证据总索引：[submissions/evidence_manifest.md](submissions/evidence_manifest.md)
- 技术报告：[docs/final/technical_report_v1.0.md](docs/final/technical_report_v1.0.md)
- 答辩 PPT 源稿：[slides/final_ppt.md](slides/final_ppt.md)（成稿 `slides/final_defense_ppt.pptx`）
- 正式文档目录：[docs/final/](docs/final/)，材料索引 [submissions/draft-report-index.md](submissions/draft-report-index.md)
- 外部证据资产包（演示视频、三方复现 summary/截图等大文件，不入 Git）：百度网盘目录 `proj54_submission_assets`，链接 [https://pan.baidu.com/s/1Xt-G6VgP04eEAumqiMo7Uw?pwd=1234](https://pan.baidu.com/s/1Xt-G6VgP04eEAumqiMo7Uw?pwd=1234)（提取码 `1234`）。下载后可用 `XV6_EVIDENCE_BASE=<解压路径> bash scripts/check-evidence-sha256.sh` 逐文件核对哈希——以仓库内 manifest 和该脚本为准，网盘只是文件的存放处。

比赛信息：2026 全国大学生计算机系统能力大赛 OS 设计赛（全国）OS 功能挑战赛道 proj54，中国海洋大学"蓝色系统队"。

## 为什么目录看起来比较多？

第一次打开仓库可能觉得目录不少，其实每个只管一件事：

- `labs/`：学生学习路径，每关一个教程 + 一份任务书。
- `patches/`：可回放的实现——每个实验就是一个能从干净源码 apply 的 patch。
- `scripts/`：复现和验收工具（`labctl` 入口、验证脚本、三道提交门禁）。
- `docs/`：课程文档、教师材料、排障和过程记录；`docs/final/` 是正式提交文档。
- `submissions/`：提交清单和证据索引。
- `slides/`：答辩材料（源稿 + 生成的 PPTX）。
- `videos/`：只放视频说明，视频本体在网盘。
- `external/`：只记录第三方源码来源和基线 commit，xv6 源码本体不入库。
- `logs/`：只放说明，原始日志一律不提交。
- `references/`：延伸阅读清单。

## 当前证据状态（诚实边界）

- 当前最终工程状态 = `db85947 / 0001-0009`（hello=22 … fdinfo=30，连续编号）：rain/root/z2996 三方 `teammate-verify.sh --full` 全 PASS，新演示视频与 SHA256 已登记（详见 [submissions/evidence_manifest.md](submissions/evidence_manifest.md)）。
- `caf8ced` 只是证据文档登记提交，用于记录 final demo、三方复现、SHA256 和外部资产索引；工程复现仍以 `db85947 / 0001-0009` 为准。
- `e8e2fb9 / 0001-0007` 的三方 full PASS 和旧视频 = **historical stable checkpoint**，只覆盖 `0001-0007`，保留不删但不作为 current final。
- 一直成立的边界：`pgcount`/`memstat` 不是完整内存管理，`fcount`/`fdcount`/`fdinfo` 不是完整文件系统，Lab5 不新增内核机制，QEMU timeout 捕获不等于长期稳定性测试。
- 不入 Git 的东西：`external/xv6-riscv/`、`logs/`、视频、截图、`.claude/`、`.vscode/`、隐私材料。提交前三道自查：`bash scripts/check-final-hygiene.sh`（仓库卫生）、`bash scripts/check-docs-consistency.sh`（文档与脚本状态一致）、`bash scripts/check-evidence-sha256.sh`（外部证据哈希）。

---

最后说一句：这套实验包是我们一边踩坑一边整理出来的。给测试程序起名 `pstatechildtest` 结果 `mkfs` 直接构建失败（xv6 的 `DIRSIZ` 限制文件名长度，后来改成了 `pchildtest`）；把 lab2 的 patch 往 lab1 上叠，`git apply` 当场报错，才实测确认了 independent patch 之间 `SYS_*=22` 的编号冲突；`/mnt` 路径下第一次 boot 慢到以为卡死。这些坑的现象和解法都写进了 [docs/troubleshooting.md](docs/troubleshooting.md) 和各 lab 的"常见卡点"，希望你比我们少走点弯路。

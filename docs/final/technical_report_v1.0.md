# OUC xv6 Lab Kit 技术报告 v1.0

## 目标

本报告面向评审和课程维护者，系统说明 OUC xv6 Lab Kit 的项目定位、实验体系、实现路线、验证证据、教学价值和边界条件。报告目标不是替代每个 lab 的操作教程，而是给出可审查的总体论证。

## 适用对象

本报告适用于 OS 功能挑战赛评审、指导教师、答辩准备人员和后续维护者。学生第一次学习本项目时应优先阅读根 `README.md`、`docs/README.md` 和各 lab 的教程。

## 摘要

OUC xv6 Lab Kit 是面向中国海洋大学操作系统课程的 xv6-riscv 分阶段实验包。项目围绕 proj54“面向操作系统课程的操作系统竞赛和实验”要求，构建从环境准备、系统调用、进程观察、页表观察、文件表观察到综合复现的教学链条。它不以复杂内核功能堆叠为目标，而以学生可理解、教师可布置、队友可复现、评审可审查为核心标准。

current final 为 `db85947 / integrated 0001-0009`。该序列统一提供 `hello`、`add2`、`pstate`、`pcount`、`fcount`、`pgcount`、`fdcount`、`memstat` 和 `fdinfo`，syscall 编号为 22 到 30。rain、root、z2996 三方 full verification 已登记为 PASS，最终演示视频和 SHA256 已记录在 `submissions/evidence_manifest.md`。historical `e8e2fb9 / 0001-0007` 只作为历史稳定检查点。

## 赛题理解与项目定位

proj54 的关键词是课程、竞赛和实验。因此，本项目把重点放在课程实验体系，而不是把 xv6 改造成复杂内核或追求 LTP 覆盖。项目直接读者是第一次接触 xv6 的低年级学生，同时兼顾教师布置、助教验收和比赛评审。

项目材料按“文档 + patch + 脚本 + 证据”组织。`labs/` 提供学生学习路径，`patches/` 保存可回放实现，`scripts/` 提供复现和验收工具，`docs/` 保存正式材料与历史审查，`submissions/` 保存证据索引。第三方 xv6 源码位于本地 `external/xv6-riscv/`，不进入 Git。

## 实验体系

Lab0 建立环境和 baseline，让学生先确认工具链、make 和 QEMU boot 可用。Lab1 从 `hello()` 和 `add2(int,int)` 进入系统调用路径，覆盖 `usys.pl` stub、`ecall`、`syscall.c` 分发表和 `argint()`。Lab2 通过 `pstate`、`pcount` 和 `pchildtest` 观察进程表、状态枚举、锁和调度时序。Lab3 通过 `pgcount()` 区分地址空间大小与实际页表映射，并用 `memstat()` 展示结构体 copyout。Lab4 通过 `fcount()`、`fdcount()` 和 `fdinfo()` 区分用户 fd、当前进程 fd table、内核 `struct file` 和全局 file table。Lab5 将所有内容组织为 clean baseline 到 full verification 的 capstone 综合复现。

这一路径的教学逻辑是“先走通，再观察，再解释，再复现”。学生不需要在一开始理解完整内核，只需要在每个 lab 中掌握一个可运行机制，并用验证命令证明自己看到的现象。

## Integrated Patch Sequence

最终综合序列从 clean xv6 baseline `74f84181a3404d1d6a6ff98d342233979066ebb8` 出发，按 `0001` 到 `0009` 应用 patch：

| Patch | 内容 | syscall |
| --- | --- | --- |
| `0001` | `hello()` | `SYS_hello = 22` |
| `0002` | `add2(int,int)` | `SYS_add2 = 23` |
| `0003` | `pstate(int)` | `SYS_pstate = 24` |
| `0004` | `pcount(int)` 和子进程观察 | `SYS_pcount = 25` |
| `0005` | `fcount()` | `SYS_fcount = 26` |
| `0006` | `pgcount()` | `SYS_pgcount = 27` |
| `0007` | `fdcount()` | `SYS_fdcount = 28` |
| `0008` | `memstat(struct memstat*)` | `SYS_memstat = 29` |
| `0009` | `fdinfo(int, struct fdinfo*)` | `SYS_fdinfo = 30` |

独立 patch 仍用于单 lab 教学，integrated sequence 用于最终演示和队友复现。两条路线的边界必须区分，不能把 independent patch 互相叠加。

## 验证体系

项目提供 `doctor.sh`、`apply-integrated-labs.sh`、`boot-xv6.sh`、`run-xv6-command.sh`、`teammate-verify.sh`、`local-verify.sh`、`cleanup-qemu.sh` 和 `labctl.sh`。full verification 覆盖环境、baseline、patch 应用、make、boot、十个用户程序检查和 overall。

核心复现命令为：

```bash
bash scripts/xv6/teammate-verify.sh --full
```

current final 已由 rain、root、z2996 三方 full verification PASS，并由 `grade-summaries` 解析为 3 clean PASS。最终视频 `20260611_final_integrated_0001_0009_demo.mp4` 覆盖 current final，SHA256 已登记。视频、截图、summary 原件和 raw logs 不进入 Git，只在 evidence manifest 中记录元数据和哈希。

## 教学材料与课程使用

每个 lab 均提供教程式 README 和 `student_tasks.md`，教师材料包括 `docs/teacher_guide.md`、`docs/grading_and_rubric.md` 和 `docs/troubleshooting.md`。教师可按两次、三次或五次课安排实验。验收建议收 `teammate-verify.sh --full` 的 summary 块，并结合 patch、报告和口头抽查评分。

本项目强调报告中的真实失败记录。一个没有命令、没有输出、没有故障处理、只有最终 PASS 的报告，无法体现可复现能力。

## 贡献与创新

项目贡献主要体现在课程化组织、clean-baseline patch workflow、integrated `0001-0009`、队友一键复现、证据分层和边界表达。`memstat` 与 `fdinfo` 的加入补齐了入门 syscall 实验常缺失的结构体 copyout 教学点，使学生能接触接近真实内核接口的用户缓冲区写回模式。

项目的创新不是替代 uCore、rCore 或完整 OS 课程，而是在 OUC 本校语境下，把 xv6-riscv 入门实验做成可部署、可验收、可提交的轻量课程包。

## AI 使用与许可证

AI 工具用于规划、审查、文档整理和材料生成辅助，不替代真实验证。所有 PASS、视频、summary 和 SHA256 均以实际证据为准。项目基于 MIT PDOS `xv6-riscv`，上游源码不入仓；本队提交的是 patch、脚本、文档和证据索引。

## 已知限制

`pgcount` 和 `memstat` 不是完整内存管理；`fcount`、`fdcount` 和 `fdinfo` 不是完整文件系统；Lab5 不新增内核机制；timeout evidence 不是长期稳定性测试。平台提交方式、最终 PPT 排练、外部参考许可证核对仍需按实际提交要求继续确认。

## 结论

OUC xv6 Lab Kit 已形成从学习路径、实现补丁、自动化复现、队友验证到正式提交材料的闭环。项目用有限而清晰的内核观察接口，把操作系统课程中最难入门的 user/kernel 边界、进程表、页表和文件表变成学生可以运行、解释和复现的实验。其价值在于教学可用性和证据可信度，而不是夸大内核功能范围。

## 质量标准

本报告中的完成状态必须能追溯到 `patches/`、`scripts/`、`docs/final/` 或 `submissions/evidence_manifest.md`。涉及验证结果时，应同时说明 commit、suite、命令和证据位置。涉及教学价值时，应说明对应 lab、概念和学生可观察现象。

## 边界条件

本报告不保存 raw logs、summary 原件、视频或截图，不替代 evidence manifest。若报告内容与 `submissions/evidence_manifest.md` 或当前仓库脚本冲突，以证据索引和脚本状态为准。

## 内容范围

本文内容限定在当前标题所对应的项目记录、教学说明、复现步骤或审查结论内。涉及 current final、historical checkpoint、验证命令和证据材料时，应以 `submissions/evidence_manifest.md`、`patches/integrated-labs/README.md` 和相关脚本为准。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 current final。

## 语言风格

使用中文技术写作风格，命令、文件名、commit、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

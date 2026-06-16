# Step-by-Step 学习指南

## 目标

本文提供从零开始完成 OUC xv6 Lab Kit 的最短可靠路线。它不替代各 lab 的详细说明，只给出学习顺序、命令入口和每一步的验收信号。

## 适用对象

适用于第一次接触 xv6、WSL2、QEMU 或内核实验的学生。已有 Linux 和 xv6 基础的读者可以跳到对应 lab。

## 学习路径

先在 WSL2 Ubuntu 或 Linux 中运行 `bash scripts/labctl.sh doctor`，确认工具链、QEMU 和路径状态。再运行 Lab0，目标是看到 xv6 boot 证据。之后按 Lab1、Lab2、Lab3、Lab4 和 Lab5 顺序学习，每关先读 `labs/<lab>/README.md`，再完成 `student_tasks.md`。

## 推荐命令

常用入口是 `bash scripts/labctl.sh help`、`bash scripts/labctl.sh setup --yes`、`bash scripts/labctl.sh boot`、`bash scripts/labctl.sh test lab1` 和 `bash scripts/labctl.sh verify`。需要最终复现时使用 `bash scripts/xv6/teammate-verify.sh --full`。

## 质量标准

每做完一关，应能回答三个问题：改了哪些 xv6 文件，用户程序输出为什么成立，失败时如何定位。报告中应记录真实命令和输出，不只贴截图。

## 边界条件

不要从旧过程记录开始学习，不要把 independent patch 互相叠加，不要在 Windows Git Bash 中运行 make/QEMU。遇到卡顿先查 `docs/troubleshooting.md`，尤其是 `/mnt` 路径慢和 `Ctrl+Z` 挂起问题。

## 内容范围

本文内容限定在当前标题所对应的项目记录、教学说明、复现步骤或审查结论内。涉及 current final、historical checkpoint、验证命令和证据材料时，应以 `submissions/evidence_manifest.md`、`patches/integrated-labs/README.md` 和相关脚本为准。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 current final。

## 语言风格

使用中文技术写作风格，命令、文件名、commit、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

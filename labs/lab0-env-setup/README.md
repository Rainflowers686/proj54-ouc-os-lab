# Lab0 环境与 Baseline 建立

## 目标

Lab0 用于建立可信实验环境。学生应在修改 xv6 前完成工具链检查、baseline 识别、clean build 和 boot evidence 捕获，确认后续实验不是建立在不确定环境上。

## 适用对象

本实验适用于第一次运行 OUC xv6 Lab Kit 的学生、助教和复现人员。未完成 Lab0 前，不建议继续 Lab1 到 Lab5。

## 内容范围

Lab0 覆盖 WSL2 Ubuntu 或 Linux 环境、`git`、`make`、QEMU、RISC-V gcc、xv6-riscv baseline commit 和 boot evidence。它不修改内核源码，不新增 syscall。

## 学习结构

先运行 `bash scripts/labctl.sh doctor` 做只读诊断，再通过 `bash scripts/labctl.sh setup --yes` 准备 clean xv6 和 integrated patches，最后运行 `bash scripts/labctl.sh boot` 捕获 `xv6 kernel is booting` 与 `init: starting sh`。需要底层命令时，可使用 `scripts/xv6/doctor.sh`、`check-xv6-baseline.sh` 和 `boot-xv6.sh`。

## 验证命令

```bash
bash scripts/labctl.sh doctor
bash scripts/labctl.sh setup --yes
bash scripts/labctl.sh boot
```

## 语言风格

报告应直接记录环境、命令、输出和失败处理，不使用“环境应该没问题”这类无法验证的判断。

## 质量标准

合格报告需要包含系统环境、baseline commit、make 结果、boot 关键文本和遇到故障时的排查过程。若在 `/mnt` 路径运行，应说明首次 boot 可能较慢。

## 边界条件

Lab0 只证明环境和 baseline 可用，不证明后续 syscall 已存在。不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

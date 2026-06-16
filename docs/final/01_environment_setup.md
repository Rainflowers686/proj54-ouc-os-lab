# 01 Environment Setup

## 目标

本文说明运行 OUC xv6 Lab Kit 所需的基础环境，并给出首轮诊断命令。环境目标是能 clone 仓库、应用 patch、构建 xv6、启动 QEMU 并运行用户程序。

## 适用对象

适用于第一次运行本项目的学生、队友和评审复现人员。

## 前置条件

建议使用 WSL2 Ubuntu 或等价 Linux 环境。Windows Git Bash 和 PowerShell 可阅读文档，但不适合直接运行 xv6 make/QEMU 流程。

## 安装建议

在 Ubuntu 中安装基本工具：

```bash
sudo apt update
sudo apt install git make qemu-system-misc gcc-riscv64-linux-gnu
```

`riscv64-unknown-elf-gcc` 缺失在本项目脚本中通常是 WARN，不是阻断项；`riscv64-linux-gnu-gcc` 可满足当前 xv6 构建。

## 诊断命令

```bash
bash scripts/labctl.sh doctor
```

若需直接调用底层脚本：

```bash
bash scripts/xv6/doctor.sh
```

## 质量标准

环境文档应让读者能判断缺少哪个工具、是否位于 `/mnt` 慢路径、是否有 QEMU 残留进程。诊断结果为 READY 或 READY WITH WARNINGS 后，再进入 Lab0。

## 边界条件

环境检查不等于 full verification。`doctor` 不运行 make 和 QEMU 用户程序，只做只读诊断。

## 内容范围

本文内容限定在当前标题所对应的项目记录、教学说明、复现步骤或审查结论内。涉及 current final、historical checkpoint、验证命令和证据材料时，应以 `submissions/evidence_manifest.md`、`patches/integrated-labs/README.md` 和相关脚本为准。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 current final。

## 语言风格

使用中文技术写作风格，命令、文件名、commit、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

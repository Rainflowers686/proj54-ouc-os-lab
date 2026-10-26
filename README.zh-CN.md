<div align="center">

# **OUC xv6 Lab Kit**

中国海洋大学操作系统课程的六个 xv6-riscv 实验。

从一份内核补丁跟到一次 QEMU 验证，结合实验说明、测试和复现记录理解修改如何生效。

![xv6-riscv](https://img.shields.io/badge/xv6-RISC--V-5A4FCF)
![C](https://img.shields.io/badge/Language-C-A8B9CC?logo=c&logoColor=white)
![Course learning kit](https://img.shields.io/badge/Type-Course%20learning%20kit-687078)

[English](README.md) · [简体中文](README.zh-CN.md)

[从哪里开始](#从哪里开始) · [环境与复现](#环境与复现) · [实验导航](#实验导航) · [文档](#项目文档) · [参与贡献](CONTRIBUTING.md)

</div>

## 项目状态

这套课程材料涵盖环境准备、内核实验和综合复现。请按实验中固定的说明和引用操作，不同环境及上游版本的表现可能不同。仓库记录的测试结果只覆盖记录中对应的提交和补丁序列。

## 从哪里开始

先阅读 [Lab 0](labs/lab0-env-setup/README.md)和[环境指南](docs/final/01_environment_setup.md)，再进入当前实验。主要目录包括：

- [labs/](labs/)：实验材料
- [tests/](tests/)：项目使用的检查
- [reproducibility/](reproducibility/)：复现说明和支撑文件
- [submissions/](submissions/) 与 [slides/](slides/)：课程交付材料

## 环境与复现

使用 WSL2 Ubuntu 24.04 或适合的 Linux 环境，并准备 Git、Bash、Make、`qemu-system-riscv64` 和 `riscv64-linux-gnu-gcc`。PowerShell、Git Bash 和 MINGW64 不属于记录中的真实 Make/QEMU 验证环境。

先在仓库根目录执行只读环境诊断：

```bash
bash scripts/xv6/doctor.sh
```

按[环境指南](docs/final/01_environment_setup.md)获取固定的 xv6 基线，提交为 `74f84181a3404d1d6a6ff98d342233979066ebb8`。环境准备好后，[队友复现指南](docs/final/07_teammate_reproduction_guide.md)使用：

```bash
bash scripts/xv6/teammate-verify.sh --full
```

完整验证会重建被 Git 忽略的 `external/xv6-riscv/` 工作区并应用综合补丁，执行前先把其中需要保留的本地修改整理为补丁。记录实际 summary；进程数量和状态受运行时影响，不承诺固定数字。通过 timeout 捕获到 QEMU 输出，也不代表完成了长期稳定性测试。

## 实验导航

| 实验 | 重点 |
| --- | --- |
| [0：环境准备](labs/lab0-env-setup/README.md) | 工具链、基线构建与启动证据 |
| [1：系统调用](labs/lab1-system-call/README.md) | `hello`、`add2` 与系统调用参数 |
| [2：进程](labs/lab2-process-and-scheduling/README.md) | 进程状态和数量观察 |
| [3：页表](labs/lab3-memory-and-pagetable/README.md) | 页表与地址空间观察 |
| [4：文件表](labs/lab4-file-system/README.md) | 文件表与文件描述符观察 |
| [5：综合复现](labs/lab5-final-integration/README.md) | 复现完整补丁序列并报告结果 |

Lab 3 和 Lab 4 训练内存及文件结构的观察，不是完整的内存管理或文件系统实现。Lab 5 是综合复现实验，不新增内核机制。具体范围见[已知限制](docs/final/11_known_limits_and_future_work.md)。

## 项目文档

- [文档索引](docs/README.md)
- [队友复现指南](docs/final/07_teammate_reproduction_guide.md)
- [参考来源与许可证说明](docs/final/10_reference_and_license_statement.md)
- [参与贡献](CONTRIBUTING.md)

原始日志、summary、第三方 xv6 源码和视频不进入源码版本管理。仓库保留状态记录，以及适用时的证据元数据。

## 权利与来源

固定的 xv6-riscv 基线使用 MIT 许可，其源码保存在被 Git 忽略的外部工作区。上游许可与本项目课程文档、增量工作的权利分开处理。复用前保留基线署名，并阅读 [RIGHTS.md](RIGHTS.md)。

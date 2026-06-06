# 02 Lab0 Baseline Build Boot

## 实验目标

让学生在修改内核前先完成 xv6-riscv baseline 获取、构建和 boot evidence 捕获，建立“所有实验都从可复现 baseline 开始”的习惯。

## 前置知识

- WSL2/Linux 命令行。
- Git clone / commit hash。
- `make` 基本概念。
- QEMU 是模拟器，不是普通 Linux 进程。
- timeout evidence 与长期稳定性测试不同。

## 涉及文件

| 文件/目录 | 作用 |
| --- | --- |
| `scripts/check-env.sh` | 基础工具链检查 |
| `scripts/xv6/fetch-xv6.sh` | 获取/记录 xv6 baseline |
| `scripts/xv6/check-xv6-baseline.sh` | baseline 结构和可选 make 检查 |
| `scripts/xv6/boot-xv6.sh` | 捕获 boot 关键文本 |
| `external/xv6-baseline-record.md` | 可提交 baseline metadata |
| `external/xv6-riscv/` | ignored 第三方源码目录 |
| `logs/*.log` | ignored 原始日志 |

## 实现步骤

1. 在 WSL2 Ubuntu 中进入仓库根目录。
2. 执行只读环境诊断：

   ```bash
   bash scripts/xv6/doctor.sh
   ```

3. 获取 baseline：

   ```bash
   bash scripts/xv6/fetch-xv6.sh --run
   ```

4. 检查 baseline 结构：

   ```bash
   bash scripts/xv6/check-xv6-baseline.sh
   ```

5. 构建 baseline：

   ```bash
   bash scripts/xv6/check-xv6-baseline.sh --make
   ```

6. 捕获 boot evidence：

   ```bash
   bash scripts/xv6/boot-xv6.sh
   ```

## 关键代码解释

lab0 不修改 xv6 内核。关键在脚本行为：

- `check-xv6-baseline.sh` 默认只检查目录、Makefile、LICENSE 和工具链，不运行 `make`。
- 带 `--make` 时才进入 `external/xv6-riscv/` 执行构建。
- `boot-xv6.sh` 通过 QEMU 启动 xv6，并在日志中同时匹配：

  ```text
  xv6 kernel is booting
  init: starting sh
  ```

只有两个文本都出现，才认为 boot evidence 捕获成功。

## 常见错误

| 问题 | 原因 | 处理 |
| --- | --- | --- |
| PowerShell 中 make 失败 | Windows shell 无 RISC-V 工具链 | 切换到 WSL2 Ubuntu |
| `qemu-system-riscv64` 缺失 | QEMU 未安装 | 安装后重新运行 doctor |
| `riscv64-unknown-elf-gcc` 缺失 | 可选工具未安装 | 当前不阻塞；`riscv64-linux-gnu-gcc` 已可用 |
| boot 卡住 | QEMU 或 make qemu 未退出 | `Ctrl+C` 后运行 `cleanup-qemu.sh` |
| `/mnt/d` 下首次 boot 慢 | drvfs/mtime 行为 | 使用默认重试或提高 timeout |

## 测试方法

```bash
bash scripts/xv6/doctor.sh
bash scripts/xv6/check-xv6-baseline.sh --make
bash scripts/xv6/boot-xv6.sh
```

## 预期输出

| 命令 | 预期 |
| --- | --- |
| `doctor.sh` | `READY` 或 `READY WITH WARNINGS` |
| `check-xv6-baseline.sh --make` | make 成功 |
| `boot-xv6.sh` | `BOOT_EVIDENCE_FOUND` |

## 当前真实结果

- baseline commit：`74f84181a3404d1d6a6ff98d342233979066ebb8`。
- baseline make 已成功。
- boot evidence 已捕获。
- 原始日志保存在 ignored 的 `logs/`，不提交。

## 扩展问题

1. 为什么必须固定 baseline commit？
2. 为什么 `make` 成功不等于 QEMU boot 成功？
3. 为什么 timeout evidence 不能写成长期稳定性测试？
4. 如果把 `external/xv6-riscv/` 提交进仓库，会带来哪些许可证和体积问题？

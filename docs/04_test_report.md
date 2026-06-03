# 测试报告

本文档记录 `proj54-ouc-os-lab` 已真实执行的测试与验证结果。

记录原则：

- 只记录真实执行过的命令和结果。
- 原始 `logs/*.log` 默认不提交，只在文档中记录路径和关键信息。
- 不将 `make` 成功写成 QEMU boot 成功。
- 不将 timeout 自动捕获写成长期稳定性或人工交互测试。
- 不伪造 lab1 syscall 输出。

## 测试记录

### xv6-riscv baseline build test

| 字段 | 内容 |
| --- | --- |
| 测试名称 | xv6-riscv baseline build test |
| 日期时间 | 2026-06-03 23:50:03 +08:00 |
| 命令 | `bash scripts/xv6/check-xv6-baseline.sh --make` |
| baseline 路径 | `external/xv6-riscv/` |
| baseline commit | `74f84181a3404d1d6a6ff98d342233979066ebb8` |
| 结果 | `make` 成功 |
| 日志文件 | `logs/xv6-make-20260603-235003.log` |
| 原始日志是否提交 | 否，`logs/*.log` 被 `.gitignore` 忽略 |

环境与工具链摘要：

| 项目 | 状态 |
| --- | --- |
| baseline directory | OK |
| `Makefile` | OK |
| `LICENSE` | OK |
| `qemu-system-riscv64` | OK |
| `riscv64-linux-gnu-gcc` | OK |
| `riscv64-unknown-elf-gcc` | WARN: 当前环境缺失 |

构建证据摘要：

- 构建过程中使用了 `riscv64-linux-gnu-gcc` 和 `riscv64-linux-gnu-ld`。
- 生成了 kernel 相关构建产物。
- linker 出现 `LOAD segment with RWX permissions` warning。
- 尽管存在该 warning，`make` 退出成功。

### xv6-riscv baseline boot evidence test

| 字段 | 内容 |
| --- | --- |
| 测试名称 | xv6-riscv baseline boot evidence test |
| 日期时间 | 2026-06-04 |
| 命令 | `bash scripts/xv6/boot-xv6.sh` |
| baseline 路径 | `external/xv6-riscv/` |
| 结果 | baseline boot evidence found |
| 关键文本 | `xv6 kernel is booting`，`init: starting sh` |
| 原始日志是否提交 | 否，`logs/*.log` 被 `.gitignore` 忽略 |

边界说明：

- 本验证使用 timeout 自动退出 QEMU。
- 该结果只记录 boot evidence，不等同于长期稳定性测试。
- 尚未做人工长期交互测试。

### lab1 hello syscall patch test

| 字段 | 内容 |
| --- | --- |
| 测试名称 | lab1 hello syscall patch test |
| baseline commit | `74f84181a3404d1d6a6ff98d342233979066ebb8` |
| patch 文件 | `patches/lab1-system-call/0001-add-hello-syscall.patch` |
| patch 目标 | 新增最小 `hello()` syscall，返回整数 `2026` |
| `make` 结果 | 成功 |
| hello 验证命令 | `bash scripts/xv6/run-xv6-command.sh hello "hello syscall returned 2026"` |
| hello 输出结果 | 成功检测到预期输出 |
| 原始日志是否提交 | 否，`logs/*.log` 被 `.gitignore` 忽略 |

检测到的用户程序输出：

```text
hello syscall returned 2026
```

实现范围：

- `kernel/syscall.h`: 增加 `SYS_hello 22`。
- `kernel/syscall.c`: 注册 `sys_hello`。
- `kernel/sysproc.c`: 实现 `sys_hello()`。
- `user/user.h`: 声明 `hello()`。
- `user/usys.pl`: 增加 `entry("hello")`。
- `Makefile`: 将 `_hello` 加入 `UPROGS`。
- `user/hello.c`: 新增用户态测试程序。

### lab1 add2 argint syscall extension test

| 字段 | 内容 |
| --- | --- |
| 测试名称 | lab1 add2 argint syscall extension test |
| baseline commit | `74f84181a3404d1d6a6ff98d342233979066ebb8` |
| patch 序列 | `0001-add-hello-syscall.patch` 后应用 `0002-add-argint-add2-syscall.patch` |
| patch 目标 | 新增 `add2(int a, int b)` syscall，使用 `argint()` 获取两个整数参数 |
| 预期输出 | `add2(20, 6) returned 26` |
| clean apply | 成功 |
| `make` 命令 | `cd external/xv6-riscv && make` |
| `make` 结果 | 成功 |
| hello 回归命令 | `bash scripts/xv6/run-xv6-command.sh hello "hello syscall returned 2026"` |
| hello 回归结果 | 成功检测到预期输出 |
| add2 验证命令 | `bash scripts/xv6/run-xv6-command.sh add2test "add2(20, 6) returned 26"` |
| add2 验证结果 | 成功检测到预期输出 |
| 原始日志是否提交 | 否，`logs/*.log` 被 `.gitignore` 忽略 |

实现范围：

- `kernel/syscall.h`: 增加 `SYS_add2 23`。
- `kernel/syscall.c`: 注册 `sys_add2`。
- `kernel/sysproc.c`: 实现 `sys_add2()`，调用 `argint(0, &a)` 和 `argint(1, &b)`。
- `user/user.h`: 声明 `add2(int, int)`。
- `user/usys.pl`: 增加 `entry("add2")`。
- `Makefile`: 将 `_add2test` 加入 `UPROGS`。
- `user/add2test.c`: 新增用户态测试程序。

过程问题记录：

- 直接在 PowerShell 中运行 `make` 失败，因为 Windows shell 找不到 `make`；后续使用 WSL/bash 运行 `make` 成功。
- 第一版手写 `0002` patch 因 hunk 计数错误无法应用；后续使用 WSL Git 重新生成干净增量 patch。
- 曾出现 Windows Git / WSL Git 行尾差异风险；最终 `0002` 已重新生成为小型增量 patch。

边界说明：

- 该记录证明 `argint()` 进阶 syscall patch 可构建并捕获输出。
- timeout 自动捕获不等同于长期稳定性测试。
- 人工交互 Demo 和第二名队员独立复现仍为 TODO。

## 当前风险与后续动作

| 风险 | 状态 / 处理 |
| --- | --- |
| 仓库路径包含空格 | 当前命令已在该路径下运行成功；后续大量实验仍建议优先考虑 WSL-native 路径。 |
| `riscv64-unknown-elf-gcc` 缺失 | 当前 baseline 和 lab1 构建使用 `riscv64-linux-gnu-gcc` 成功；若 Makefile 或工具链策略变化需复查。 |
| linker RWX warning | 当前不阻塞 build，但需要在技术报告中解释。 |
| QEMU 只做 evidence 捕获 | 已检测到 boot 关键文本、hello 输出和 add2 输出，但未做长期稳定性和完整人工交互测试。 |
| patch baseline 依赖 | `0001` 和 `0002` 均应用于 `74f84181a3404d1d6a6ff98d342233979066ebb8`；baseline 变化时需重新验证。 |

## 后续记录模板

| 字段 | 内容 |
| --- | --- |
| 测试名称 | TODO |
| 日期时间 | TODO |
| 命令 | TODO |
| 环境 | TODO |
| 结果 | TODO |
| 日志或输出位置 | TODO |
| 风险 | TODO |
| 后续动作 | TODO |

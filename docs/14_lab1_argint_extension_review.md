# lab1 argint syscall extension 复现审查

本文件记录 stage3a 对 lab1 进阶 patch 的真实复现审查。目标是确认 `0002-add-argint-add2-syscall.patch` 能在 `0001` 之后应用，并真实构建、运行。

## 基本信息

| 字段 | 内容 |
| --- | --- |
| 阶段 | stage3a |
| 日期 | 2026-06-04 |
| baseline commit | `74f84181a3404d1d6a6ff98d342233979066ebb8` |
| minimal patch | `patches/lab1-system-call/0001-add-hello-syscall.patch` |
| advanced patch | `patches/lab1-system-call/0002-add-argint-add2-syscall.patch` |
| 第三方源码 | `external/xv6-riscv/`，被 Git 忽略 |
| 原始日志 | `logs/*.log`，被 Git 忽略 |

## 设计结论

`0002` 增加 `add2(int a, int b)` syscall，用于演示 xv6-riscv 中 `argint()` 获取整数参数的机制。

预期用户输出：

```text
add2(20, 6) returned 26
```

## 修改点审查

| 文件 | 变化 |
| --- | --- |
| `kernel/syscall.h` | 新增 `SYS_add2 23`，不与 `SYS_hello 22` 冲突。 |
| `kernel/syscall.c` | 新增 `extern uint64 sys_add2(void);` 与 `[SYS_add2] sys_add2`。 |
| `kernel/sysproc.c` | 新增 `sys_add2()`，使用 `argint(0, &a)` 和 `argint(1, &b)`。 |
| `user/user.h` | 新增 `int add2(int, int);`。 |
| `user/usys.pl` | 新增 `entry("add2");`。 |
| `Makefile` | 新增 `_add2test` 到 `UPROGS`。 |
| `user/add2test.c` | 新增用户态测试程序。 |

## 真实执行记录

### 1. 初始状态检查

已运行：

```bash
git status --short
git status --ignored --short external logs
git ls-files external/xv6-riscv
git ls-files logs/*.log
bash scripts/check-env.sh
bash scripts/xv6/check-xv6-baseline.sh
bash scripts/xv6/run-xv6-command.sh hello "hello syscall returned 2026"
git diff --check
```

结果摘要：

- 主仓库初始干净。
- `external/xv6-riscv/` 未被 Git 跟踪。
- `logs/*.log` 未被 Git 跟踪。
- hello 输出仍可捕获。
- 环境中 `qemu-system-riscv64` 和 `riscv64-linux-gnu-gcc` OK，`riscv64-unknown-elf-gcc` WARN。

### 2. 开发中问题记录

- 直接在 PowerShell 工作目录执行 `make` 失败，原因是 Windows shell 找不到 `make`。后续使用 WSL/bash 执行等价构建命令并成功。
- 手写 `0002` patch 的第一次版本因 hunk 计数错误导致 `git apply` 报 `corrupt patch`。后续改用 WSL Git 基于 `0001` index 自动生成增量 patch。
- 曾混用 Windows Git 与 WSL Git，触发行尾差异风险。后续在 external xv6 子仓库设置并使用 WSL Git 流程重新生成 patch，最终 `0002` 为小型增量 patch。

以上失败均为真实过程问题，未写成成功。

### 3. clean baseline 复现

已真实执行：

```bash
git -C external/xv6-riscv reset --hard 74f84181a3404d1d6a6ff98d342233979066ebb8
git -C external/xv6-riscv clean -fdx
git -C external/xv6-riscv apply ../../patches/lab1-system-call/0001-add-hello-syscall.patch
git -C external/xv6-riscv apply ../../patches/lab1-system-call/0002-add-argint-add2-syscall.patch
```

结果：两个 patch 均成功应用。`user/usys.pl` 曾出现 file mode warning，但未阻塞 patch 应用或构建。

### 4. make 验证

已真实执行：

```bash
cd external/xv6-riscv
make
```

结果：

- `make` 成功。
- 使用 `riscv64-linux-gnu-gcc`。
- linker 仍有已知 `LOAD segment with RWX permissions` warning。

### 5. hello 回归

已真实执行：

```bash
bash scripts/xv6/run-xv6-command.sh hello "hello syscall returned 2026"
```

结果：捕获到 `hello syscall returned 2026`。

### 6. add2test 验证

已真实执行：

```bash
bash scripts/xv6/run-xv6-command.sh add2test "add2(20, 6) returned 26"
```

结果：捕获到 `add2(20, 6) returned 26`。

## 边界

- 当前只验证了 timeout 自动捕获证据，不等于长期稳定性测试。
- 当前未录制人工交互 Demo。
- 当前未完成第二名队员独立复现。
- 本轮未做 lab2/lab4。
- `external/xv6-riscv/` 和 `logs/*.log` 不提交。

## 结论

`0002-add-argint-add2-syscall.patch` 可在 clean baseline + `0001` 之后应用，且通过 `make`、hello 回归和 add2test 输出捕获。它可以作为 lab1 的进阶 syscall 参数传递实验材料。

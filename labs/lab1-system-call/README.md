# lab1: 系统调用实验

## 实验目标

lab1 通过两个递进 syscall 帮助同学理解 xv6-riscv 的系统调用路径：

- minimal：`hello()`，无参数，返回固定整数 `2026`。
- advanced：`add2(int a, int b)`，通过 `argint()` 获取两个整数参数并返回 `a + b`。

当前 lab1 只覆盖 syscall 入门与参数传递机制，不扩展到 lab2 的进程/调度内容。

## baseline 与 patch

| 项目 | 内容 |
| --- | --- |
| baseline repo | `https://github.com/mit-pdos/xv6-riscv.git` |
| baseline commit | `74f84181a3404d1d6a6ff98d342233979066ebb8` |
| minimal patch | `patches/lab1-system-call/0001-add-hello-syscall.patch` |
| advanced patch | `patches/lab1-system-call/0002-add-argint-add2-syscall.patch` |
| 应用顺序 | 先 `0001`，再 `0002` |

`external/xv6-riscv/` 被 Git 忽略，不提交第三方源码。lab1 的可提交产物是 patch、文档和测试摘要。

## 前置知识

- user/kernel 边界
- syscall number
- trap / ecall
- syscall dispatch table
- 用户态参数寄存器
- `argint()` 的作用

## minimal: hello()

语义：

```c
int hello(void);
```

预期输出：

```text
hello syscall returned 2026
```

涉及文件：

| 文件 | 作用 |
| --- | --- |
| `kernel/syscall.h` | 分配 `SYS_hello 22`。 |
| `kernel/syscall.c` | 声明并注册 `sys_hello`。 |
| `kernel/sysproc.c` | 实现 `sys_hello()`，返回 `2026`。 |
| `user/user.h` | 声明 `int hello(void);`。 |
| `user/usys.pl` | 增加 `entry("hello")`。 |
| `Makefile` | 将 `_hello` 加入 `UPROGS`。 |
| `user/hello.c` | 用户态测试程序。 |

## advanced: add2(int a, int b)

语义：

```c
int add2(int a, int b);
```

用户程序调用：

```c
add2(20, 6);
```

预期输出：

```text
add2(20, 6) returned 26
```

涉及文件：

| 文件 | 作用 |
| --- | --- |
| `kernel/syscall.h` | 分配 `SYS_add2 23`，不与 `SYS_hello 22` 冲突。 |
| `kernel/syscall.c` | 声明 `sys_add2` 并加入 syscall dispatch table。 |
| `kernel/sysproc.c` | 实现 `sys_add2()`，使用 `argint(0, &a)` 和 `argint(1, &b)` 获取参数。 |
| `user/user.h` | 声明 `int add2(int, int);`。 |
| `user/usys.pl` | 增加 `entry("add2")`。 |
| `Makefile` | 将 `_add2test` 加入 `UPROGS`。 |
| `user/add2test.c` | 用户态测试程序，打印 `add2(20, 6) returned 26`。 |

## argint() 说明

在 xv6-riscv 中，用户态 syscall 参数会按调用约定放入寄存器。用户态 stub 执行 `ecall` 后进入内核，内核可以通过 `argint(n, &value)` 读取第 `n` 个 32-bit 整数参数。

`add2()` 的参数路径：

```text
user/add2test.c
  -> add2(20, 6)
  -> user/usys.pl 生成的 add2 stub
  -> ecall / trap 进入 kernel
  -> syscall() 根据 a7 中的 SYS_add2 分发
  -> sys_add2()
  -> argint(0, &a) 读取第一个参数 20
  -> argint(1, &b) 读取第二个参数 6
  -> return a + b
  -> 返回值通过 a0 回到用户态
```

## 应用 patch

从 clean baseline 开始：

```bash
cd external/xv6-riscv
git reset --hard 74f84181a3404d1d6a6ff98d342233979066ebb8
git clean -fdx
git apply ../../patches/lab1-system-call/0001-add-hello-syscall.patch
git apply ../../patches/lab1-system-call/0002-add-argint-add2-syscall.patch
```

## 测试方式

构建：

```bash
cd external/xv6-riscv
make
```

捕获 boot evidence：

```bash
bash scripts/xv6/boot-xv6.sh
```

捕获 hello 输出：

```bash
bash scripts/xv6/run-xv6-command.sh hello "hello syscall returned 2026"
```

捕获 add2 输出：

```bash
bash scripts/xv6/run-xv6-command.sh add2test "add2(20, 6) returned 26"
```

## 当前真实验证结果

| 项目 | 状态 | 说明 |
| --- | --- | --- |
| clean baseline + `0001` + `0002` apply | PASS | 已从 baseline commit 重新应用两个 patch |
| `make` | PASS | WSL/bash 下成功；仍有已知 linker RWX warning |
| hello 输出 | PASS | 捕获到 `hello syscall returned 2026` |
| add2test 输出 | PASS | 捕获到 `add2(20, 6) returned 26` |
| 长期稳定性测试 | TODO | 未执行 |
| 人工交互录屏 | TODO | 未执行 |
| 第二名队员独立复现 | TODO | 未执行 |

原始日志被 Git 忽略。正式摘要记录在 `docs/04_test_report.md` 和 `docs/14_lab1_argint_extension_review.md`。

## 常见错误

| 问题 | 可能原因 | 处理方式 |
| --- | --- | --- |
| syscall number 冲突 | `SYS_add2` 使用了已有编号 | 检查 `kernel/syscall.h`，当前 `hello=22`，`add2=23`。 |
| 用户态声明遗漏 | `user/user.h` 未声明 `add2()` | 增加 `int add2(int, int);`。 |
| 用户态 stub 缺失 | `user/usys.pl` 未增加 `entry("add2")` | 增加 entry 后重新构建。 |
| 参数错误 | `sys_add2()` 未使用正确参数序号 | 使用 `argint(0, &a)` 和 `argint(1, &b)`。 |
| xv6 shell 找不到 `add2test` | `Makefile` 未加入 `_add2test` | 将 `$U/_add2test\` 加入 `UPROGS`。 |
| patch 无法应用 | 未先应用 `0001` 或 baseline 不一致 | 从指定 baseline 开始，按 `0001` 后 `0002` 顺序应用。 |

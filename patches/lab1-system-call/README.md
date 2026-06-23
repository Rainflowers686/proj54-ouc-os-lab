# lab1 syscall patches

## 目标

本目录保存 lab1 的可提交 patch。xv6-riscv 第三方源码位于 ignored 的 `external/xv6-riscv/`，不提交到本仓库。

当前 lab1 分两档：

| Patch | 内容 | 教学重点 |
| --- | --- | --- |
| `0001-add-hello-syscall.patch` | 新增无参数 `hello()` syscall，返回 `2026` | syscall 最小闭环 |
| `0002-add-argint-add2-syscall.patch` | 新增 `add2(int a, int b)` syscall，返回 `a + b` | `argint()` 参数传递 |

说明：本目录用于 lab1 单独教学与复现。若需要在同一个 xv6 构建中同时演示 lab1 与 lab2，请使用 `patches/integrated-labs/`，不要把 lab2 independent patch 直接叠加到本目录 patch 之上。

## baseline

| 字段 | 内容 |
| --- | --- |
| baseline repo | `https://github.com/mit-pdos/xv6-riscv.git` |
| baseline commit | `74f84181a3404d1d6a6ff98d342233979066ebb8` |
| baseline branch | `riscv` |
| 本地源码路径 | `external/xv6-riscv/` |

## 应用顺序

必须从 clean baseline 开始，先应用 `0001`，再应用 `0002`：

```bash
cd external/xv6-riscv
git reset --hard 74f84181a3404d1d6a6ff98d342233979066ebb8
git clean -fdx
git apply ../../patches/lab1-system-call/0001-add-hello-syscall.patch
git apply ../../patches/lab1-system-call/0002-add-argint-add2-syscall.patch
```

如果工作区不是 clean baseline，不要直接声称复现成功。

## 0001 修改内容

`0001` 修改：

- `kernel/syscall.h`
- `kernel/syscall.c`
- `kernel/sysproc.c`
- `user/user.h`
- `user/usys.pl`
- `Makefile`

`0001` 新增：

- `user/hello.c`

预期输出：

```text
hello syscall returned 2026
```

## 0002 修改内容

`0002` 修改：

- `kernel/syscall.h`
- `kernel/syscall.c`
- `kernel/sysproc.c`
- `user/user.h`
- `user/usys.pl`
- `Makefile`

`0002` 新增：

- `user/add2test.c`

`sys_add2()` 使用：

```c
argint(0, &a);
argint(1, &b);
```

预期输出：

```text
add2(20, 6) returned 26
```

## 构建与运行

构建：

```bash
cd external/xv6-riscv
make
```

自动捕获 hello：

```bash
bash scripts/xv6/run-xv6-command.sh hello "hello syscall returned 2026"
```

自动捕获 add2：

```bash
bash scripts/xv6/run-xv6-command.sh add2test "add2(20, 6) returned 26"
```

## 当前真实验证状态

| 检查项 | 状态 |
| --- | --- |
| clean baseline + `0001` + `0002` apply | PASS |
| `make` | PASS |
| hello output evidence | PASS |
| add2test output evidence | PASS |
| 长期稳定性测试 | TODO |
| 人工交互 shell 测试 | TODO |
| 第二名队员复现 | TODO |

原始日志被 Git 忽略。摘要见 `docs/04_test_report.md` 和 `docs/14_lab1_argint_extension_review.md`。

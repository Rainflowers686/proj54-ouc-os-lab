# lab4 file table observation patch

## 实验名称

lab4 file table observation。

## patch 文件

| 文件 | 说明 |
| --- | --- |
| `0001-add-fcount-syscall.patch` | 从 clean xv6-riscv baseline 单独应用的 lab4 patch，新增 `fcount()` 和 `fcounttest`。 |

## baseline

| 字段 | 内容 |
| --- | --- |
| upstream | `https://github.com/mit-pdos/xv6-riscv.git` |
| baseline commit | `74f84181a3404d1d6a6ff98d342233979066ebb8` |
| local path | `external/xv6-riscv/` |

## syscall number

independent lab4 patch 使用：

```text
SYS_fcount = 22
```

该编号只适用于 lab4 单独教学。综合演示路径使用 `patches/integrated-labs/0005-add-file-table-observation.patch`，其中 `SYS_fcount = 26`。

## 修改文件列表

- `Makefile`
- `kernel/defs.h`
- `kernel/file.c`
- `kernel/syscall.c`
- `kernel/syscall.h`
- `kernel/sysfile.c`
- `user/user.h`
- `user/usys.pl`
- `user/fcounttest.c`

## 应用方式

从 clean baseline 开始：

```bash
cd external/xv6-riscv
git reset --hard 74f84181a3404d1d6a6ff98d342233979066ebb8
git clean -fdx
git apply ../../patches/lab4-file-table-observation/0001-add-fcount-syscall.patch
```

## 构建方式

```bash
make
```

## 运行方式

```bash
make qemu
fcounttest
```

自动捕获建议从仓库根目录运行：

```bash
bash scripts/xv6/run-xv6-command.sh fcounttest "fcounttest done"
```

## 预期输出

输出应包含：

```text
fcount(before) = <n>
fcount(after_open) = <n>
fcount(after_close) = <n>
fcounttest done
```

`<n>` 不固定，不能写成固定验收数字。

## 当前真实验证状态

| 项目 | 状态 |
| --- | --- |
| clean baseline apply | PASS |
| `make` | PASS |
| `fcounttest` 输出捕获 | PASS，已检测到 `fcounttest done` |
| 原始日志提交 | 否，`logs/*.log` ignored |
| 第二名队员复现 | TODO |
| 人工交互录屏 | TODO |

## 教学价值

该 patch 用最小 syscall 暴露 xv6 全局文件表的一个可观察指标，帮助学生从用户态 fd 过渡到内核 `struct file`、`ref` 引用计数和 `ftable.lock`。它不修改文件系统布局，也不试图实现完整文件系统功能。

## Advanced optional：`0002-add-fdinfo-syscall.patch`（fdinfo）

> 维护时间：2026-06-08（stage11a）。这是 Lab4 的进阶可选 independent patch，独立于 `0001-add-fcount-syscall.patch`。

| 字段 | 内容 |
| --- | --- |
| patch | `patches/lab4-file-table-observation/0002-add-fdinfo-syscall.patch` |
| 接口 | `int fdinfo(int fd, struct fdinfo *out)` |
| 返回结构 | `struct fdinfo { int type; int readable; int writable; int ref; }` |
| syscall number | `SYS_fdinfo = 22`（clean baseline independent patch） |
| 教学点 | `argint + argaddr + copyout + struct ABI`：从"数 fd"进到"看一个 fd 的内核元数据" |

`fdinfo()` 在 `fcount()`/`fdcount()` 的"计数"基础上更进一步：用 `argint(0, &fd)` + `argaddr(1, &uaddr)`，只查询**当前进程** `myproc()->ofile[fd]`，通过 file.c 新增 helper `fileinfo()` 在 `ftable.lock` 下读取 `{type, readable, writable, ref}` 并 `copyout` 回用户态。fd 越界、未打开或用户指针无效返回 -1，成功返回 0。它只返回描述符级元数据，**不返回路径、inode 号、文件内容或物理地址**。

涉及文件：`Makefile`、`kernel/defs.h`、`kernel/fdinfo.h`（新增 struct）、`kernel/file.c`（新增 `fileinfo()` helper）、`kernel/syscall.c`、`kernel/syscall.h`、`kernel/sysfile.c`、`user/user.h`、`user/usys.pl`、`user/fdinfotest.c`（新增）。

应用与验证（clean baseline，独立于 `0001`）：

```bash
cd external/xv6-riscv
git reset --hard 74f84181a3404d1d6a6ff98d342233979066ebb8
git clean -fdx
git apply ../../patches/lab4-file-table-observation/0002-add-fdinfo-syscall.patch
make
cd ../..
bash scripts/xv6/run-xv6-command.sh fdinfotest "fdinfotest done"
```

clean baseline round-trip 已验证，实测输出（来自真实 open/dup/close/bad fd，非硬编码）：

```text
fdinfo open fd ok
fdinfo dup fd ok
fdinfo closed fd = -1
fdinfo bad fd = -1
fdinfotest done
```

`ref` 会被观察输出，但不做强断言（其绝对值可能随环境变化）。

边界与状态：

- 这是 fd table **观察**实验，**不是完整文件系统实验**。
- `SYS_fdinfo = 22` 与 `fcount` 的 `SYS_fcount = 22` 相同：两个 independent patch **不可叠加**，各自从 clean baseline 单独应用。组合演示走 integrated 路线。
- stage11b 起 `fdinfo` **已进入** integrated `0009`（`patches/integrated-labs/0009-add-fdinfo-copyout-observation.patch`，integrated 编号 `SYS_fdinfo = 30`，`fileinfo()` 在 `ftable.lock` 下读取），current integrated suite 为 `0001-0009`。
- integrated 变体已在队长本机 `local-verify --full` overall PASS（含 `fdinfotest`）；本 independent patch 本身仍未纳入队友 full verification。
- `e8e2fb9` 三方 full PASS 是 historical stable checkpoint，只覆盖 `0001-0007`，**不覆盖** `0001-0009`。
- 含 fdinfo 的 `0001-0009` 队友 full verify（rain/root/z2996）、新视频、新 SHA256 均为 TBD，须在新 commit 上重新复现后填写，不得伪造。

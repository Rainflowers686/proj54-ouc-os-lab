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

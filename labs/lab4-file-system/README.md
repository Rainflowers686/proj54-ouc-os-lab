# lab4: 文件表观察实验

## 实验目标

本实验通过新增 `fcount()` syscall 和用户程序 `fcounttest`，观察 xv6 全局文件表中正在被引用的 `struct file` 数量。目标是让低年级同学理解 file descriptor、`struct file`、全局 file table、引用计数 `ref`、`open/close` 对内核对象的影响，以及为什么读取共享内核数据结构时需要锁保护。

本实验是文件系统观察 v0.1，不是完整文件系统改造。

## 前置知识

- file descriptor：用户态看到的整数 fd，是进程打开文件表的索引。
- `struct file`：xv6 内核中表示打开文件、管道或设备的对象。
- global file table：xv6 使用全局 `ftable.file[]` 管理系统范围内的 `struct file`。
- `ref` 引用计数：`ref > 0` 表示该 `struct file` 正在被引用。
- `open/close`：`open` 会分配或引用内核文件对象，`close` 会释放引用。
- file table lock：读取 `ftable.file[]` 和 `ref` 时需要持有 `ftable.lock`，避免并发读写导致不一致。
- 为什么 count 不是固定值：shell、console、init、测试程序自身打开的文件和调度时序都会影响当前文件表引用数量。

## 实验任务

1. 新增 `fcount()` syscall。
2. 在内核中实现 `filecount()`，统计全局文件表中 `ref > 0` 的 `struct file` 数量。
3. 新增用户程序 `fcounttest`。
4. 在 `fcounttest` 中观察临时文件打开前、打开后、关闭后的文件表引用数量。
5. 记录真实构建命令、运行命令、输出前缀和风险边界。

## 修改文件说明

| 文件 | 作用 |
| --- | --- |
| `kernel/file.c` | 新增 `filecount()`，在持有 `ftable.lock` 时遍历 `ftable.file[]`。 |
| `kernel/defs.h` | 声明 `int filecount(void);`。 |
| `kernel/syscall.h` | 新增 syscall number。independent patch 使用 `SYS_fcount = 22`；integrated patch 使用 `SYS_fcount = 26`。 |
| `kernel/syscall.c` | 声明并注册 `sys_fcount`。 |
| `kernel/sysfile.c` | 新增 `sys_fcount()`，返回 `filecount()` 的结果。 |
| `user/user.h` | 声明 `int fcount(void);`。 |
| `user/usys.pl` | 新增 `entry("fcount");` 生成用户态 syscall stub。 |
| `Makefile` | 将 `_fcounttest` 加入 `UPROGS`。 |
| `user/fcounttest.c` | 新增用户态测试程序。 |

## 调用链

```text
用户程序 fcounttest
  -> user stub: fcount()
  -> ecall / trap
  -> syscall dispatcher
  -> sys_fcount()
  -> filecount()
  -> ftable.file[] / f->ref
  -> 返回用户态
```

## 锁设计说明

`filecount()` 读取的是全局 `ftable.file[]`。该表可能被其他进程通过 `open`、`close`、`dup` 等路径修改，因此统计时需要：

1. `acquire(&ftable.lock)`。
2. 遍历 `ftable.file[]`。
3. 统计 `f->ref > 0` 的条目。
4. `release(&ftable.lock)`。

本实验只做瞬时观察，不承诺得到系统全局长期稳定数量。

## 测试方式

independent lab4 patch：

```bash
cd external/xv6-riscv
git reset --hard 74f84181a3404d1d6a6ff98d342233979066ebb8
git clean -fdx
git apply ../../patches/lab4-file-table-observation/0001-add-fcount-syscall.patch
make
cd ../..
bash scripts/xv6/run-xv6-command.sh fcounttest "fcounttest done"
```

integrated demo：

```bash
bash scripts/xv6/apply-integrated-labs.sh --make --yes
bash scripts/xv6/run-xv6-command.sh fcounttest "fcount(before) ="
bash scripts/xv6/run-xv6-command.sh fcounttest "fcount(after_open) ="
bash scripts/xv6/run-xv6-command.sh fcounttest "fcount(after_close) ="
bash scripts/xv6/run-xv6-command.sh fcounttest "fcounttest done"
```

自动验证只匹配稳定前缀，不固定具体数字。

## 常见错误

- syscall number 与已有实验冲突。
- 忘记更新 `user/user.h`。
- 忘记更新 `user/usys.pl`。
- `Makefile` 未加入 `_fcounttest`。
- 读取 `ftable.file[]` 时忘记释放 `ftable.lock`。
- 在文档或测试中固定承诺 `fcount` 的具体数字。
- 把 integrated patch 和 independent patch 的 syscall number 混用。

## 当前验证结果

当前真实结果：

- independent lab4 patch 已生成：`patches/lab4-file-table-observation/0001-add-fcount-syscall.patch`。
- independent patch 已从 clean baseline 应用并 `make` 成功。
- integrated `0005-add-file-table-observation.patch` 已生成，基于 integrated `0001-0004`。
- integrated `0001-0005` 已通过 helper 从 clean baseline 应用并 `make` 成功。
- 已真实捕获 `fcount(before) =`、`fcount(after_open) =`、`fcount(after_close) =` 和 `fcounttest done`。
- 本地一次日志中观察到 `before=1`、`after_open=2`、`after_close=1`，但该数字不作为固定验收标准。

## 当前边界

- 这不是完整文件系统实验。
- 不观察 inode。
- 不修改文件系统布局。
- 不实现 `fdinfo(pid, fd)` 或 open file summary。
- timeout 自动捕获不等于长期稳定性测试。
- 第二名队员独立复现 TODO。
- 人工交互录屏 TODO。

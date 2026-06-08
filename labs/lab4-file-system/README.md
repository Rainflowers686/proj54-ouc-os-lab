# lab4: 文件表观察实验

## 实验目标

本实验通过新增 `fcount()` / `fdcount()` syscall 和用户程序 `fcounttest` / `fdcounttest`，观察 xv6 全局文件表中正在被引用的 `struct file` 数量，以及当前进程 fd table 中非空 fd 数量。目标是让低年级同学理解 file descriptor、`struct file`、全局 file table、当前进程 `ofile[]`、引用计数 `ref`、`open/dup/close` 对内核对象的影响，以及为什么读取共享内核数据结构时需要锁保护。

本实验是文件系统观察 v0.2，不是完整文件系统改造。

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
3. 新增 `fdcount()` syscall。
4. 新增用户程序 `fcounttest` 和 `fdcounttest`。
5. 在用户程序中观察临时文件打开、dup、关闭前后的 file table / fd table 变化。
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
| `kernel/sysfile.c` | stage9c 新增 `sys_fdcount()`，统计当前进程 `ofile[]`。 |
| `user/user.h` | stage9c 新增 `int fdcount(void);`。 |
| `user/usys.pl` | stage9c 新增 `entry("fdcount");`。 |
| `Makefile` | stage9c 将 `_fdcounttest` 加入 `UPROGS`。 |
| `user/fdcounttest.c` | stage9c 新增 fd table 对比测试程序。 |

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
bash scripts/xv6/run-xv6-command.sh fdcounttest "fdcounttest done"
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
- integrated `0001-0007` 已通过 helper 从 clean baseline 应用并 `make` 成功。
- 已真实捕获 `fcount(before) =`、`fcount(after_open) =`、`fcount(after_close) =` 和 `fcounttest done`。
- stage9c 已真实捕获 `fdcounttest done`，并观察到 fd delta open=1、dup=2、close one=1、close two=0。
- 本地一次日志中观察到 `before=1`、`after_open=2`、`after_close=1`，但该数字不作为固定验收标准。

## 进阶可选实验：fdinfo（advanced optional, independent）

`fcount()`/`fdcount()` 之后，可以做一个进阶可选实验 `fdinfo()`，把"数 fd"升级为"看一个 fd 的内核元数据"。

- patch：`patches/lab4-file-table-observation/0002-add-fdinfo-syscall.patch`（独立于 `0001`）。
- 接口：`int fdinfo(int fd, struct fdinfo *out)`，返回 `{type, readable, writable, ref}`。
- 教学点：`argint + argaddr + copyout + struct ABI`——内核如何按 fd 取出 `struct file` 的元数据并安全拷回用户态；只查 `myproc()->ofile[fd]`，在 `ftable.lock` 下读取，不返回路径/inode 号/内容/物理地址。
- 验证：`bash scripts/xv6/run-xv6-command.sh fdinfotest "fdinfotest done"`，clean baseline round-trip 已通过（`open fd ok`、`dup fd ok`、`closed fd = -1`、`bad fd = -1`）。

边界与状态：仍然是 fd table **观察**实验，不是完整文件系统；`SYS_fdinfo = 22` 与 `fcount` 相同，两个 independent patch **不可叠加**；**未进入** integrated `0001-0007`，**未纳入**队友 full verification，**不影响** `e8e2fb9` 证据。组合演示见未来 integrated `0008/0009`（届时编号 `SYS_fdinfo = 30`，并需重新队友 full verify、重录视频、重算 SHA256）。

## 当前边界

- 这不是完整文件系统实验。
- 不观察 inode。
- 不修改文件系统布局。
- 不实现 `fdinfo(pid, fd)` 或 open file summary。
- timeout 自动捕获不等于长期稳定性测试。
- 第二名队员独立复现 TODO。
- 人工交互录屏 TODO。

# lab4 文件表观察实验复现审查

阶段：stage6a

日期：2026-06-04

baseline commit：`74f84181a3404d1d6a6ff98d342233979066ebb8`

重要声明：本报告只记录真实执行过的命令和结果。`external/xv6-riscv/` 为 ignored 第三方源码目录，`logs/*.log` 为 ignored 原始日志，均不提交。

## 总体结论

通过。lab4 v0.1 已形成一个可教学、可复现的文件表观察实验：

- independent patch：`patches/lab4-file-table-observation/0001-add-fcount-syscall.patch`，可从 clean baseline 单独应用。
- integrated patch：`patches/integrated-labs/0005-add-file-table-observation.patch`，可在 integrated `0001-0004` 之后应用。
- 新增 syscall：`fcount()`。
- 新增用户程序：`fcounttest`。
- 已真实验证 independent patch `make` 成功和 `fcounttest` 输出捕获。
- 已真实验证 integrated `0001-0005` 从 clean baseline 应用、`make` 成功、boot evidence 和既有用户程序回归。

## 新增 syscall 与用户程序

| 项目 | independent patch | integrated patch |
| --- | --- | --- |
| syscall | `fcount()` | `fcount()` |
| syscall number | `SYS_fcount = 22` | `SYS_fcount = 26` |
| 用户程序 | `fcounttest` | `fcounttest` |
| patch 文件 | `patches/lab4-file-table-observation/0001-add-fcount-syscall.patch` | `patches/integrated-labs/0005-add-file-table-observation.patch` |

## filecount 实现与锁分析

`filecount()` 位于 `kernel/file.c`，核心逻辑是：

1. 持有 `ftable.lock`。
2. 遍历 `ftable.file[]`。
3. 统计 `f->ref > 0` 的 `struct file`。
4. 释放 `ftable.lock`。

这样设计的原因是 `ftable.file[]` 是全局共享数据结构，可能被其他进程通过 `open`、`close`、`dup` 等路径改变。读取 `ref` 时持有 `ftable.lock` 可以避免和文件表分配/释放路径并发冲突。

本实验得到的是一次瞬时观察结果，不是长期稳定快照。

## fcounttest 设计

`fcounttest` 做三次观察：

1. `before = fcount()`：打开临时文件前。
2. `after_open = fcount()`：`open("fcnttmp", O_CREATE | O_RDWR)` 之后。
3. `after_close = fcount()`：写入少量内容并 `close(fd)` 之后。

程序最后 `unlink("fcnttmp")` 清理临时文件，并输出 `fcounttest done`。

验证只匹配稳定前缀：

- `fcount(before) =`
- `fcount(after_open) =`
- `fcount(after_close) =`
- `fcounttest done`

文件表数量可能受 shell、console、init 和时序影响，不固定承诺具体数字。

## clean baseline independent patch 验证

真实执行路径：

```bash
git -C external/xv6-riscv reset --hard 74f84181a3404d1d6a6ff98d342233979066ebb8
git -C external/xv6-riscv clean -fdx
git -C external/xv6-riscv apply ../../patches/lab4-file-table-observation/0001-add-fcount-syscall.patch
make -C external/xv6-riscv
bash scripts/xv6/run-xv6-command.sh fcounttest "fcounttest done"
```

结果：

| 检查项 | 结果 |
| --- | --- |
| clean baseline apply | PASS |
| `make` | PASS |
| `fcounttest done` 捕获 | PASS |
| 日志示例 | `logs/xv6-command-fcounttest-20260604-225028.log`，ignored，不提交 |

本地一次输出样例：

```text
fcount(before) = 1
fcount(after_open) = 2
fcount(after_close) = 1
fcounttest done
```

该数字只作为一次真实观察，不作为固定验收标准。

## integrated 0001-0005 验证

真实执行路径：

```bash
bash scripts/xv6/apply-integrated-labs.sh
bash scripts/xv6/apply-integrated-labs.sh --make --yes
bash scripts/xv6/boot-xv6.sh
bash scripts/xv6/run-xv6-command.sh hello "hello syscall returned 2026"
bash scripts/xv6/run-xv6-command.sh add2test "add2(20, 6) returned 26"
bash scripts/xv6/run-xv6-command.sh pstatetest "pstate(self) ="
bash scripts/xv6/run-xv6-command.sh pcounttest "pcount(RUNNING) ="
bash scripts/xv6/run-xv6-command.sh pcounttest "pcount(99) = -1"
bash scripts/xv6/run-xv6-command.sh pchildtest "pstate(child) ="
bash scripts/xv6/run-xv6-command.sh fcounttest "fcount(before) ="
bash scripts/xv6/run-xv6-command.sh fcounttest "fcount(after_open) ="
bash scripts/xv6/run-xv6-command.sh fcounttest "fcount(after_close) ="
bash scripts/xv6/run-xv6-command.sh fcounttest "fcounttest done"
```

结果：

| 检查项 | 结果 |
| --- | --- |
| helper 预览 | PASS，只读，不 reset、不 apply、不 make |
| clean baseline + integrated `0001-0005` | PASS |
| `make` | PASS |
| boot evidence | PASS，检测到 `xv6 kernel is booting` 和 `init: starting sh` |
| `hello` | PASS，检测到 `hello syscall returned 2026` |
| `add2test` | PASS，检测到 `add2(20, 6) returned 26` |
| `pstatetest` | PASS，检测到 `pstate(self) =` |
| `pcounttest` | PASS，检测到 `pcount(RUNNING) =` 和 `pcount(99) = -1` |
| `pchildtest` | PASS，检测到 `pstate(child) =` |
| `fcounttest` | PASS，检测到三个前缀和 `fcounttest done` |

复验边界记录：stage6a 最终复验中，`apply-integrated-labs.sh --make --yes` 后第一次运行 `boot-xv6.sh` 未捕获 boot evidence，日志显示 `make qemu` 在 20 秒 timeout 内仍在补建 `fs.img` 相关用户程序；第二次运行 `boot-xv6.sh` 成功捕获 boot evidence。该现象说明首次 QEMU 启动脚本可能受构建缓存状态影响，不能把第一次失败掩盖成成功。

## 教学价值

- 从用户态 file descriptor 引入内核 `struct file`。
- 通过 `ref` 引用计数解释打开文件对象的生命周期。
- 通过 `open/close` 前后观察说明用户态操作会影响内核全局文件表。
- 通过 `ftable.lock` 引出共享内核数据结构的并发读取问题。
- 通过“不固定 fcount 数字”引导学生理解内核状态观察中的时序和环境差异。

## 当前边界

- 不是完整文件系统实验。
- 不观察 inode。
- 不修改磁盘布局或文件系统格式。
- 不实现 per-process fd table 查询。
- timeout 自动捕获不是长期稳定性测试。
- 第二名队员独立复现 TODO。
- 人工交互录屏 TODO。

## 后续扩展

- inode observation：观察 inode 引用和类型。
- `fdinfo(pid, fd)`：从进程 fd 映射到 `struct file`。
- open file type summary：统计 FD_PIPE、FD_INODE、FD_DEVICE。
- lab4 v0.2：加入更系统的文件打开、关闭、unlink、错误路径实验。

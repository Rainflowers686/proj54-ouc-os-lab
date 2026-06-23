# lab4 文件表观察实验复现审查

阶段：stage6a（首次实现）+ stage6b（严格红队复审 + 双路径独立重复）

日期：2026-06-04（stage6a）/ 2026-06-05（stage6b）

baseline commit：`74f84181a3404d1d6a6ff98d342233979066ebb8`

重要声明：本报告只记录真实执行过的命令和结果。`external/xv6-riscv/` 为 ignored 第三方源码目录，`logs/*.log` 为 ignored 原始日志，均不提交。

stage6b 结论速览：**independent lab4 patch 与 integrated `0005` 均无需任何代码改动**；两条 clean-baseline 复现路径都重新跑通；本轮工作仅为文档补全与诚实边界。

## 总体结论

通过。lab4 v0.1 已形成一个可教学、可复现的文件表观察实验：

- independent patch：`patches/lab4-file-table-observation/0001-add-fcount-syscall.patch`，可从 clean baseline 单独应用。
- integrated patch：`patches/integrated-labs/0005-add-file-table-observation.patch`，可在 integrated `0001-0004` 之后应用（综合序列即 `0001-0005`）。
- 新增 syscall：`fcount()`。
- 新增用户程序：`fcounttest`。
- 已真实验证 independent patch `make` 成功和 `fcounttest` 输出捕获。
- 已真实验证 integrated `0001-0005` 从 clean baseline 应用、`make` 成功、boot evidence 和既有用户程序回归。

红队判断（stage6b）：`filecount()` 锁纪律正确、无死锁、不泄露文件内容/路径；`fcounttest` 的 open/close 生命周期清晰；independent 与 integrated 两个 patch 的核心逻辑字节一致，仅 syscall number 与上下文不同。lab4 确有教学价值（user fd → 内核 `struct file` → `ref` → `ftable.lock`），但仍只是“文件表计数观察”，不是完整文件系统实验。所有结论仅代表 timeout 自动捕获，不代表长期稳定性、人工录屏或队友复现。

## 新增 syscall 与用户程序

| 项目 | independent patch | integrated patch |
| --- | --- | --- |
| syscall | `fcount()` | `fcount()` |
| syscall number | `SYS_fcount = 22` | `SYS_fcount = 26` |
| 用户程序 | `fcounttest` | `fcounttest` |
| patch 文件 | `patches/lab4-file-table-observation/0001-add-fcount-syscall.patch` | `patches/integrated-labs/0005-add-file-table-observation.patch` |

## filecount 实现与锁分析

`filecount()` 位于 `kernel/file.c`，实现如下：

```c
int
filecount(void)
{
  struct file *f;
  int count = 0;

  acquire(&ftable.lock);
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    if (f->ref > 0)
      count++;
  }
  release(&ftable.lock);

  return count;
}
```

baseline 中 `ftable` 是 `kernel/file.c` 的静态全局：`struct { struct spinlock lock; struct file file[NFILE]; } ftable;`，`NFILE = 100`，`struct file` 含 `int ref`。

设计要点（stage6b 红队确认）：

1. **暴露路径正确**：`filecount()` 经 `kernel/defs.h` 的 `int filecount(void);` 暴露；syscall 包装 `sys_fcount()` 放在 **`kernel/sysfile.c`**（与 `sys_open`/`sys_close`/`sys_fstat` 等文件类 syscall 同处），而不是 `kernel/sysproc.c`。这比 lab1/lab2 把 demo syscall 放进 `sysproc.c` 的做法更贴合职责划分，是合理的工程选择，不是缺陷。`sys_fcount()` 无参数，直接 `return filecount();`。
2. **锁纪律正确**：`f->ref` 在 baseline 中由 `filealloc`/`filedup`/`fileclose` 统一在 `ftable.lock` 下读写；`filecount()` 也在 `ftable.lock` 下读 `ref`，与既有约定一致，避免与文件表分配/释放路径竞争。
3. **不会死锁**：`filecount()` 只持有 `ftable.lock` 这一把锁，循环内不再 `acquire` 任何其它锁（只读简单整型 `ref`），且没有任何调用路径会在已持有 `ftable.lock` 的情况下再调用 `filecount()`。这里 `ftable.lock` 是叶子锁，无锁序问题。
4. **不泄露内容**：`filecount()` 只返回一个 `int` 计数，全程只读 `f->ref`，从不解引用 `f->ip`、`f->pipe`、`f->off`，也不输出任何文件名、路径、inode 或文件内容。`fcount()` 在安全上只是“看见有多少个 `struct file` 槽位在用”，没有信息泄露面。
5. **快照语义**：返回值是 syscall 执行时刻的瞬时观察，不是长期稳定快照；打印时文件表可能已变化。

## fcounttest 设计

`fcounttest` 做三次观察：

1. `before = fcount()`：打开临时文件前。
2. `after_open = fcount()`：`open("fcnttmp", O_CREATE | O_RDWR)` 之后。
3. `after_close = fcount()`：写入少量内容并 `close(fd)` 之后。

程序开头先 `unlink("fcnttmp")` 保证从干净状态开始，最后再 `unlink("fcnttmp")` 清理临时文件，并输出 `fcounttest done`。

验证只匹配稳定前缀：

- `fcount(before) =`
- `fcount(after_open) =`
- `fcount(after_close) =`
- `fcounttest done`

文件表数量可能受 shell、console、init 和时序影响，不固定承诺具体数字。

真正的教学不变量是**差值**而不是绝对值：

- `open(O_CREATE | O_RDWR)` 会在全局文件表分配一个新的 `struct file`（`ref` 由 0 变 1），所以 `after_open` 通常比 `before` **多 1**。
- `close(fd)` 使该 `struct file` 的 `ref` 归零并被回收，所以 `after_close` 通常**回落到 `before`**。

stage6b 在 independent 与 integrated 两种构建中都实测到 `before=1 → after_open=2 → after_close=1`，即 `+1 / -1` 的生命周期。绝对值（这里是 1）取决于 shell/console/init 当前占用了几个 `struct file`，因此**只承诺前缀、不承诺数字**；但 `+1/-1` 的方向性可以稳定地讲清 open/close 对内核全局对象的影响。`fcounttest` 本身只 `printf` 不 `assert`，避免把一个会受环境影响的数字写成硬性期望。

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

复验边界记录：stage6a 最终复验中，`apply-integrated-labs.sh --make --yes` 后第一次运行 `boot-xv6.sh` 未捕获 boot evidence，日志显示 `make qemu` 在 20 秒 timeout 内仍在补建 `fs.img` 相关用户程序；第二次运行 `boot-xv6.sh` 成功捕获 boot evidence。该现象说明首次 QEMU 启动脚本可能受构建缓存状态影响，不能把第一次失败掩盖成成功。其根因很可能是 `/mnt/d`（NTFS over WSL）上的文件 mtime 偶有“未来时间”偏移（make 日志可见 `File 'Makefile' has modification time ... in the future`），导致首个 `make qemu` 误判目标过期而重建。规避手段：先单独 `make` 再 boot，或对首次 boot 容忍一次重试 / 调大 `XV6_BOOT_TIMEOUT_SECONDS`。

stage6c 处理：`scripts/xv6/boot-xv6.sh` 已将默认 timeout 从 20 秒提高到 45 秒，并默认尝试 2 次。每次尝试写入独立日志 `logs/xv6-boot-YYYYMMDD-HHMMSS-attemptN.log`。可通过 `XV6_BOOT_TIMEOUT_SECONDS` 和 `XV6_BOOT_RETRIES` 覆盖。该改动不修改 xv6 patch，只降低 evidence 捕获的假失败概率；仍不代表长期稳定性测试。

stage6c 真实验证：默认 `bash scripts/xv6/boot-xv6.sh` 已在第 1 次尝试捕获 boot evidence；`XV6_BOOT_TIMEOUT_SECONDS=60 XV6_BOOT_RETRIES=2 bash scripts/xv6/boot-xv6.sh` 也已确认环境变量覆盖生效并捕获 boot evidence。两次原始日志均位于 ignored 的 `logs/`。

## stage6b 红队复审重验（2026-06-05，WSL2 Ubuntu-24.04）

本轮独立重新跑通两条 clean-baseline 路径，未改动任何 patch 代码：

A. **independent lab4 patch**（仅该一个 patch）

| 检查项 | 结果 | 实测 |
| --- | --- | --- |
| `git apply --check` / `apply` | PASS | 仅 `usys.pl` 模式警告（见下），patch 成功应用 |
| 改动文件 | 9 个 | `Makefile`、`kernel/{defs.h,file.c,syscall.c,syscall.h,sysfile.c}`、`user/{user.h,usys.pl}` 改动 + `user/fcounttest.c` 新增 |
| `make` | PASS | 仅 baseline 自带的链接器警告（见下），无编译 `error:`/`warning:` |
| boot evidence | PASS | `xv6 kernel is booting` + `init: starting sh` |
| `fcounttest` | PASS | `fcount(before) = 1`、`fcount(after_open) = 2`、`fcount(after_close) = 1`、`fcounttest done` |

B. **integrated `0001-0005`**（`apply-integrated-labs.sh --make --yes`）

| 检查项 | 结果 | 实测 |
| --- | --- | --- |
| clean reset + apply `0001-0005` | PASS | 5 个 patch check+apply 全部 `[OK]` |
| `make` | PASS | 日志 `logs/integrated-make-20260605-071545.log`（ignored） |
| boot evidence | PASS | 本轮两次 boot 都直接捕获（fs.img 已就绪） |
| hello / add2test / pstatetest / pcounttest / pchildtest | PASS | 既有实验回归无破坏 |
| fcounttest | PASS | `before=1 → after_open=2 → after_close=1`、`fcounttest done` |

两个真实、但不提交的现象：

- **`usys.pl` 模式警告**：每次 `git apply` 都打印 `warning: user/usys.pl has type 100644, expected 100755`。无害，patch 仍成功应用；成因是 `/mnt/d`（NTFS over WSL）`core.filemode=false` 丢可执行位，上游 `usys.pl` 本为 `100755`。与 lab1/lab2 patch 现象一致，详见 `docs/19`。处置为文档解释，不重导 patch。
- **baseline 链接器警告**：`make` 末尾出现 `riscv64-linux-gnu-ld: warning: kernel/kernel has a LOAD segment with RWX permissions`。这是 **stock xv6 + 现代 binutils 的固有警告**，与 `fcount` 无关，clean baseline 自身就有；`make` 仍成功（非 `-Werror` 致命错误）。

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

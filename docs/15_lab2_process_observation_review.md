# lab2 process observation 复现审查

## 总体结论

stage4a 新增的 lab2 `pstate(int pid)` syscall patch 已完成真实复现验证。

结论：

- patch 可从 clean baseline commit `74f84181a3404d1d6a6ff98d342233979066ebb8` 直接应用。
- `make` 成功。
- `pstatetest` 输出可被自动脚本捕获。
- 实际输出包含 `pstate(self) = 4 (RUNNING)`。

该实验是进程状态观察入门，不是完整 `ps`，不修改调度器。

## patch 修改文件列表

| 文件 | 说明 |
| --- | --- |
| `kernel/syscall.h` | 增加 `SYS_pstate 22`。 |
| `kernel/syscall.c` | 注册 `sys_pstate`。 |
| `kernel/sysproc.c` | 实现 `sys_pstate()`。 |
| `user/user.h` | 声明 `int pstate(int);`。 |
| `user/usys.pl` | 增加 `entry("pstate");`。 |
| `Makefile` | 增加 `_pstatetest`。 |
| `user/pstatetest.c` | 新增用户态测试程序。 |

## pstate syscall 调用链

```text
pstatetest
  -> getpid()
  -> pstate(pid)
  -> user stub
  -> ecall / trap
  -> syscall dispatcher
  -> sys_pstate
  -> proc table lookup
  -> return state enum value
```

## proc table 查找过程

`sys_pstate()` 通过 `argint(0, &pid)` 获取用户态传入的 pid，然后遍历 `proc[]`：

```c
for (p = proc; p < &proc[NPROC]; p++) {
  acquire(&p->lock);
  if (p->pid == pid && p->state != UNUSED) {
    state = p->state;
    release(&p->lock);
    return state;
  }
  release(&p->lock);
}
```

未找到 pid 时返回 `-1`。

## 锁使用分析

`p->state` 是调度、sleep/wakeup、exit/wait 等路径会修改的共享状态。xv6 对 `struct proc` 中的 state、pid 等字段有明确锁约定：访问这些字段时应持有 `p->lock`。

本实验在读取每个 `proc` 的 `pid` 和 `state` 时获取对应 `p->lock`，并保证找到和未找到路径都会释放锁。

## clean baseline apply 验证步骤

已真实执行：

```bash
git -C external/xv6-riscv reset --hard 74f84181a3404d1d6a6ff98d342233979066ebb8
git -C external/xv6-riscv clean -fdx
git -C external/xv6-riscv apply ../../patches/lab2-process-observation/0001-add-pstate-syscall.patch
```

结果：patch 成功应用。过程中出现 `user/usys.pl` file mode warning，但未阻塞应用或构建。

## make 验证结果

已真实执行：

```bash
cd external/xv6-riscv
make
```

结果：

- `make` 成功。
- 使用 `riscv64-linux-gnu-gcc`。
- linker 仍有已知 `LOAD segment with RWX permissions` warning。

## boot / pstatetest 验证结果

已真实执行：

```bash
bash scripts/xv6/boot-xv6.sh
bash scripts/xv6/run-xv6-command.sh pstatetest "pstate(self) ="
bash scripts/xv6/run-xv6-command.sh pstatetest "RUNNING"
```

结果：

- boot evidence 捕获成功。
- `pstate(self) =` 捕获成功。
- `RUNNING` 捕获成功。
- 本地 ignored log 中观察到 `pstate(self) = 4 (RUNNING)`。

## 教学价值评估

该实验适合作为 lab1 之后的进程观察入门（真加分项）：

- lab1 已经讲过 syscall 参数传递，lab2 用 pid 作参数自然过渡到进程表。
- `pstate()` 只观察单个进程，范围小、可讲清楚 `struct proc`、`enum procstate`、`proc[]` 遍历。
- 锁设计（读 `p->state` 持有 `p->lock`）可以引出并发访问内核数据结构的基本规范。

### stage4b 红队的教学局限判断（需诚实承认）

1. **`pstate(self)` 结果几乎是恒真的 `RUNNING`**：进程必须正在运行才能发起这个 syscall，所以观察"自己"几乎总是得到 `4 (RUNNING)`，教学上略显循环。要真正体现状态差异（`SLEEPING`/`RUNNABLE`/`ZOMBIE`），应观察**别的进程**（如 `fork` 出子进程后观察其 pid，或 sleep 中的进程），这是更有价值的下一步。
2. **用户态与内核 enum 的隐式耦合**：`pstatetest.c` 把状态码 `0..5` 硬编码成名字，依赖内核 `enum procstate` 的具体取值。一旦内核 enum 顺序/取值变化，用户态名字会**静默错位**。这是一个真实的可教学点（跨用户/内核边界传递"语义编号"的风险），但当前文档未点明，建议在教学中明确。
3. **快照语义**：返回的 state 是读取瞬间的快照，用户态打印时可能已过期；对并发观察的教学应说明这一点。

结论：lab2 是一个**正确、可复现、能引出进程表与锁的观察入门 demo**，但要成为"进程/调度观察实验"，下一步应让学生观察**非自身**进程的多种状态，并补负向/并发实验（详见后续扩展）。

## 当前不足

- 不是完整 `ps`。
- 不修改调度器。
- 只观察单个 pid，且观察"自身"几乎恒为 `RUNNING`（见教学局限）。
- timeout 自动捕获不是长期稳定性测试。
- 人工交互录屏 TODO。
- 第二名队员独立复现 TODO。
- **lab2 与 lab1 independent patch 当前不能直接叠加（已实测）**：lab2 独立于 clean baseline 生成，`SYS_pstate = 22` 与 lab1 `SYS_hello = 22` **撞号**；且把 lab2 `git apply` 到 lab1 之上时 `git apply --check` 返回 exit 1（6 个文件 `patch does not apply`）。stage4c 已新增 [../patches/integrated-labs/README.md](../patches/integrated-labs/README.md) 作为综合演示序列，使用 `SYS_pstate = 24`。不得声称现有 lab1/lab2 independent patch 可任意组合。

## stage4b 独立复现结果（真实执行，未伪造）

stage4b 红队在被忽略的 `external/xv6-riscv/` 中独立从 clean baseline 重做（主仓库不受影响）：

| 步骤 | 结果 |
| --- | --- |
| clean baseline 校验 | CLEAN（HEAD = `74f8418`） |
| lab2 `git apply --check` / apply | exit 0 / exit 0 |
| 文件集 | `M Makefile/syscall.c/syscall.h/sysproc.c/user.h/usys.pl` + `?? user/pstatetest.c` |
| `syscall.h` 尾部 | `SYS_pstate 22` |
| clean `make` | 成功（exit 0；仅已知 RWX 警告） |
| boot evidence | `BOOT_EVIDENCE_FOUND` |
| `pstatetest "pstate(self) ="` | `COMMAND_EVIDENCE_FOUND` |
| `pstatetest "RUNNING"` | `COMMAND_EVIDENCE_FOUND`，实际 `pstate(self) = 4 (RUNNING)` |
| 本次日志（忽略，不提交） | `logs/xv6-make-20260604-122410.log`、`logs/xv6-command-pstatetest-20260604-122530.log` |

## 评委复现路径

```bash
bash scripts/check-env.sh
bash scripts/xv6/fetch-xv6.sh --run
cd external/xv6-riscv
git reset --hard 74f84181a3404d1d6a6ff98d342233979066ebb8
git clean -fdx
git apply ../../patches/lab2-process-observation/0001-add-pstate-syscall.patch
make
cd ../..
bash scripts/xv6/run-xv6-command.sh pstatetest "pstate(self) ="
```

## 后续扩展

- `pcount(state)`: 统计某种状态的进程数量。
- scheduler trace: 记录调度切换过程。
- ps-like summary: 输出简化进程表。
- 负向实验: 错误 pid、锁遗漏、syscall number 冲突等。

## stage5a v0.2 扩展记录

stage5a 已把上述第一个扩展方向纳入 integrated-labs 综合序列，但未改动本文件前半部分描述的 lab2 independent patch。

新增内容：

- integrated `0004-extend-process-observation.patch`，应用在 integrated `0001`+`0002`+`0003` 之后。
- 新增 `pcount(int state)`，使用 `SYS_pcount = 25`。
- 新增 `pcounttest`，验证 `pcount(RUNNING) =` 和负向输入 `pcount(99) = -1`。
- 新增 `pchildtest`，通过 `fork()` 子进程观察非自身进程状态，输出 `pstate(child) = ...`。

真实验证：

- clean baseline + integrated `0001-0004` apply：PASS。
- `make`：PASS。
- boot evidence：PASS。
- `hello` / `add2test` / `pstatetest` 回归：PASS。
- `pcounttest "pcount(RUNNING) ="`：PASS。
- `pcounttest "pcount(99) = -1"`：PASS。
- `pchildtest "pstate(child) ="`：PASS。

边界：

- `pcount(RUNNING)` 的具体数字不固定承诺。
- 子进程状态受调度时序影响，本地日志中观察到过 `RUNNABLE` 和 `SLEEPING`，自动验证只匹配稳定前缀。
- 原计划名 `pstatechildtest` 因 xv6 `DIRSIZ` 文件名限制导致 `mkfs` 失败，实际命令名缩短为 `pchildtest`。
- 详细审查见 [19_lab2_v0.2_process_observation_review.md](19_lab2_v0.2_process_observation_review.md)。

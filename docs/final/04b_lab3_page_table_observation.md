# 04b Lab3 Page Table Observation

## 实验目标

通过 `pgcount()` 系统调用观察当前进程用户页表中已经映射的用户页数量，并用 `sbrk()` / `sbrklazy()` 对比 eager allocation 与 lazy allocation 的行为差异。

本实验是页表映射数量观察实验，不是完整内存管理实验，不输出物理地址，不暴露内核页表布局，也不修改 lazy allocation / page fault 逻辑。

## 前置知识

- `struct proc` 中的 `pagetable` 和 `sz`。
- RISC-V PTE 标志位，尤其是 `PTE_V` 与 `PTE_U`。
- `PGSIZE = 4096`。
- `walk(pagetable, va, 0)` 只查找页表项，不分配页表页。
- baseline 中 `sbrk(n)` 走 eager allocation，`sbrklazy(n)` 走 lazy allocation。

## 涉及文件

| 文件 | 作用 |
| --- | --- |
| `kernel/vm.c` | 新增 `uvmpagecount(pagetable, sz)` |
| `kernel/defs.h` | 声明 `uvmpagecount()` |
| `kernel/sysproc.c` | 新增 `sys_pgcount()` |
| `kernel/syscall.h` | integrated 中新增 `SYS_pgcount = 27` |
| `kernel/syscall.c` | 注册 `sys_pgcount` |
| `user/user.h` | 声明 `pgcount()` |
| `user/usys.pl` | 新增 `entry("pgcount")` |
| `user/pgcounttest.c` | eager/lazy allocation 对比测试 |
| `Makefile` | 加入 `_pgcounttest` |

## 实现步骤

1. 在 `kernel/vm.c` 中遍历 `0 <= va < sz`。
2. 每页调用 `walk(pagetable, va, 0)`。
3. 只统计同时满足 `PTE_V` 和 `PTE_U` 的页表项。
4. 在 `sys_pgcount()` 中只统计 `myproc()`，不接收 pid。
5. 在用户态暴露 `pgcount()` 并加入 `pgcounttest`。

关键逻辑：

```c
pte_t *pte = walk(pagetable, va, 0);
if (pte != 0 && (*pte & PTE_V) && (*pte & PTE_U))
  count++;
```

## 测试方法

```bash
bash scripts/xv6/apply-integrated-labs.sh --make --yes
bash scripts/xv6/run-xv6-command.sh pgcounttest "pgcount eager delta = 2"
bash scripts/xv6/run-xv6-command.sh pgcounttest "pgcount lazy delta before touch = 0"
bash scripts/xv6/run-xv6-command.sh pgcounttest "pgcount lazy delta after two touches = 2"
bash scripts/xv6/run-xv6-command.sh pgcounttest "pgcounttest done"
```

## 预期输出

```text
pgcount eager delta = 2
pgcount lazy delta before touch = 0
pgcount lazy delta after one touch = 1
pgcount lazy delta after two touches = 2
pgcounttest done
```

不要验证 `pgcount before = <n>` 这类绝对页数；不同构建和程序大小会改变绝对值。

## 当前状态

| 测试项 | 结果 |
| --- | --- |
| independent Lab3 patch | PASS |
| integrated `0006` apply/make | PASS |
| `pgcount eager delta = 2` | PASS |
| `pgcount lazy delta before touch = 0` | PASS |
| `pgcount lazy delta after two touches = 2` | PASS |
| `pgcounttest done` | PASS |
| 新 HEAD 队友 full verification | 待重跑 |

## 常见错误

| 错误 | 后果 | 修正 |
| --- | --- | --- |
| 统计未映射页 | delta 失真 | 必须检查 `pte != 0` 与 `PTE_V` |
| 统计内核页 | 泄露范围扩大 | 只遍历 `0 <= va < p->sz` 且检查 `PTE_U` |
| 调用 `walk(..., 1)` | 观察操作变成修改操作 | 必须使用 `alloc = 0` |
| 固定绝对页数 | 测试不稳定 | 只验证 delta |
| 写成完整内存管理实验 | 范围夸大 | 只称为页表映射数量观察 |

## 扩展问题

1. 为什么 `sbrk(2 * PGSIZE)` 后 delta 是 2？
2. 为什么 `sbrklazy(2 * PGSIZE)` 触摸前 delta 是 0？
3. 为什么 `pgcount()` 不应该返回物理地址？
4. 如果要观察 page fault 次数，应该新增什么证据和边界？

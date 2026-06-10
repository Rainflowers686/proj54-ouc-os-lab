# lab3：页表与内存观察

> 维护时间：2026-06-06（stage9b）。

## 实验目标

理解 xv6-riscv 中用户地址空间、页表映射数量和 eager/lazy allocation 的关系。Lab3 本轮实现的是 `pgcount()` 页表观察实验，不是完整内存管理实验。

## 前置知识

- RISC-V Sv39 页表基本概念。
- `pagetable_t`、PTE、`PTE_V`、`PTE_U`。
- `PGSIZE = 4096`。
- xv6 进程结构中的 `struct proc.sz` 和 `struct proc.pagetable`。
- baseline 已内置 eager/lazy allocation：
  - `sbrk(n)` 走 `SBRK_EAGER`，立即分配并映射用户页。
  - `sbrklazy(n)` 走 `SBRK_LAZY`，只扩大进程大小，实际页由 `vmfault()` 按需分配。

## 实验任务

1. 阅读 `kernel/vm.c` 中 `walk()`、`uvmalloc()`、`uvmdealloc()` 和 `vmfault()`。
2. 阅读 `kernel/sysproc.c` 中 `sys_sbrk()` 的 eager/lazy 分支。
3. 应用 independent Lab3 patch：

   ```bash
   cd external/xv6-riscv
   git reset --hard 74f84181a3404d1d6a6ff98d342233979066ebb8
   git clean -fdx
   git apply ../../patches/lab3-memory-and-pagetable/0001-add-pgcount-syscall.patch
   make
   ```

4. 运行 `pgcounttest`，观察 eager 与 lazy 的页表映射数量差异。

## 关键代码解释

Lab3 patch 在 `kernel/vm.c` 中新增只读 helper：

```c
int uvmpagecount(pagetable_t pagetable, uint64 sz)
```

它遍历 `0 <= va < sz` 的用户虚拟页：

- 使用 `walk(pagetable, va, 0)` 查询 PTE。
- 不分配页表页，不修改 PTE。
- 只统计同时满足 `PTE_V` 和 `PTE_U` 的页。

`sys_pgcount()` 只统计当前进程：

```c
struct proc *p = myproc();
return uvmpagecount(p->pagetable, p->sz);
```

不接收 pid，不输出物理地址，不暴露内核页表细节。

## 测试方法

在仓库根目录执行：

```bash
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

`pgcount before/after` 的绝对值不固定，不作为验收标准。

## 当前真实结果

| 项目 | 结果 |
| --- | --- |
| independent patch 生成 | PASS |
| clean baseline apply | PASS |
| `make` | PASS |
| `pgcount eager delta = 2` | PASS |
| `pgcount lazy delta before touch = 0` | PASS |
| `pgcount lazy delta after two touches = 2` | PASS |
| `pgcounttest done` | PASS |
| integrated `0006` | PASS；已进入 `patches/integrated-labs/0006-add-pgcount-page-table-observation.patch` |
| teammate full verification | 旧 `1ba9db6` summary 不覆盖；stage9c 新 HEAD 待重跑 |

## 常见错误

- 只统计 `PTE_V`，忘记检查 `PTE_U`，会混淆非用户映射。
- 在 helper 中调用 `walk(..., 1)`，导致观察函数意外分配页表页。
- 依赖 `pgcount before = <n>` 的绝对值；不同程序大小或构建状态会影响它。
- 把 `pgcount()` 说成完整内存管理实验。
- 把旧队友 summary 写成 stage9c 新 HEAD 复现。

## 扩展问题

1. 为什么 `sbrklazy(2 * PGSIZE)` 后 `pgcount` 不立即增加？
2. 为什么触摸 lazy 区域会让 `pgcount` 增加？
3. 如果只统计 `PTE_V` 而不统计 `PTE_U`，教学语义会有什么问题？
4. 为什么本实验不返回物理地址或 PTE 原始值？

## 进阶可选实验：memstat（advanced optional, independent + integrated `0008`）

`pgcount()` 之后，可以做一个进阶可选实验 `memstat()`，把"数页"升级为"用 `copyout` 把一个结构体拷回用户态"。

- patch：`patches/lab3-memory-and-pagetable/0002-add-memstat-syscall.patch`（独立于 `0001`）。
- 接口：`int memstat(struct memstat *out)`，返回 `{sz_bytes, mapped_pages, page_size}`。
- 教学点：`argaddr + copyout + struct ABI`——内核如何安全地把结构体写回用户缓冲区；`copyout` 失败返回 -1。
- 验证：`bash scripts/xv6/run-xv6-command.sh memstattest "memstattest done"`，clean baseline round-trip 已通过（`page_size = 4096`、`mapped delta = 2`、`size delta = 8192`、`invalid pointer = -1`）。

边界与状态：仍然是页表/地址空间**观察**实验，不是完整内存管理；independent 版 `SYS_memstat = 22` 与 `pgcount` 相同，两个 independent patch **不可叠加**，各自从 clean baseline 单独应用。stage11b 起 `memstat` **已进入** integrated `0008`（`patches/integrated-labs/0008-add-memstat-copyout-observation.patch`，`SYS_memstat = 29`），current integrated suite 为 `0001-0009`，队长本机 `local-verify --full` overall PASS（含 `memstattest`）。证据边界：`e8e2fb9 / 0001-0007` 三方 full PASS 是 historical stable checkpoint，**不覆盖** `0001-0009`；含 memstat 的 `0001-0009` 队友 full verify、新视频、新 SHA256 均为 TBD，待重新复现后填写，不得伪造。

# Lab3 Memory and Pagetable Patch

> 维护时间：2026-06-06（stage9b）。

## Baseline

| 字段 | 内容 |
| --- | --- |
| upstream | `https://github.com/mit-pdos/xv6-riscv.git` |
| baseline commit | `74f84181a3404d1d6a6ff98d342233979066ebb8` |
| patch | `0001-add-pgcount-syscall.patch` |
| syscall number | `SYS_pgcount = 22`（clean baseline independent patch） |

## Patch 作用

本 patch 新增 `pgcount()` 系统调用和 `pgcounttest` 用户程序，用于观察当前进程用户页表中已经映射的用户页数量。

它是 Lab3 的 independent patch，不属于 integrated-labs `0001-0005`，也没有新增 integrated `0006`。

## 涉及文件

| 文件 | 作用 |
| --- | --- |
| `kernel/syscall.h` | 新增 `SYS_pgcount 22` |
| `kernel/syscall.c` | 注册 `sys_pgcount` |
| `kernel/sysproc.c` | 实现 `sys_pgcount()`，只统计当前进程 |
| `kernel/vm.c` | 新增只读 helper `uvmpagecount(pagetable, sz)` |
| `kernel/defs.h` | 声明 `uvmpagecount` |
| `user/user.h` | 声明 `int pgcount(void)` |
| `user/usys.pl` | 生成用户态 syscall stub |
| `user/pgcounttest.c` | eager/lazy allocation 对比测试 |
| `Makefile` | 加入 `_pgcounttest` |

## 应用方式

从 clean baseline 应用：

```bash
cd external/xv6-riscv
git reset --hard 74f84181a3404d1d6a6ff98d342233979066ebb8
git clean -fdx
git apply ../../patches/lab3-memory-and-pagetable/0001-add-pgcount-syscall.patch
make
```

## 运行方式

在仓库根目录使用现有 QEMU 捕获脚本：

```bash
bash scripts/xv6/run-xv6-command.sh pgcounttest "pgcount eager delta = 2"
bash scripts/xv6/run-xv6-command.sh pgcounttest "pgcount lazy delta before touch = 0"
bash scripts/xv6/run-xv6-command.sh pgcounttest "pgcount lazy delta after two touches = 2"
bash scripts/xv6/run-xv6-command.sh pgcounttest "pgcounttest done"
```

## 预期输出

`pgcounttest` 会打印真实计算出的 page count 差值：

```text
pgcount eager delta = 2
pgcount lazy delta before touch = 0
pgcount lazy delta after one touch = 1
pgcount lazy delta after two touches = 2
pgcounttest done
```

不依赖 `pgcount before/after` 的绝对值。

## 教学说明

- baseline 已有 eager/lazy allocation：`sbrk(n)` 走 `SBRK_EAGER`，`sbrklazy(n)` 走 `SBRK_LAZY`。
- eager `sbrk(2 * PGSIZE)` 会立即映射 2 个用户页，因此 `pgcount` delta 应为 2。
- lazy `sbrklazy(2 * PGSIZE)` 只扩大 `p->sz`，触摸前不映射物理页，因此 delta 应为 0。
- 触摸 lazy 区域的第 1 页和第 2 页后，`vmfault()` 按需分配页，delta 分别变为 1 和 2。

边界：这是页表映射数量观察实验，不是完整内存管理、物理内存统计、page fault 改造或长期稳定性测试。

## Advanced optional：`0002-add-memstat-syscall.patch`（memstat）

> 维护时间：2026-06-08（stage11a）。这是 Lab3 的进阶可选 independent patch，独立于 `0001-add-pgcount-syscall.patch`。

| 字段 | 内容 |
| --- | --- |
| patch | `patches/lab3-memory-and-pagetable/0002-add-memstat-syscall.patch` |
| 接口 | `int memstat(struct memstat *out)` |
| 返回结构 | `struct memstat { uint64 sz_bytes; int mapped_pages; int page_size; }` |
| syscall number | `SYS_memstat = 22`（clean baseline independent patch） |
| 教学点 | `argaddr + copyout + struct ABI`：第一次让学生看到内核如何把一个结构体安全拷回用户态 |

`memstat()` 在 `pgcount()` 的"数页"基础上更进一步：用 `argaddr(0, &uaddr)` 取用户缓冲区地址，把 `{sz_bytes = p->sz, mapped_pages = [0,sz) 内 PTE_V && PTE_U 的页数, page_size = PGSIZE}` 通过 `copyout()` 拷回用户态；`copyout` 失败返回 -1，成功返回 0。它仍然只读、不分配、不修改 PTE、不输出物理地址。

涉及文件：`Makefile`、`kernel/memstat.h`（新增 struct）、`kernel/syscall.c`、`kernel/syscall.h`、`kernel/sysproc.c`、`user/user.h`、`user/usys.pl`、`user/memstattest.c`（新增）。

应用与验证（clean baseline，独立于 `0001`）：

```bash
cd external/xv6-riscv
git reset --hard 74f84181a3404d1d6a6ff98d342233979066ebb8
git clean -fdx
git apply ../../patches/lab3-memory-and-pagetable/0002-add-memstat-syscall.patch
make
cd ../..
bash scripts/xv6/run-xv6-command.sh memstattest "memstattest done"
```

clean baseline round-trip 已验证，实测输出（delta 为程序真实计算，非硬编码）：

```text
memstat page_size = 4096
memstat mapped delta = 2
memstat size delta = 8192
memstat invalid pointer = -1
memstattest done
```

边界与状态：

- 这是页表/地址空间**观察**实验，**不是完整内存管理实验**。
- `SYS_memstat = 22` 与 `pgcount` 的 `SYS_pgcount = 22` 相同：两个 independent patch **不可叠加**，各自从 clean baseline 单独应用。需要组合演示时应走未来的 integrated `0008/0009`（编号将改为 `SYS_memstat = 29`）。
- **未进入** integrated `0001-0007`。
- **未纳入**队友（rain/root/z2996）full verification；当前不需要队友重新 full verify。
- **不影响** `e8e2fb9` 三方 full PASS 证据。
- 若未来进入 integrated `0008/0009`，必须重新 rain/root/z2996 full verify、重录视频、重算 SHA256。

# lab3 测试记录

> 维护时间：2026-06-06（stage9b）。

## 当前测试目标

验证 independent Lab3 `pgcount()` 页表观察 patch：

- eager `sbrk(2 * PGSIZE)` 后已映射用户页数量增加 2。
- lazy `sbrklazy(2 * PGSIZE)` 触摸前不增加映射页数量。
- 触摸 lazy 区域两页后映射页数量增加 2。
- `pgcounttest` 正常结束。

## 测试命令

```bash
bash scripts/xv6/check-xv6-baseline.sh
cd external/xv6-riscv
git reset --hard 74f84181a3404d1d6a6ff98d342233979066ebb8
git clean -fdx
git apply ../../patches/lab3-memory-and-pagetable/0001-add-pgcount-syscall.patch
make
cd ../..
bash scripts/xv6/run-xv6-command.sh pgcounttest "pgcount eager delta = 2"
bash scripts/xv6/run-xv6-command.sh pgcounttest "pgcount lazy delta before touch = 0"
bash scripts/xv6/run-xv6-command.sh pgcounttest "pgcount lazy delta after two touches = 2"
bash scripts/xv6/run-xv6-command.sh pgcounttest "pgcounttest done"
```

## 真实结果

| 测试项 | 结果 |
| --- | --- |
| baseline check | PASS |
| clean baseline reset/apply | PASS |
| `make` | PASS |
| `pgcount eager delta = 2` | PASS |
| `pgcount lazy delta before touch = 0` | PASS |
| `pgcount lazy delta after two touches = 2` | PASS |
| `pgcounttest done` | PASS |

## 证据边界

- 原始 QEMU logs 在 `logs/` 下，Git ignored，不提交。
- `pgcount before/after` 的绝对数值不固定，不作为验收标准。
- 本测试现在覆盖 independent Lab3 patch 和 integrated `0006`；旧 commit `1ba9db6` 的 teammate full summary 不覆盖 stage9c 新 HEAD。

## 进阶可选：memstat（advanced optional, independent）

`memstat()` 是 Lab3 的进阶可选 independent patch（`patches/lab3-memory-and-pagetable/0002-add-memstat-syscall.patch`），用 `argaddr + copyout` 把 `{sz_bytes, mapped_pages, page_size}` 拷回用户态。

验证命令（clean baseline，独立于 `0001`）：

```bash
git -C external/xv6-riscv reset --hard 74f84181a3404d1d6a6ff98d342233979066ebb8
git -C external/xv6-riscv clean -fdx
git -C external/xv6-riscv apply ../../patches/lab3-memory-and-pagetable/0002-add-memstat-syscall.patch
make -C external/xv6-riscv
bash scripts/xv6/run-xv6-command.sh memstattest "memstattest done"
```

真实结果（clean baseline round-trip 已验证）：

| 测试项 | 结果 |
| --- | --- |
| clean baseline apply + `make` | PASS |
| `memstat page_size = 4096` | PASS |
| `memstat mapped delta = 2`（eager sbrk 2 页） | PASS |
| `memstat size delta = 8192` | PASS |
| `memstat invalid pointer = -1` | PASS |
| `memstattest done` | PASS |

边界：independent 版 `SYS_memstat = 22`（与 `pgcount` 不可叠加）。stage11b 起 `memstat` **已进入** integrated `0008`（`SYS_memstat = 29`），current integrated suite 为 `0001-0009`，`memstattest` 已纳入 local/teammate full verify 并在队长本机 `local-verify --full` overall PASS。证据边界：`e8e2fb9 / 0001-0007` 三方 full PASS 为 historical stable checkpoint，不覆盖 `0001-0009`；`0001-0009` 的队友复现、新视频、新 SHA256 为 TBD，不得伪造。

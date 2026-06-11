# lab4 测试记录

## 当前测试目标

lab4 v0.2 用于验证文件表与 fd 表观察实验：

- `fcount()` syscall 能返回当前全局文件表中 `ref > 0` 的 `struct file` 数量。
- `fcounttest` 能输出打开临时文件前、打开后、关闭后的观察结果。
- `fdcount()` syscall 能返回当前进程 `ofile[]` 中非空 fd 数量。
- `fdcounttest` 能输出 open、dup、close 后的 fd delta，并把 fcount delta 作为观察对比。
- 测试不固定具体数值，只验证稳定输出前缀。

## 已真实执行的验证

| 项目 | 结果 |
| --- | --- |
| independent lab4 patch clean apply | PASS |
| independent lab4 patch `make` | PASS |
| independent `fcounttest` | PASS，检测到 `fcounttest done` |
| integrated `0001-0009` clean apply + `make`（stage11b，含 memstat `0008` / fdinfo `0009`） | PASS（队长本机） |
| integrated `fcounttest` 前缀捕获 | PASS，检测到 `fcount(before) =`、`fcount(after_open) =`、`fcount(after_close) =`、`fcounttest done` |
| integrated `fdcounttest` 捕获 | PASS，检测到 `fdcounttest done`；fd delta open=1、dup=2、close one=1、close two=0 |

本地一次输出中观察到 `fcount(before) = 1`、`fcount(after_open) = 2`、`fcount(after_close) = 1`。该数值只作为一次真实样例，不作为固定测试期望。

## 推荐验证命令

```bash
bash scripts/xv6/apply-integrated-labs.sh --make --yes
bash scripts/xv6/run-xv6-command.sh fcounttest "fcount(before) ="
bash scripts/xv6/run-xv6-command.sh fcounttest "fcount(after_open) ="
bash scripts/xv6/run-xv6-command.sh fcounttest "fcount(after_close) ="
bash scripts/xv6/run-xv6-command.sh fcounttest "fcounttest done"
bash scripts/xv6/run-xv6-command.sh fdcounttest "fdcounttest done"
```

## 记录要求

- 不伪造测试结果。
- 不提交 `logs/*.log` 原始日志。
- 只在 `docs/04_test_report.md` 中摘录关键命令、结果、风险和边界。
- 若后续数值变化，应记录为环境/时序差异，不应改成固定通过值。

## 与测试报告的关系

正式测试摘要记录在 [../../docs/04_test_report.md](../../docs/04_test_report.md)。本文件只记录 lab4 的测试目标、当前验证状态和后续补充方向。

## 进阶可选：fdinfo（advanced optional, independent）

`fdinfo()` 是 Lab4 的进阶可选 independent patch（`patches/lab4-file-table-observation/0002-add-fdinfo-syscall.patch`），用 `argint + argaddr + copyout` 把当前进程某个 fd 的 `{type, readable, writable, ref}` 拷回用户态；只查 `myproc()->ofile[fd]`，不返回路径/inode 号/内容。

验证命令（clean baseline，独立于 `0001`）：

```bash
git -C external/xv6-riscv reset --hard 74f84181a3404d1d6a6ff98d342233979066ebb8
git -C external/xv6-riscv clean -fdx
git -C external/xv6-riscv apply ../../patches/lab4-file-table-observation/0002-add-fdinfo-syscall.patch
make -C external/xv6-riscv
bash scripts/xv6/run-xv6-command.sh fdinfotest "fdinfotest done"
```

真实结果（clean baseline round-trip 已验证）：

| 测试项 | 结果 |
| --- | --- |
| clean baseline apply + `make` | PASS |
| `fdinfo open fd ok`（O_RDWR：type=FD_INODE、readable、writable） | PASS |
| `fdinfo dup fd ok` | PASS |
| `fdinfo closed fd = -1` | PASS |
| `fdinfo bad fd = -1` | PASS |
| `fdinfotest done` | PASS |

`ref` 被观察输出但不强断言。边界：independent 版 `SYS_fdinfo = 22`（与 `fcount` 不可叠加）。stage11b 起 `fdinfo` **已进入** integrated `0009`（`SYS_fdinfo = 30`），current integrated suite 为 `0001-0009`，`fdinfotest` 已纳入 local/teammate full verify 并在队长本机 `local-verify --full` overall PASS。证据边界：`0001-0009` 的三方复现、新视频、新 SHA256 已于 stage14 在 current final commit `db85947` 上完成登记（见 `submissions/evidence_manifest.md`）；`e8e2fb9 / 0001-0007` 三方 full PASS 为 historical stable checkpoint。

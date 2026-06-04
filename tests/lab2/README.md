# lab2 测试记录

## 测试目标

lab2 测试用于验证进程观察类 syscall 是否能完成以下闭环：

1. 从 clean baseline 应用 lab2 patch。
2. 构建 xv6。
3. 在 xv6 中运行 `pstatetest`、`pcounttest`、`pchildtest`。
4. 捕获 `pstate(self) =` 输出。
5. 捕获实际状态文本 `RUNNING`。
6. 捕获 `pcount(RUNNING) =` 和 `pcount(99) = -1`。
7. 捕获 `pstate(child) =`。

## 已真实执行命令

| 目的 | 命令 | 结果 |
| --- | --- | --- |
| clean baseline apply | `git apply ../../patches/lab2-process-observation/0001-add-pstate-syscall.patch` | PASS |
| 构建 patched xv6 | `cd external/xv6-riscv && make` | PASS |
| 捕获 pstatetest 前缀 | `bash scripts/xv6/run-xv6-command.sh pstatetest "pstate(self) ="` | PASS |
| 捕获 RUNNING | `bash scripts/xv6/run-xv6-command.sh pstatetest "RUNNING"` | PASS |
| integrated 0001-0004 构建 | `bash scripts/xv6/apply-integrated-labs.sh --make --yes` | PASS |
| 捕获 pcount RUNNING 前缀 | `bash scripts/xv6/run-xv6-command.sh pcounttest "pcount(RUNNING) ="` | PASS |
| 捕获 pcount 负向测试 | `bash scripts/xv6/run-xv6-command.sh pcounttest "pcount(99) = -1"` | PASS |
| 捕获子进程状态前缀 | `bash scripts/xv6/run-xv6-command.sh pchildtest "pstate(child) ="` | PASS |

## 证据摘要

| 证据 | 状态 | 说明 |
| --- | --- | --- |
| patch apply | PASS | lab2 patch 独立应用到 baseline commit |
| make | PASS | 仍有已知 linker RWX warning |
| pstatetest output | PASS | 实际观察到 `pstate(self) = 4 (RUNNING)` |
| pcounttest output | PASS | 实际观察到 `pcount(RUNNING) = 1` 和 `pcount(99) = -1`；RUNNING 数字不固定承诺 |
| pchildtest output | PASS | 实际观察到 `pstate(child) = ...`；状态受调度时序影响 |

原始日志被 Git 忽略，不应提交。

## 尚未覆盖

- TODO: 长期 QEMU 稳定性测试。
- TODO: 人工交互 shell 测试与录屏。
- TODO: 第二名队员独立复现。
- TODO: 锁遗漏、syscall number 冲突等负向教学用例。
- TODO: 与 lab1 patch 合并后的 syscall number 规划。

## 与测试报告的关系

正式摘要记录在 `docs/04_test_report.md`。lab2 复现审查见 `docs/15_lab2_process_observation_review.md`。本文件保留 lab2 专项测试说明，不复制完整日志。

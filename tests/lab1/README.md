# lab1 测试记录

## 测试目标

lab1 测试用于验证两个 system call patch：

- minimal：`hello()`，输出 `hello syscall returned 2026`。
- advanced：`add2(int a, int b)`，通过 `argint()` 获取参数，输出 `add2(20, 6) returned 26`。

## 已真实执行命令

| 目的 | 命令 | 结果 |
| --- | --- | --- |
| 初始 hello 回归 | `bash scripts/xv6/run-xv6-command.sh hello "hello syscall returned 2026"` | PASS |
| clean baseline + 0001 + 0002 apply | `git apply` patch sequence | PASS |
| 构建 patched xv6 | `cd external/xv6-riscv && make` | PASS |
| hello 回归 | `bash scripts/xv6/run-xv6-command.sh hello "hello syscall returned 2026"` | PASS |
| add2 输出捕获 | `bash scripts/xv6/run-xv6-command.sh add2test "add2(20, 6) returned 26"` | PASS |

## 证据摘要

| 证据 | 状态 | 说明 |
| --- | --- | --- |
| baseline make | PASS | stage2 已记录 |
| boot evidence | PASS | stage2 已记录；stage3 最终验证会复跑 |
| hello output | PASS | stage3a 在 `0001+0002` 后仍成功 |
| add2test output | PASS | stage3a 捕获到 `add2(20, 6) returned 26` |

原始日志被 Git 忽略，不应提交。

## 尚未覆盖

- TODO: 长期 QEMU 稳定性测试。
- TODO: 人工交互 shell 测试与录屏。
- TODO: 第二名队员独立复现。
- TODO: 负向测试，例如 syscall number 冲突、用户态 stub 缺失、参数错误。

## 与测试报告的关系

正式摘要记录在 `docs/04_test_report.md`。进阶 add2 复现审查见 `docs/14_lab1_argint_extension_review.md`。本文件保留 lab1 专项测试说明，不复制完整日志。

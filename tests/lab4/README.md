# lab4 测试记录

## 当前测试目标

lab4 v0.1 用于验证文件表观察实验：

- `fcount()` syscall 能返回当前全局文件表中 `ref > 0` 的 `struct file` 数量。
- `fcounttest` 能输出打开临时文件前、打开后、关闭后的观察结果。
- 测试不固定具体数值，只验证稳定输出前缀。

## 已真实执行的验证

| 项目 | 结果 |
| --- | --- |
| independent lab4 patch clean apply | PASS |
| independent lab4 patch `make` | PASS |
| independent `fcounttest` | PASS，检测到 `fcounttest done` |
| integrated `0001-0005` clean apply + `make` | PASS |
| integrated `fcounttest` 前缀捕获 | PASS，检测到 `fcount(before) =`、`fcount(after_open) =`、`fcount(after_close) =`、`fcounttest done` |

本地一次输出中观察到 `fcount(before) = 1`、`fcount(after_open) = 2`、`fcount(after_close) = 1`。该数值只作为一次真实样例，不作为固定测试期望。

## 推荐验证命令

```bash
bash scripts/xv6/apply-integrated-labs.sh --make --yes
bash scripts/xv6/run-xv6-command.sh fcounttest "fcount(before) ="
bash scripts/xv6/run-xv6-command.sh fcounttest "fcount(after_open) ="
bash scripts/xv6/run-xv6-command.sh fcounttest "fcount(after_close) ="
bash scripts/xv6/run-xv6-command.sh fcounttest "fcounttest done"
```

## 记录要求

- 不伪造测试结果。
- 不提交 `logs/*.log` 原始日志。
- 只在 `docs/04_test_report.md` 中摘录关键命令、结果、风险和边界。
- 若后续数值变化，应记录为环境/时序差异，不应改成固定通过值。

## 与测试报告的关系

正式测试摘要记录在 [../../docs/04_test_report.md](../../docs/04_test_report.md)。本文件只记录 lab4 的测试目标、当前验证状态和后续补充方向。

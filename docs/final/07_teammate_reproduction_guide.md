# 07 Teammate Reproduction Guide

## 目标

让队友在不熟悉 QEMU 和 xv6 的情况下，用最少命令完成正式复现，并把结果以 summary 形式反馈给队长。

## 第一次正式复现

在 WSL2 Ubuntu 中进入仓库根目录：

```bash
git pull
bash scripts/xv6/teammate-verify.sh --full
```

`--full` 会执行：

1. `doctor.sh`。
2. `scripts/check-env.sh`。
3. `scripts/xv6/check-xv6-baseline.sh`。
4. `scripts/xv6/apply-integrated-labs.sh --make --yes`。
5. `scripts/xv6/boot-xv6.sh`。
6. hello/add2test/pstatetest/pcounttest/pchildtest/fcounttest/pgcounttest/fdcounttest。

## 已经 make 成功后的重测

如果已经看到：

```text
[OK] make completed successfully
```

说明 apply+make 完成，不要继续等。二次重测用：

```bash
bash scripts/xv6/teammate-verify.sh --quick
```

## 卡住处理

正常 boot/命令验证应在脚本 timeout 内返回。超过 5 分钟先按：

```text
Ctrl+C
```

不要用 `Ctrl+Z` 当退出。`Ctrl+Z` 是 suspend，可能把 QEMU 或 `make qemu` 留在后台。

清理：

```bash
bash scripts/xv6/cleanup-qemu.sh
```

如果当前 shell 显示 stopped job：

```bash
jobs -l
kill %1
```

## 反馈给队长

复制最后的：

```text
COPY THIS SUMMARY TO TEAM LEAD
...
END SUMMARY
```

或复制 summary 文件内容：

```text
logs/teammate-verify-YYYYMMDD-HHMMSS.summary.txt
```

注意：summary 文件不提交 Git，只作为反馈文本。

## 当前已收到的队友结果

> stage11b 更新：current integrated suite 已扩展为 `0001-0009`（新增 memstat `0008` / fdinfo `0009`），`teammate-verify.sh --full` 现在包含 `memstattest` 和 `fdinfotest`。下表的 `e8e2fb9` 三方 PASS 是 **historical stable checkpoint**，只覆盖 `0001-0007`，**不覆盖** `0001-0009`。含 memstat/fdinfo 的 `0001-0009` 队友复现必须在用户提交新 commit 后由 rain/root/z2996 重新执行，当前为 TBD，不得伪造。

截至 2026-06-07，historical stable checkpoint commit `e8e2fb9 feat(integrated): add lab3 pgcount and lab4 fdcount workflow` 已收到两份队友 `--full` verification PASS 证据。它们覆盖 integrated `0001-0007`，包括 `pgcounttest` 和 `fdcounttest`：

| 记录 | 终端 user | repo root | commit | mode | overall |
| --- | --- | --- | --- | --- | --- |
| 队友 A | `root` | `/root/workspace/proj54-ouc-os-lab` | `e8e2fb9 feat(integrated): add lab3 pgcount and lab4 fdcount workflow` | `full` | PASS |
| 队友 B | `z2996` | `~/workspace/proj54-ouc-os-lab` | `e8e2fb9 feat(integrated): add lab3 pgcount and lab4 fdcount workflow` | `full` | PASS |

文字摘要和外部证据 SHA256 见 `submissions/teammate_reproduction_record.md` 与 `submissions/evidence_manifest.md`。原始 logs、summary 文件、console log 和截图不入仓；队友真实姓名和系统版本仍保持待补充，不补造。

旧 commit `1ba9db6` 的两份队友 PASS 只作为 historical/superseded evidence，不覆盖 `e8e2fb9`；而 `e8e2fb9` 的三方 PASS 又只覆盖 `0001-0007`，不覆盖 stage11b 的 `0001-0009`。

## 队友反馈模板

```text
复现人：待补充
机器环境：待补充
运行模式：--full / --quick
是否看到 make completed successfully：是/否
是否按过 Ctrl+Z：是/否
是否运行 cleanup-qemu.sh：是/否
COPY THIS SUMMARY TO TEAM LEAD：
待粘贴
```

## 不要做

- 不提交 `external/xv6-riscv/`。
- 不提交 `logs/*.log` 或 summary。
- 不发送 token、密码、cookie、隐私截图。
- 不把失败结果改写成成功。
- 不把队长本机验证写成队友验证。

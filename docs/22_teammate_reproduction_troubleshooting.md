# 队友复现故障排查：QEMU 卡住、timeout 与清理

> 维护时间：2026-06-06（stage7a0 qemu timeout/cleanup 加固）。
> 本文面向队友复现 integrated-labs 时的卡住问题，不包含 token、密码、报名材料或原始日志。

## 1. 先确认 apply 和 make 是否已经完成

运行：

```bash
bash scripts/xv6/apply-integrated-labs.sh --make --yes
```

如果已经看到：

```text
[OK] make completed successfully
```

就说明 apply + make 阶段已经完成，不要继续等这个命令。它不是交互式 QEMU；下一步应该回到仓库根目录继续运行 `boot-xv6.sh` 或 `run-xv6-command.sh`。

## 2. boot-xv6.sh 正常耗时

运行：

```bash
bash scripts/xv6/boot-xv6.sh
```

正常情况下 1-2 分钟内会返回。脚本默认每次 attempt 有软 timeout 和外层硬 timeout，并且最多重试 2 次。

如果超过 5 分钟仍然没有返回，应按 `Ctrl+C` 中断。不要用 `Ctrl+Z` 当作退出方式。

## 3. Ctrl+Z 不是退出

`Ctrl+Z` 的含义是挂起当前前台任务，不是退出。它可能把 `bash`、`timeout`、`make qemu` 或 `qemu-system-riscv64` 留在后台挂起状态，后续再运行脚本时就会出现端口、终端或 QEMU 残留问题。

本仓库脚本已尝试在收到 `Ctrl+C`、`TERM` 和 `Ctrl+Z/SIGTSTP` 时清理当前项目相关 QEMU 进程；但如果任务已经被 shell 挂起，仍应手动检查并清理。

## 4. 手动清理命令

在 WSL2 Ubuntu 里执行：

```bash
jobs -l
kill %1
pkill -f qemu-system-riscv64 || true
pkill -f "make qemu" || true
```

说明：

- `jobs -l` 查看当前 shell 里被挂起的任务。
- `kill %1` 结束第 1 个 job；如果 `jobs -l` 显示的编号不是 1，请换成实际编号。
- `pkill -f qemu-system-riscv64 || true` 清理残留 QEMU。
- `pkill -f "make qemu" || true` 清理残留的 make/qemu 包装进程。

清理后可以再跑：

```bash
pgrep -af 'qemu-system-riscv64|make.*qemu' || echo "(OK: no qemu/make qemu process)"
```

## 5. 如何继续复现

建议从仓库根目录重新开始以下命令：

```bash
bash scripts/xv6/apply-integrated-labs.sh --make --yes
bash scripts/xv6/boot-xv6.sh
bash scripts/xv6/run-xv6-command.sh hello "hello syscall returned 2026"
bash scripts/xv6/run-xv6-command.sh add2test "add2(20, 6) returned 26"
bash scripts/xv6/run-xv6-command.sh pstatetest "pstate(self) ="
bash scripts/xv6/run-xv6-command.sh pcounttest "pcount(RUNNING) ="
bash scripts/xv6/run-xv6-command.sh pchildtest "pstate(child) ="
bash scripts/xv6/run-xv6-command.sh fcounttest "fcounttest done"
```

如果机器较慢或 `/mnt/d` 目录存在 mtime skew，可临时加长 timeout：

```bash
XV6_BOOT_TIMEOUT_SECONDS=60 XV6_BOOT_RETRIES=2 XV6_BOOT_HARD_TIMEOUT_SECONDS=90 bash scripts/xv6/boot-xv6.sh
XV6_COMMAND_TIMEOUT_SECONDS=75 XV6_COMMAND_RETRIES=2 XV6_COMMAND_HARD_TIMEOUT_SECONDS=90 bash scripts/xv6/run-xv6-command.sh fcounttest "fcounttest done"
```

成功必须来自日志中真实匹配到预期文本，不能手写或伪造。

## 6. 如何反馈给队长

请反馈以下信息：

- 运行环境：WSL2 Ubuntu 版本、是否在 `/mnt/d` 或 Linux home 目录下运行。
- 执行的命令：逐条复制命令，不要只写“跑了脚本”。
- 脚本结果：是否看到 `BOOT_EVIDENCE_FOUND` 或 `COMMAND_EVIDENCE_FOUND`。
- 日志路径：例如 `logs/xv6-boot-YYYYMMDD-HHMMSS-attempt1.log`。
- 失败原因：超时、缺少工具链、make 失败、预期输出未匹配，按脚本实际输出记录。
- 清理动作：是否执行过 `jobs -l`、`kill %1`、`pkill -f qemu-system-riscv64`。

原始 `logs/*.log` 默认不提交。如果需要发给队长排查，先确认里面没有个人路径以外的敏感信息。

## 7. 安全边界

- 不提交 `external/xv6-riscv/`。
- 不提交 `logs/*.log`。
- 不发 token、密码、cookie、报名材料或含隐私的截图。
- 不把 timeout 自动捕获说成人工交互录屏。
- 不把失败结果改写成成功。

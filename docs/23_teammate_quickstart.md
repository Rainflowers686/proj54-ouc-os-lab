# 队友一键复现 Quickstart

> 维护时间：2026-06-06（stage7a1 一键复现流程）。
> 面向不熟悉 WSL/QEMU 的队友：按下面步骤做，不要自己猜命令。

## 1. 先更新仓库

在 WSL2 Ubuntu 里进入仓库目录后运行：

```bash
git pull
```

所有真实 `make` / QEMU / boot / 命令验证都必须在 WSL2 Ubuntu 里跑，不要在 PowerShell 或 Git Bash 里伪报成功。

## 2. 只运行这一条

```bash
bash scripts/xv6/teammate-verify.sh
```

它会自动完成：

- 环境检查；
- xv6 baseline 检查；
- integrated `0001-0005` apply + make；
- boot evidence；
- hello / add2test / pstatetest / pcounttest / pchildtest / fcounttest 验证；
- 最终 summary。

summary 会写到：

```text
logs/teammate-verify-YYYYMMDD-HHMMSS.summary.txt
```

`logs/` 是 ignored，不要提交。

## 3. 正常情况

正常情况下，终端最后会看到一个 summary 表格，大致长这样：

```text
| environment | PASS |
| apply+make | PASS |
| boot | PASS |
| hello | PASS |
| add2test | PASS |
| pstatetest | PASS |
| pcounttest | PASS |
| pchildtest | PASS |
| fcounttest | PASS |
```

以你本机真实输出为准，不要手改结果。

## 4. 如果卡住超过 5 分钟

先按：

```text
Ctrl+C
```

不要按 `Ctrl+Z`。`Ctrl+Z` 是挂起，不是退出，可能把 QEMU 留在后台。

如果你已经按过 `Ctrl+Z`，运行：

```bash
bash scripts/xv6/cleanup-qemu.sh
```

如果终端显示 `Stopped` 和 `%1`，可以在同一个 shell 里执行：

```bash
jobs -l
kill %1
```

如果编号不是 `%1`，按 `jobs -l` 显示的实际编号改。

## 5. 怎么反馈给队长

请发这些内容：

- 最终 summary 截图；
- `logs/teammate-verify-*.summary.txt` 的文本内容；
- 如果失败，复制失败步骤附近的终端输出；
- 说明你是否按过 `Ctrl+Z`，是否运行过 `cleanup-qemu.sh`。

不要发：

- token；
- 密码；
- cookie；
- 报名材料；
- 含隐私信息的截图。

不要提交：

- `logs/*.log`；
- `logs/teammate-verify-*.summary.txt`；
- `external/xv6-riscv/`。

## 6. 常见问题

### `riscv64-unknown-elf-gcc` 是 WARN

可以接受。当前工程使用 `riscv64-linux-gnu-gcc` 可以完成 xv6 构建。

### `LOAD segment with RWX permissions`

这是当前 xv6 baseline / binutils 的 linker warning，不等于本轮实验失败。只要脚本 summary 是 PASS，就按 PASS 记录。

### `pcount(RUNNING)` 的数字不一样

正常。`pcount` 受运行时状态影响，验证只看稳定前缀 `pcount(RUNNING) =` 和负例 `pcount(99) = -1`。

### `fcount(...)` 的数字不一样

正常。`fcount` 绝对数值受环境影响，验证只看稳定输出和 `fcounttest done`。

### `pchildtest` 状态不一样

正常。child state 受调度时序影响，可能出现 `RUNNABLE`、`SLEEPING` 等有效状态。验证只看 `pstate(child) =`。

## 7. 不能做什么

- 不要 `git add external`。
- 不要 `git add logs`。
- 不要把密码、token、cookie 截图发群里。
- 不要把失败改成成功。
- 不要把自动 timeout 证据说成人工录屏。

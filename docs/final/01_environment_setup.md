# 01 Environment Setup

## 实验目标

建立可复现的 xv6-riscv 实验环境，并明确哪些目录和文件可以提交、哪些只能留在本地。

## 推荐环境

| 项目 | 要求 |
| --- | --- |
| OS | WSL2 Ubuntu 24.04 或等价 Linux |
| 基础工具 | `git`、`bash`、`make` |
| QEMU | `qemu-system-riscv64` |
| RISC-V compiler | `riscv64-linux-gnu-gcc` |
| 可选工具 | `riscv64-unknown-elf-gcc`，当前缺失只记 WARN |

Windows PowerShell、Git Bash、MINGW64 不能作为真实 make/QEMU 验证环境。

## 仓库结构

| 路径 | 用途 | 是否提交 |
| --- | --- | --- |
| `docs/final/` | 正式提交文档入口 | 是 |
| `labs/` | 各实验教程 | 是 |
| `patches/` | 可复现 patch | 是 |
| `scripts/` | 环境检查、复现、验证脚本 | 是 |
| `external/xv6-riscv/` | 第三方 xv6 源码 | 否 |
| `logs/` | 本地原始日志和 summary | 否，除 `logs/README.md` |
| `.claude/`、`.vscode/` | 本地工具目录 | 否 |
| 视频文件 | 录屏材料 | 否，仓库只记录状态 |

## 环境诊断

```bash
bash scripts/xv6/doctor.sh
```

该脚本只读检查：

- 当前时间、路径、`uname -a`。
- 当前 commit。
- 是否在 Git 仓库内。
- `git`、`bash`、`make`、`qemu-system-riscv64`、`riscv64-linux-gnu-gcc`。
- `riscv64-unknown-elf-gcc` 是否存在；缺失只 WARN。
- `external/xv6-riscv/` 与 baseline record 是否存在。
- `logs/` 是否被正确 ignore。
- 是否有 QEMU 残留进程。
- 当前路径是否在 `/mnt/` 下。

结论可能是 `READY`、`READY WITH WARNINGS` 或 `NOT READY`。

## 获取 baseline

```bash
bash scripts/xv6/fetch-xv6.sh --run
bash scripts/xv6/check-xv6-baseline.sh
```

baseline 信息：

| 字段 | 内容 |
| --- | --- |
| Upstream | `https://github.com/mit-pdos/xv6-riscv.git` |
| Commit | `74f84181a3404d1d6a6ff98d342233979066ebb8` |
| Local path | `external/xv6-riscv/` |
| Metadata | `external/xv6-baseline-record.md` |

## 构建与 QEMU 注意事项

- `apply-integrated-labs.sh --make --yes` 会 reset/clean ignored 的 `external/xv6-riscv/`，不会提交第三方源码。
- `/mnt/d` 下可能有 filemode 或 mtime 行为差异；本项目已记录 `user/usys.pl has type 100644, expected 100755` warning，apply+make 实测成功。
- QEMU 卡住时先 `Ctrl+C`，不要用 `Ctrl+Z` 当退出。

## 清理 QEMU

```bash
bash scripts/xv6/cleanup-qemu.sh
```

该脚本会列出可能的 QEMU / `make qemu` 进程，执行 rescue-level `pkill`，并再次列出剩余进程。它可能影响同一 WSL 实例里的其他 QEMU 运行。

## Git 卫生命令

```bash
git status --short
git status --ignored --short external logs .claude
git ls-files external/xv6-riscv
git ls-files logs/*.log
git ls-files logs/*.summary.txt
git ls-files .claude
git ls-files | grep -Ei '\.(mp4|mov|avi|mkv|zip|7z|rar)$' || true
```

预期：`external/xv6-riscv/`、logs、`.claude/` 只应显示为 ignored；`git ls-files` 对这些禁入项应为空。

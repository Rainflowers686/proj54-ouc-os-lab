# Troubleshooting：卡住了先看这里

## 目标

本文帮助学生和队友定位 WSL、QEMU、make、PATH、timeout、`/mnt` 性能和 patch 应用问题。它按症状组织，优先给出可执行命令。

## 适用对象

适用于第一次运行 xv6 实验的学生、队友复现人员和助教。

## 通用第一步

```bash
bash scripts/labctl.sh doctor
```

该命令只读检查 git、bash、make、QEMU、交叉编译器、baseline 和残留 QEMU 进程。若怀疑 QEMU 残留，运行：

```bash
bash scripts/xv6/cleanup-qemu.sh
```

## 高频问题

`make` 或 `qemu-system-riscv64` 找不到，通常是没有进入 WSL2 Ubuntu 或缺少包。安装 `make qemu-system-misc gcc-riscv64-linux-gnu git` 后重试。

第一次 boot 很慢，常见原因是仓库位于 `/mnt/d/...`，drvfs 和 mtime 行为会拖慢构建。可以等待脚本重试，也可以把仓库移到 WSL ext4 路径。

按过 `Ctrl+Z` 后脚本异常，原因是 QEMU 被挂起而非退出。用 `jobs -l` 查看，用 `cleanup-qemu.sh` 清理。退出 QEMU 应使用 `Ctrl-a` 后按 `x`，普通中断用 `Ctrl+C`。

`git apply` 失败，常见原因是基底不对、顺序不对或把 independent patch 互相叠加。综合演示使用 `bash scripts/xv6/apply-integrated-labs.sh --make --yes`。

`run-xv6-command.sh` 找不到期望文本，先手动进入 xv6 shell 跑用户程序，看真实输出，再把期望文本改为稳定前缀。

## 报告故障时提供什么

提供 `doctor` 完整输出、执行过的命令、失败日志末尾 30 行、是否按过 `Ctrl+Z`、是否在 `/mnt` 路径下运行。不要只发截图。

## 质量标准

排障记录应让别人能复现失败和修复过程。报告里应区分环境问题、patch 问题、脚本匹配问题和概念理解问题。

## 边界条件

排障成功不等于 full verification 通过。timeout 捕获成功只说明那次匹配到了目标文本，不代表长期稳定性测试。

## 内容范围

本文内容限定在当前标题所对应的项目记录、教学说明、复现步骤或审查结论内。涉及 当前正式验证范围、历史证据、验证命令和证据材料时，应以 `submissions/evidence_manifest.md`、`patches/integrated-labs/README.md` 和相关脚本为准。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 当前正式验证范围。

## 语言风格

使用中文技术写作风格，命令、文件名、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

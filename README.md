# proj54-ouc-os-lab

**xv6-riscv 教学实验体系** — 面向中国海洋大学低年级计算机学生的 OS 竞赛入门实验。

> 🏆 2026 全国大学生计算机系统能力大赛 · OS 功能挑战赛 · proj54（教学型）
> 👥 中国海洋大学「蓝色系统队」 · 初赛 MVP

---

## 完成状态

| 模块 | 状态 | 说明 |
| --- | --- | --- |
| lab0 baseline/build/boot | ✅ 已完成 | 工具链检查、baseline make、boot evidence |
| lab1 hello/add2 | ✅ 已完成 | `hello()` 和 `add2(int,int)` 系统调用 |
| lab2 pstate/pcount/pchildtest | ✅ 已完成 | 进程状态观察、状态计数、子进程观察 |
| lab4 fcount/fcounttest | ✅ 已完成 | 文件表引用计数观察（非完整文件系统） |
| integrated 0001–0005 | ✅ 已完成 | 综合演示 patch 序列，同一构建中 6 个用户程序全部验证 |
| teammate/local verify | ✅ 已完成 | 队友一键复现、队长录屏前自检、QEMU 快速退出 |
| lab3 memory/pagetable | 🔲 计划中 | 未完成 |
| lab5 final integration | 🔲 计划中 | 最终集成与报告 |
| 队友独立复现 | 🔲 TODO | 待第二名队员在其他机器执行 |
| 人工交互录屏 | 🔲 TODO | 待录制真实 boot+6 命令操作 |

**当前阶段：初赛 MVP v0.1，可诚实提交；冲奖仍需补齐队友复现 + 录屏 + 技术报告 v0.2。**

---

## 评委快速复现

> 所有真实 `make` / `qemu` / boot / 命令验证都必须在 **WSL2 Ubuntu**（或等价原生 Linux）中执行。Windows Git Bash / MINGW64 / PowerShell 无 RISC-V 工具链，不能在此伪报成功。

```bash
# 1. 只读环境诊断（不运行 make/QEMU，不修改仓库）
bash scripts/xv6/doctor.sh

# 2. 队友正式复现（第一次用 --full，自动 apply+make+boot+6 命令验证）
bash scripts/xv6/teammate-verify.sh --full

# 3. 二次重测（已 make 成功后，跳过 apply+make）
bash scripts/xv6/teammate-verify.sh --quick
```

如果卡住超过 5 分钟：`Ctrl+C`（不要 `Ctrl+Z`），然后运行：

```bash
bash scripts/xv6/cleanup-qemu.sh
```

队长录屏前本地自检：

```bash
bash scripts/xv6/local-verify.sh --quick
```

---

## 仓库目录

```text
docs/              项目计划、赛题拆解、实验设计、测试报告、审查报告、FAQ
labs/              各 lab 教程（lab0–lab5）
patches/           独立 patch 与 integrated-labs 综合 patch 序列（0001–0005）
scripts/           环境检查、baseline、boot、命令验证、一键复现、cleanup
reproducibility/   队友与评委复现包
submissions/       初赛材料索引与提交 Checklist
external/          第三方 xv6-riscv 源码 metadata（源码被 .gitignore 忽略）
logs/              原始日志说明（logs/*.log 被 .gitignore 忽略）
references/        参考资料与许可证
slides/            PPT 结构计划（成品 TODO）
videos/            Demo 脚本与视频说明（录屏 TODO）
```

---

## 关键文档入口

| 文档 | 路径 |
| --- | --- |
| 提交就绪度总审查 | `docs/21_submission_readiness_review.md` |
| 队友一键复现 Quickstart | `docs/23_teammate_quickstart.md` |
| 队友故障排查 | `docs/22_teammate_reproduction_troubleshooting.md` |
| lab4 文件表观察审查 | `docs/20_lab4_file_table_observation_review.md` |
| 提交 Checklist | `submissions/submission_checklist.md` |

完整文档索引见 `submissions/draft-report-index.md`（运行 `bash scripts/collect-report.sh` 自动生成）。

---

## 诚信与边界

- `external/xv6-riscv/` 是第三方源码，**不入库**（`.gitignore` 已忽略）。
- `logs/*.log` 是原始日志，**不入库**（`.gitignore` 已忽略）。
- 所有用户程序验证均为 **timeout 自动捕获证据**，不等同于长期稳定性测试或人工交互录屏。
- `pcount(RUNNING)` 和 `fcount(...)` 的具体数字**不固定**，只验证稳定输出前缀。
- `pchildtest` 输出状态**受调度时序影响**（可能看到 RUNNABLE、SLEEPING 等），只验证 `pstate(child) =` 前缀。
- `run-xv6-command.sh` 捕获 expected output 后会**尽快终止 QEMU**，不等完整 timeout。
- `.claude/` 等本地 AI/IDE 工具目录**不入库**。
- 未完成内容均标注 🔲 TODO 或计划中，不将 TODO 写成已完成。

---

## 已知限制

- lab3（内存与页表）未完成。
- lab4 仅是文件表引用计数观察，不是完整文件系统实验。
- 第二名队友独立复现待真实执行；所有当前证据均为单机 timeout 捕获。
- 人工交互录屏待完成。

---

## 协作规范

- 小步提交，优先提交可复核的文档、脚本、patch 和真实验证记录。
- commit message 建议 `type: summary`（如 `docs: add technical report`）。
- 不上传报名材料、个人隐私、账号密码、token、截图原件或大型二进制文件。
- 不伪造实验结果、运行截图、commit hash、视频或评审意见。
- 修改 xv6 时导出 patch，不提交 `external/xv6-riscv/`。
- AI 使用记录见 `docs/05_ai_usage_record.md`。

---

## 引用与许可证

参考资料与许可证记录见 `docs/08_reference_and_license.md`。第三方 xv6-riscv 源码仅保存在 ignored 的 `external/xv6-riscv/`，不作为本仓库源码提交。

# docs 导航：你该看哪个文件

> 维护时间：2026-06-12（stage19 入口微调；结构自 stage12）。current integrated suite 为 `0001-0009`。

docs 目录里放了几类材料：学生教程、教师/助教材料、正式提交文档，还有早期过程记录。不要从 `docs/00` 一路顺序读到 `docs/24`。先看你现在要做什么，再进对应入口；编号过程文档主要给追溯历史的人看。

## 1. 第一次学 OS 实验：先按这个顺序看

1. 根目录 [README.md](../README.md)：学习路线总览（第 0 步到第 7 步），开头还有"建议补的知识"和精选阅读。
2. [docs/final/01_environment_setup.md](final/01_environment_setup.md)：装环境。
3. `labs/lab0` → `lab1` → `lab2` → `lab3` → `lab4` → `lab5`，每个目录先读 `README.md` 再做 `student_tasks.md`。
4. 卡住了看 [docs/troubleshooting.md](troubleshooting.md)。
5. 想补背景或往深里走：[references/README.md](../references/README.md)（赛题原文、xv6 官方、rCore/uCore/PKE、往届作品，都标了"什么时候看"）。

学习阶段先不用读 `docs/final/` 的报告，也不用翻编号文档。先把 Lab0-Lab2 跑通，比提前读完整个仓库更有用。

## 2. 已经能跑 xv6：直接进 Lab

- 统一入口：`bash scripts/labctl.sh help`。做完某一关只测那一关：`labctl test lab3`；看 lab↔测试对应关系：`labctl list`。
- 想一次跑全部：`bash scripts/labctl.sh verify`（等价 `scripts/xv6/teammate-verify.sh --full`，覆盖 integrated `0001-0009` 的 10 个测试程序）。
- 想理解某个 syscall 的实现：看对应 lab 的 README，再直接读 `patches/integrated-labs/` 里那个 patch——每个 patch 就是一次完整的"加 syscall"操作记录。
- 想理解 `argaddr + copyout + struct ABI`：Lab3 进阶 `memstat`（integrated `0008`）和 Lab4 进阶 `fdinfo`（integrated `0009`）。

## 3. 老师/助教：布置与验收

- [docs/teacher_guide.md](teacher_guide.md)：课次安排、必做/选做划分、验收方式、学生环境问题处理。
- [docs/grading_and_rubric.md](grading_and_rubric.md)：评分建议与常见扣分点。
- 每个 lab 的 `student_tasks.md` 可以直接当作业布置；验收统一收 `teammate-verify.sh` 的 summary 块，收齐后用 `bash scripts/grade-summaries.sh <目录>` 批量解析和防伪标记（辅助验收，不是评分）。

## 4. 评委/提交材料：先看证据在哪

- [docs/final/](final/)：正式提交文档（项目概述、各 lab 正式版、测试覆盖、设计取舍、AI/许可证声明、技术报告 v1.0）。
- [submissions/evidence_manifest.md](../submissions/evidence_manifest.md)：证据总索引——current final（`db85947 / 0001-0009`：三方 full PASS + 新视频 + SHA256，stage14 已登记）与 historical checkpoint（`e8e2fb9 / 0001-0007`）分层记录。
- [submissions/draft-report-index.md](../submissions/draft-report-index.md)：全部材料清单，由 `scripts/collect-report.sh` 生成。
- [slides/final_ppt.md](../slides/final_ppt.md)：答辩 PPT 源稿。
- [submissions/submission_checklist.md](../submissions/submission_checklist.md)：提交前自查清单（最后一节是全检命令块）。

## 5. 过程记录：历史在这里，新手别先读

`docs/00` 到 `docs/24` 是按阶段留下的开发与红队记录（计划、审查、踩坑、阶段结论），`docs/05_ai_usage_record.md` 和 `docs/06_progress_log.md` 是逐条流水账。它们的价值是"为什么当时这么做"可以追溯，但其中的"当前状态"描述只对所写阶段成立——例如 stage9c 文档里的 `0001-0007` 早已被 `0001-0009` 取代。旧阶段文档只能解释当时为什么这么做，不能覆盖当前正式验证范围。想追溯历史时再来，新手优先级最低。

`docs/13_technical_report_v0.1.md` 是早期草案，已被 `docs/final/technical_report_v1.0.md` 取代，仅作过程透明保留。

提交前三道机器门禁：`bash scripts/check-final-hygiene.sh`、`bash scripts/check-docs-consistency.sh`、`bash scripts/check-evidence-sha256.sh`。

## 提交边界（一直成立）

- 不提交 `external/xv6-riscv/`、`logs/*.log`、`logs/*.summary.txt`、`logs/*.console.txt`、`.claude/`、`.vscode/`、视频、截图、大文件、隐私材料。
- 不把队长本机验证写成队友复现；不把 timeout 捕获写成长期稳定性测试。
- 旧证据不冒充新证据：`0001-0007` 三方 PASS 不覆盖 `0001-0009`。

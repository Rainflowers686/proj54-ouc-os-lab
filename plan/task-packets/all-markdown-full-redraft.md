# Task Packet

## Scope

全量重写本仓库全部 Markdown 文档。范围包括根 `README.md`、`docs/`、`labs/`、`patches/`、`submissions/`、`slides/`、`tests/`、`references/`、`videos/`、`external/`、`logs/`、`reproducibility/` 和 `plan/`。排除 `graphify-out/` 缓存和非 Markdown 文件。

## Files to read

- `README.md`
- `docs/documentation_standard.md`
- `submissions/evidence_manifest.md`
- `patches/integrated-labs/README.md`
- `scripts/collect-report.sh`
- `scripts/check-docs-consistency.sh`
- `scripts/check-final-hygiene.sh`
- all tracked and untracked `*.md` files outside `graphify-out/`

## Files allowed to edit

- `*.md` files outside `graphify-out/`
- `plan/task-packets/all-markdown-full-redraft.md`
- `plan/progress.md`

## Required skills

- `caveman`
- `caveman-compress`
- `universal-fable-5`
- `graphify`
- `research-writing-assistant`
- `using-research-writing`
- `paper-orchestration`
- `writing-core`
- `verification`

## Evidence and data inputs

当前工程事实以 `submissions/evidence_manifest.md`、`patches/integrated-labs/README.md`、`docs/final/technical_report_v1.0.md` 和脚本门禁为准。current final 为 `db85947 / integrated 0001-0009`。historical `e8e2fb9 / 0001-0007` 只作历史证据。

## Required artifacts

- 所有 Markdown 文档具备明确的目标、适用对象、内容范围、结构规范或使用结构、语言风格、质量标准和边界条件。
- lab 教程保留教学顺序和验证命令。
- student task 文档保留作业、提交、评分和诚信要求。
- patch 文档保留 baseline、应用顺序、验证命令和 independent/integrated 边界。
- submission / slides / videos 文档保留证据和隐私边界。
- `plan/progress.md` 写入 capability-use audit。

## Rejection checks

- 不伪造 PASS、队友复现、视频、截图、summary 或 SHA256。
- 不把 `pgcount`/`memstat` 写成完整内存管理。
- 不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统。
- 不把 Lab5 写成新增内核机制。
- 不把 timeout evidence 写成长期稳定性测试。
- 不把 historical `0001-0007` 证据写成 current final。
- 不把生成型索引和正式 evidence manifest 混同。

## Validation commands

```bash
git diff --check
bash scripts/check-docs-consistency.sh
bash scripts/check-final-hygiene.sh
```

Additional checks:

```powershell
# Markdown structure scan
# Local markdown link scan
```

## 目标

本文记录本次文档重写任务的计划、范围、输入材料、验证命令和能力使用审计。

## 适用对象

本文适用于任务执行者、审计人员和后续接手维护者。

## 内容范围

内容覆盖本次文档重写的任务包、执行进度、技能使用、产物、验证结果和剩余风险。

## 结构规范

计划类文档应保留 Scope、Files to read、Files allowed to edit、Required skills、Evidence inputs、Required artifacts、Rejection checks 和 Validation commands。进度文档应保留阶段、完成项、验证记录和 capability-use audit。

## 语言风格

使用任务审计语言，短句记录事实、命令和结果。不得把计划写成已完成事实。

## 质量标准

计划记录应能解释为什么修改这些文件、使用了哪些技能、验证了哪些门禁、还剩什么风险。

## 边界条件

不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

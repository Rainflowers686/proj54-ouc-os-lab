# Task Packet

## Scope

全量重写 `docs/` 下 Markdown 文档，使其具备清晰的目标、读者、范围、结构规范、语言风格、质量标准和边界条件。重写应保留项目事实、验证命令、证据分层和历史边界。

## Files to read

- `README.md`
- `docs/**/*.md`
- `patches/integrated-labs/README.md`
- `submissions/evidence_manifest.md`
- `scripts/check-docs-consistency.sh`
- `scripts/check-final-hygiene.sh`

## Files allowed to edit

- `docs/**/*.md`
- `plan/*.md`

## Required skills

- `research-writing-assistant`
- `using-research-writing`
- `paper-orchestration`
- `writing-core`
- `verification`
- `universal-fable-5`
- `graphify`
- `caveman`
- `caveman-compress`

## Evidence and data inputs

当前最终工程状态以 `submissions/evidence_manifest.md` 为准：`db85947 / 0001-0009`，rain/root/z2996 三方 full verification PASS，final demo video 与 SHA256 已登记。历史稳定检查点 `e8e2fb9 / 0001-0007` 只能作为 historical evidence。

## Required artifacts

- 重写后的 `docs/README.md`。
- 新增或重写后的文档规范文件。
- 重写后的 `docs/final/` 正式文档。
- 重写后的 `docs/00` 到 `docs/25` 历史文档。
- 更新后的 `plan/progress.md` capability-use audit。

## Rejection checks

- 不能把 Lab5 写成新增内核机制。
- 不能把 `pgcount` 写成完整内存管理。
- 不能把 `fcount`、`fdcount`、`fdinfo` 写成完整文件系统。
- 不能把 timeout evidence 写成长期稳定性测试。
- 不能把 historical `0001-0007` 证据写成 current final。
- 不能伪造队友、视频、日志或 SHA256 证据。

## Validation commands

```bash
bash scripts/check-docs-consistency.sh
bash scripts/check-final-hygiene.sh
git diff --check
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

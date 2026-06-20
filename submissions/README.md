# Submissions Directory

## 目标

本目录组织最终提交材料、证据索引和复现记录，使评审能够定位 当前正式验证范围、历史证据 和不入库原始证据。

## 适用对象

适用于队长、提交材料维护者、指导教师和评审。

## 内容范围

目录包含 `evidence_manifest.md`、`submission_checklist.md`、`demo_record.md`、`teammate_reproduction_record.md` 和 `draft-report-index.md`。它不保存视频、截图、raw logs、summary 原件或隐私材料。

## 结构规范

提交材料应区分 当前正式验证范围、历史证据、外部资产位置和剩余人工确认项。生成型索引需标注生成来源和非最终报告属性。

## 语言风格

使用证据索引语言，写清 suite、文件名、SHA256 和边界。

## 质量标准

证据状态应与 `scripts/check-evidence-sha256.sh` 和 `scripts/check-docs-consistency.sh` 保持一致。

## 边界条件

不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

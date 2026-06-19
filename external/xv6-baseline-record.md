# xv6 Baseline Record

## 目标

本文记录 xv6-riscv baseline 的元数据，帮助复现人员确认 patch 应用基底。

## 适用对象

适用于维护者、队友复现人员和评审。

## 内容范围

baseline repo 为 `https://github.com/mit-pdos/xv6-riscv.git`，baseline 版本由 `scripts/xv6/apply-integrated-labs.sh` 和 `external/xv6-baseline-record.md` 记录。本文件只记录元数据，不保存上游源码。

## 结构规范

baseline 记录应包含 repo、baseline 身份、检查命令和生成时间说明。具体机器参数由复现脚本维护，普通教学文档只引用本记录。

## 语言风格

使用元数据记录语言，避免报告式结论。

## 质量标准

baseline 身份应与 patch README、Lab0 和 technical report 一致。

## 边界条件

不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

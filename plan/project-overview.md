# 项目文档重写概览

## 目标

本文件记录全仓库 Markdown 重写任务的总体目标和范围，作为科研写作流程的项目概览。

## 适用对象

适用于本次文档重写维护者和后续审计人员。

## 内容范围

重写范围覆盖根 README、docs、labs、patches、submissions、slides、tests、references、videos、external、logs、reproducibility 和 plan 下的 Markdown。排除 graphify 缓存。

## 结构规范

所有文档应包含目标、适用对象、内容范围、结构规范或使用结构、语言风格、质量标准和边界条件。任务包可采用固定 Task Packet 模板。

## 语言风格

使用项目审计语言，记录事实、产物、验证和风险。

## 质量标准

任务完成前必须运行文档结构扫描、链接扫描和仓库门禁。

## 边界条件

不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

# Lab5 学生任务书

## 目标

本任务书要求学生完成 integrated `0001-0009` full verification，并提交可被助教复查的综合实验报告。

## 适用对象

适用于已完成 Lab0-Lab4 的学生。

## 内容范围

任务覆盖环境诊断、clean apply、make、boot、全部用户程序验证、patch walkthrough、故障记录和证据边界说明。

## 任务结构

T1：运行 `teammate-verify.sh --full` 并保存 summary。T2：解释 `0001-0009` 每个 patch 的主题。T3：记录一次真实故障或风险项。T4：写明哪些文件不应进入 Git。T5：用三句话说明 Lab5 不新增内核机制。

## 提交要求

提交 summary 块、报告、patch 阅读说明和故障记录。不要提交 raw logs、视频、截图或 `external/xv6-riscv/`。

## 评分标准

full verification 30 分，patch walkthrough 25 分，故障记录 20 分，证据边界 15 分，表达质量 10 分。

## 语言风格

报告应像复现实验说明，不像流水账。每个结论都应能回到命令、输出或文件。

## 质量标准

合格答案必须能被助教按报告重跑，且 summary 未被手工篡改。

## 边界条件

本任务不要求新增 syscall。不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

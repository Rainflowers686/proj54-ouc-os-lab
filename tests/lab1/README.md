# Lab1 Test Record

## 目标

本文记录 Lab1 测试证据的索引和解释，说明 `hello` 与 `add2test` 的验证范围。

## 适用对象

适用于助教、维护者和学生报告复查人员。

## 内容范围

记录覆盖 `hello syscall returned 2026` 和 `add2(20, 6) returned 26`。正式 current final 覆盖以 `submissions/evidence_manifest.md` 为准。

## 结构规范

测试记录应包含命令、匹配文本、范围和边界。

## 语言风格

只记录真实输出，不补写未运行结果。

## 质量标准

记录应能对应 Lab1 README 和验证脚本。

## 边界条件

不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

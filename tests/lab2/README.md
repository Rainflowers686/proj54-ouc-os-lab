# Lab2 Test Record

## 目标

本文记录 Lab2 进程观察测试的证据范围和非固定输出边界。

## 适用对象

适用于助教、维护者和学生报告复查人员。

## 内容范围

记录覆盖 `pstatetest`、`pcounttest` 和 `pchildtest`。`pcount(RUNNING)` 与 child 状态不固定，只验证稳定前缀。

## 结构规范

测试记录应说明命令、匹配文本和调度不确定性。

## 语言风格

避免把一次输出写成必然规律。

## 质量标准

记录应与 Lab2 README、student tasks 和 verification 脚本一致。

## 边界条件

不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

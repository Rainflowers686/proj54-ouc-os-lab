# Lab3 Test Record

## 目标

本文记录 Lab3 页表与地址空间观察测试证据。

## 适用对象

适用于助教、维护者和学生报告复查人员。

## 内容范围

记录覆盖 `pgcounttest` 和 `memstattest`，包括 eager/lazy delta、page size 和结构体 copyout 观察。current final 三方复现以 evidence manifest 为准。

## 结构规范

测试记录应写清 independent 与 integrated 路线，不混用 syscall 编号。

## 语言风格

使用“映射页数观察”和“地址空间统计”描述，不写成内存管理实现。

## 质量标准

记录应能支撑 Lab3 教学任务和技术报告表述。

## 边界条件

不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

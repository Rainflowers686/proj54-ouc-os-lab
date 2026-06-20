# Lab4 Test Record

## 目标

本文记录 Lab4 file/fd 观察测试证据。

## 适用对象

适用于助教、维护者和学生报告复查人员。

## 内容范围

记录覆盖 `fcounttest`、`fdcounttest` 和 `fdinfotest`。具体全局 fcount 数字不固定。

## 结构规范

测试记录应说明 fd table 与 file table 的观察对象差异。

## 语言风格

使用“file/fd metadata observation”而不是“文件系统实现”。

## 质量标准

记录应与 Lab4 README 和 verification 脚本一致。

## 边界条件

不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

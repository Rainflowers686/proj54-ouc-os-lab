# Reproducibility Package

## 目标

本文提供项目复现路线说明，帮助读者从 clean baseline 应用 patch、构建、启动并验证用户程序。

## 适用对象

适用于评审、队友、助教和需要重跑实验的学生。

## 内容范围

复现包覆盖 Lab0、Lab1、Lab2、Lab3、Lab4、Lab5 和 integrated `0001-0009`。正式 current final 以 `teammate-verify.sh --full` 和 evidence manifest 为准。

## 结构规范

复现说明应按环境、baseline、apply、make、boot、run tests、record evidence 的顺序组织。

## 语言风格

使用可执行步骤语言，命令和预期输出分开写。

## 质量标准

别人应能按本文找到对应脚本和正式证据。

## 边界条件

不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

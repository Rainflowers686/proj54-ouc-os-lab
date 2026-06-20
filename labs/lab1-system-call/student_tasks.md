# Lab1 学生任务书

## 目标

本任务书要求学生独立实现一个带整数参数的 xv6 syscall，并能解释从用户程序到内核函数再返回用户态的完整路径。

## 适用对象

适用于已读完 Lab1 README 并成功运行 `hello` 与 `add2test` 的学生。

## 内容范围

任务包括复现参考实现、实现自定义整数 syscall、完成破坏-修复实验、提交 patch 和实验报告。任务不要求实现指针参数或复杂内核功能。

## 任务结构

T1：从 clean baseline 应用 Lab1 patch，运行 `hello` 与 `add2test`。T2：实现 `mul2(int,int)` 或同等难度 syscall，修改 syscall 七件套和用户测试程序。T3：故意删除 stub 或 dispatch 表项，记录失败现象并修复。

## 提交要求

提交增量 patch、真实命令与输出、T3 故障记录、调用路径图或文字说明。不要提交 `external/xv6-riscv/`、raw logs 或截图作为唯一证据。

## 评分标准

复现 20 分，自定义 syscall 35 分，破坏-修复 20 分，调用路径讲解 15 分，报告诚信 10 分。测试程序打印写死答案按伪造处理。

## 语言风格

报告应具体写出文件、函数、命令和输出，避免“照着教程改完了”这类不可评估描述。

## 质量标准

合格答案必须能重新 apply、make 并通过用户程序测试；口头抽查时能解释 `argint()` 参数来源。

## 边界条件

本任务只训练整数 syscall。不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

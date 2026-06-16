# Lab4 学生任务书

## 目标

本任务书要求学生通过实验区分 fd table 与 file table，并能解释 `fdinfo` 的参数读取和结构体返回过程。

## 适用对象

适用于已跑通 `fcounttest`、`fdcounttest` 和 `fdinfotest` 的学生。

## 内容范围

任务包括预测 `open/dup/close` 对计数的影响、审查 `fdinfo` 校验路径、设计负向用例和提交报告。

## 任务结构

T1：预测并验证 `dup` 对 `fdcount` 和 `fcount` 的影响。T2：解释 `fdinfo(fd, out)` 如何检查 fd 和用户指针。T3：增加 closed fd 或 bad fd 测试。T4：说明为什么不返回路径或 inode 号。

## 提交要求

提交真实输出、解释报告和必要 patch。不得固定 `fcount` 绝对值。

## 评分标准

预测-验证 30 分，`fdinfo` 数据流 25 分，负向用例 20 分，报告诚信 25 分。

## 语言风格

报告应使用“对象层次”而非“文件数变了”这种模糊叙述。

## 质量标准

合格答案必须能解释 `proc.ofile[fd]` 与 `struct file` 的关系。

## 边界条件

本任务不涉及路径解析、inode 布局、磁盘块分配或文件内容读取。不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

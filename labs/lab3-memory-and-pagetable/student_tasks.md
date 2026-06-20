# Lab3 学生任务书

## 目标

本任务书要求学生通过预测和验证理解页表映射数量，并能说明 `copyout` 返回结构体的安全边界。

## 适用对象

适用于已跑通 `pgcounttest` 和 `memstattest` 的学生。

## 内容范围

任务包括预测 eager/lazy delta、阅读 `uvmpagecount`、解释 `memstat` 数据流、尝试增加一个结构体字段并分析 ABI。

## 任务结构

T1：运行前写出对 eager 和 lazy delta 的预测。T2：运行 `pgcounttest` 并对照预测。T3：画出 `memstat(struct memstat*)` 从用户指针到 `copyout` 的路径。T4：设计一个扩展字段，说明 padding 和初始化风险。

## 提交要求

提交报告、必要 patch、真实命令输出和预测-验证对照。不要只贴最后 PASS。

## 评分标准

预测-验证 30 分，源码解释 25 分，copyout 数据流 25 分，报告和诚信 20 分。

## 语言风格

报告应使用“实验前预测”“实际输出”“差异解释”的结构。

## 质量标准

合格答案必须说明 `PTE_V`、`PTE_U`、`argaddr` 和 `copyout` 的作用。

## 边界条件

本任务不要求修改 page fault 或 lazy allocation 策略。不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

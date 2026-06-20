# Lab1 Argint Extension 复现审查

## 目标

本文审查 Lab1 从 `hello()` 扩展到 `add2(int,int)` 的设计价值。该扩展让学生第一次处理 syscall 参数读取。

## 适用对象

适用于助教、项目维护者和准备讲解 Lab1 进阶内容的队员。

## 审查范围

`add2` 覆盖 `argint()`、用户态函数声明、stub 生成、syscall 编号和用户测试程序。integrated 路线中 `SYS_add2 = 23`，用户程序为 `add2test`。

## 审查结论

`add2` 是理解参数从用户态进入内核态的最小例子。测试应匹配 `add2(20, 6) returned 26`，并通过代码解释 `argint` 的参数索引和错误返回。该实验不追求复杂算术，而是建立参数传递模型。

## 质量标准

学生应能说明为什么要同时改 `user/user.h`、`user/usys.pl`、`kernel/syscall.h` 和 `kernel/syscall.c`。报告中应包含至少一次破坏-修复观察，例如漏改 stub 或漏改分发表的症状。

## 边界条件

不要把 `add2` 写成通用数学库或复杂参数校验实验。独立 patch 的 syscall 编号与 integrated 编号不同，引用时必须说明上下文。

## 内容范围

本文内容限定在当前标题所对应的项目记录、教学说明、复现步骤或审查结论内。涉及 当前正式验证范围、历史证据、验证命令和证据材料时，应以 `submissions/evidence_manifest.md`、`patches/integrated-labs/README.md` 和相关脚本为准。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 当前正式验证范围。

## 语言风格

使用中文技术写作风格，命令、文件名、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

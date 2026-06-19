# Lab1 Patch 复现审查

## 目标

本文审查 Lab1 最小系统调用 `hello()` 的教学价值、实现路径和复现边界。它是后续所有 syscall 实验的入口。

## 适用对象

适用于助教、项目维护者和需要解释 Lab1 设计的队员。学生应优先阅读 `labs/lab1-system-call/README.md`。

## 审查范围

Lab1 涉及 `kernel/syscall.h`、`kernel/syscall.c`、`kernel/sysproc.c`、`user/user.h`、`user/usys.pl`、`Makefile` 和用户程序。`hello()` 用固定返回值建立用户态到内核态的完整链路。

## 审查结论

`hello()` 的价值在于展示 syscall 七件套，而不在于返回值本身。验证应匹配 `hello syscall returned 2026`。若 stub、编号、分发表或用户程序缺失，失败症状不同，适合课堂做破坏-修复实验。

## 质量标准

Lab1 文档应要求学生说清 `usys.pl` 生成 stub、`ecall` 进入内核、`syscall.c` 分发和 `sys_*` 返回值。报告应包含真实命令和输出，不只写“运行成功”。

## 边界条件

Lab1 不是安全模型或复杂 syscall 教程。独立 patch 不应与其他 independent patch 叠加；综合路线使用 integrated `0001` 和 `0002`。

## 内容范围

本文内容限定在当前标题所对应的项目记录、教学说明、复现步骤或审查结论内。涉及 当前正式验证范围、历史证据、验证命令和证据材料时，应以 `submissions/evidence_manifest.md`、`patches/integrated-labs/README.md` 和相关脚本为准。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 当前正式验证范围。

## 语言风格

使用中文技术写作风格，命令、文件名、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

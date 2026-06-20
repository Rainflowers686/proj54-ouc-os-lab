# Lab3 与 Lab5 完成计划

## 目标

本文记录 Lab3 和 Lab5 从计划到完成的设计边界。当前正式状态已完成，本文件保留用于说明为什么 Lab3 采用观察型页表实验，为什么 Lab5 采用 capstone 复现形式。

## 适用对象

适用于维护者、教师和追溯设计决策的评审。

## Lab3 完成状态

Lab3 通过 `pgcount()` 观察当前进程用户页表中有效且用户可访问的页映射数量，并用 eager/lazy allocation 的 delta 帮助学生理解地址空间大小与实际映射的区别。进阶 `memstat` 通过 `argaddr + copyout + struct ABI` 返回结构体统计，进入 integrated `0008`。

## Lab5 完成状态

Lab5 是 capstone 综合复现实验，组织 clean baseline、integrated `0001-0009`、full verification、证据摘要和实验报告。它不新增内核机制，而是训练学生做可复现工程和证据表达。

## 质量标准

Lab3 文档必须说明 `walk(..., 0)`、`PTE_V`、`PTE_U` 和不分配页的只读观察语义。Lab5 文档必须要求学生记录命令、summary、失败处理和边界说明。

## 边界条件

Lab3 不是完整内存管理，Lab5 不是新内核功能。旧计划中的待办项若与 当前正式验证范围 冲突，以正式文档和 evidence manifest 为准。

## 内容范围

本文内容限定在当前标题所对应的项目记录、教学说明、复现步骤或审查结论内。涉及 当前正式验证范围、历史证据、验证命令和证据材料时，应以 `submissions/evidence_manifest.md`、`patches/integrated-labs/README.md` 和相关脚本为准。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 当前正式验证范围。

## 语言风格

使用中文技术写作风格，命令、文件名、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

# FAQ 与 Issue 记录

## 目标

本文收集项目中反复出现的问题，并给出面向学习和复现的简明答案。详细排障步骤见 `docs/troubleshooting.md`。

## 适用对象

适用于学生、队友复现人员和助教。

## 常见问题

问：为什么不能直接提交 xv6 源码？答：`external/xv6-riscv/` 是第三方上游源码，本仓库只提交本队 patch、脚本、文档和证据索引。

问：为什么 independent patch 不能互相叠加？答：独立实验为了单关教学通常复用 `SYS_* = 22`，组合演示必须使用 integrated `0001-0009`，它统一编号为 22 到 30。

问：为什么测试不固定 `pcount` 或 `fcount` 的具体数字？答：这些值受调度、打开文件和环境状态影响，验收只匹配稳定前缀或由程序内部计算 delta。

问：Lab5 是不是新功能？答：不是。Lab5 是 capstone 综合复现实验，用来组织 clean baseline、integrated patches、验证命令和报告证据。

## 质量标准

FAQ 只回答高频问题。复杂故障应转到 `troubleshooting.md`，证据问题应转到 `submissions/evidence_manifest.md`。

## 边界条件

FAQ 不替代正式报告，不作为 PASS 证据，不记录隐私材料和原始日志。

## 内容范围

本文内容限定在当前标题所对应的项目记录、教学说明、复现步骤或审查结论内。涉及 当前正式验证范围、历史证据、验证命令和证据材料时，应以 `submissions/evidence_manifest.md`、`patches/integrated-labs/README.md` 和相关脚本为准。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 当前正式验证范围。

## 语言风格

使用中文技术写作风格，命令、文件名、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

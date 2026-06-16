# Progress Log

## 目标

本文保留项目开发过程的压缩版记录，用于追溯关键决策、阶段变化和证据边界。它不是 current final 的唯一依据，当前状态应以 `submissions/evidence_manifest.md`、`docs/final/` 和仓库文件为准。

## 适用对象

适合项目维护者、评审追溯人员和后续接手队员。学生学习实验不需要阅读本日志。

## 阶段摘要

项目从 baseline 与 Lab1 最小 syscall 起步，逐步扩展到 `add2` 参数传递、Lab2 进程状态观察、Lab3 页表映射数量观察、Lab4 file/fd 观察和 Lab5 综合复现。后续阶段将 `memstat` 与 `fdinfo` 纳入 integrated `0008` 和 `0009`，补充 `argaddr/argint + copyout + struct ABI` 教学点，并形成 `labctl`、批量 summary 检查、最终 PPT 和提交证据索引。

## 当前结论

current final 为 `db85947 / 0001-0009`，覆盖 syscall 编号 22 到 30。rain、root、z2996 三方 full verification 已登记为 PASS。最终视频与 SHA256 已登记。historical `e8e2fb9 / 0001-0007` 保留为稳定检查点，但不覆盖 `memstat` 和 `fdinfo`。

## 经验记录

开发中确认了三条重要纪律：independent patch 之间不能随意叠加，组合演示必须走 integrated sequence；xv6 `DIRSIZ` 会影响用户程序名，长文件名可能导致 `mkfs` 问题；`/mnt` 路径和 `Ctrl+Z` 会引发 QEMU/timeout 相关故障，应通过 `doctor` 和 `cleanup-qemu` 处理。

## 质量标准

日志保留决策依据，不直接作为最终验收凭证。任何“已完成”表述都应能在正式文档、脚本结果或 evidence manifest 中找到对应证据。

## 边界条件

历史日志中的旧状态不自动代表当前状态。若本文件与 `submissions/evidence_manifest.md` 冲突，以 evidence manifest 和当前仓库脚本为准。

## 内容范围

本文内容限定在当前标题所对应的项目记录、教学说明、复现步骤或审查结论内。涉及 current final、historical checkpoint、验证命令和证据材料时，应以 `submissions/evidence_manifest.md`、`patches/integrated-labs/README.md` 和相关脚本为准。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 current final。

## 语言风格

使用中文技术写作风格，命令、文件名、commit、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

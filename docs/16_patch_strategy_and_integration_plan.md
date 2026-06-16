# Patch 策略与综合集成计划

## 目标

本文说明 independent patch 与 integrated patch 的关系，避免学习、复现和提交时混用两条路线。

## 适用对象

适用于维护 patch、复现项目和讲解课程结构的队员、助教和评审。

## 策略说明

independent patch 服务单 lab 教学，强调最小改动和单点机制。integrated patch sequence 服务最终综合演示，在一个 clean xv6 构建中同时提供全部实验 syscall，并统一编号为 22 到 30。

## 当前 integrated 序列

`0001` 到 `0009` 分别对应 `hello`、`add2`、`pstate`、`pcount`、`fcount`、`pgcount`、`fdcount`、`memstat` 和 `fdinfo`。`memstat` 和 `fdinfo` 是结构体 copyout 观察接口，补充真实内核接口常见的数据返回模式。

## 质量标准

新增或修改 patch 时必须同步更新 `patches/integrated-labs/README.md`、`scripts/xv6/apply-integrated-labs.sh`、`teammate-verify.sh`、`labctl.sh` 测试矩阵和相关文档。`scripts/check-docs-consistency.sh` 必须能检查 patch 列表与文档状态。

## 边界条件

不要把 independent patch 当成可自由叠加的分支。不要在文档中同时承诺不同的 syscall 编号。不要让旧 patch 状态覆盖 current final。

## 内容范围

本文内容限定在当前标题所对应的项目记录、教学说明、复现步骤或审查结论内。涉及 current final、historical checkpoint、验证命令和证据材料时，应以 `submissions/evidence_manifest.md`、`patches/integrated-labs/README.md` 和相关脚本为准。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 current final。

## 语言风格

使用中文技术写作风格，命令、文件名、commit、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

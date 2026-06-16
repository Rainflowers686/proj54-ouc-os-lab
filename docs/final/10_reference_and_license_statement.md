# 10 Reference and License Statement

## 目标

本文说明本项目引用、参考和许可证边界，避免混淆上游 xv6、外部课程资料和本队增量贡献。

## 适用对象

适用于评审、队伍成员、指导教师和后续维护者。

## 上游项目

本项目基于 MIT PDOS `xv6-riscv`，baseline commit 为 `74f84181a3404d1d6a6ff98d342233979066ebb8`。上游源码按其许可证使用，本仓库不提交 `external/xv6-riscv/`。

## 参考资料

MIT 6.1810、xv6-riscv book、uCore、rCore、PKE、YatSen OS、F-Tutorials 和往届 OS 竞赛作品用于定位课程组织、实验表达和提交材料结构。正式引用应核对 URL 和许可证。

## 本队增量

本队增量包括 Lab1-Lab4 独立 patch、integrated `0001-0009`、Lab5 综合复现、验证脚本、`labctl`、教师指南、评分标准、排障手册、正式技术报告、PPT 文稿和证据索引。

## 质量标准

引用材料时应说明用途，不把外部项目内容写成本队原创。若最终提交平台要求更严格的引用格式，应以平台规范补充。

## 边界条件

不复制外部项目代码、图片、PPT 或大段文本。不用未经核对的许可证判断作为正式声明。

## 内容范围

本文内容限定在当前标题所对应的项目记录、教学说明、复现步骤或审查结论内。涉及 current final、historical checkpoint、验证命令和证据材料时，应以 `submissions/evidence_manifest.md`、`patches/integrated-labs/README.md` 和相关脚本为准。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 current final。

## 语言风格

使用中文技术写作风格，命令、文件名、commit、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

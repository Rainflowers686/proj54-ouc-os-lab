# Reference and License Record

## 目标

本文说明项目参考来源、许可证边界和本队增量贡献。正式提交时应与 `docs/final/10_reference_and_license_statement.md` 保持一致。

## 适用对象

适用于评审、队伍成员、指导教师和后续维护者。

## 上游来源

本项目基于 MIT PDOS 的 `xv6-riscv`，baseline 版本由 `scripts/xv6/apply-integrated-labs.sh` 和 `external/xv6-baseline-record.md` 记录。上游源码放在本地 `external/xv6-riscv/`，不提交到本仓库。

## 参考范围

MIT 6.1810、xv6-riscv book、uCore、rCore、PKE、YatSen OS、F-Tutorials 和往届 OS 竞赛材料只作为课程组织、教学表达和提交材料结构参考。未核对许可证前，不复制其代码、图片、PPT 或大段文本。

## 本队增量

本队贡献包括 Lab1-Lab4 独立 patch、integrated `0001-0009`、Lab5 综合复现、`labctl` 与 xv6 验证脚本、教师/学生文档、评分标准、排障手册、正式技术报告和证据索引。

## 质量标准

引用外部项目时应写清名称、用途和边界。涉及许可证的正式材料应避免模糊归属，不把上游源码写成本队原创。

## 边界条件

不提交第三方源码，不复制外部项目实质内容，不用 AI 生成无法核验的引用信息。

## 内容范围

本文内容限定在当前标题所对应的项目记录、教学说明、复现步骤或审查结论内。涉及 当前正式验证范围、历史证据、验证命令和证据材料时，应以 `submissions/evidence_manifest.md`、`patches/integrated-labs/README.md` 和相关脚本为准。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 当前正式验证范围。

## 语言风格

使用中文技术写作风格，命令、文件名、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

# 项目代码图快照

## 目标

本文记录本次文档重写前通过 graphify 和 code-review-graph 获取的项目结构快照，帮助后续维护者理解文档与脚本的关系。

## 适用对象

适用于项目维护者、文档维护者和需要快速理解仓库结构的队员。

## 图谱结论

code-review-graph 显示当前代码图约 72 个节点、1511 条边，主要社区为 `xv6-cleanup`、`scripts-status` 和 `scripts-usage`。关键执行流集中在 `scripts/xv6/teammate-verify.sh`、`boot-xv6.sh`、`run-xv6-command.sh` 和清理脚本。graphify 既有图中与文档维护直接相关的节点包括项目计划和本快照文档。

## 对文档的影响

文档应围绕复现链路组织：先说明如何获得 clean baseline，再说明如何应用 integrated patches，再说明如何 boot、运行用户程序、收集 summary 和核验证据。脚本社区是项目可复现性的核心，正式文档必须与脚本状态同步。

## 质量标准

后续进行结构性修改时，应重新查询 code-review-graph 和 graphify，确认文档没有偏离实际脚本和 patch 结构。

## 边界条件

图谱快照是辅助理解，不是验证结果。项目是否通过仍以真实脚本运行和 evidence manifest 为准。

## 内容范围

本文内容限定在当前标题所对应的项目记录、教学说明、复现步骤或审查结论内。涉及 当前正式验证范围、历史证据、验证命令和证据材料时，应以 `submissions/evidence_manifest.md`、`patches/integrated-labs/README.md` 和相关脚本为准。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 当前正式验证范围。

## 语言风格

使用中文技术写作风格，命令、文件名、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

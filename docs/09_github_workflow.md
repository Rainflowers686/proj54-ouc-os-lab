# GitHub 协作工作流

## 目标

本文规定项目的 Git 使用、提交边界和协作流程，使 patch、脚本、文档和证据索引能被稳定复现与审查。

## 适用对象

适用于队伍成员、助教维护者和后续接手人员。

## 工作范围

Git 仓库保存本队增量：`labs/`、`patches/`、`scripts/`、`docs/`、`submissions/`、`slides/` 和必要的元数据。`external/xv6-riscv/`、raw logs、summary 原件、视频、截图、隐私材料和本地编辑器配置不进入 Git。

## 提交流程

提交前应运行 `git status --short`、`git diff --check`、`bash scripts/check-docs-consistency.sh` 和 `bash scripts/check-final-hygiene.sh`。涉及证据材料时还应检查 `submissions/evidence_manifest.md` 是否与外部文件和 SHA256 一致。

## 分支与审查

功能变化应按 lab、脚本或文档类别拆分提交。修改 integrated patch 时必须同步更新 README、验证脚本、labctl 矩阵、测试报告和 evidence 边界。文档改动应避免把历史状态改写成当前事实。

## 质量标准

每次提交应能回答三件事：改了什么，如何验证，是否影响提交证据。提交信息应具体，不使用“update docs”这类无法追溯的描述。

## 边界条件

不要用 Git 强制回退他人工作；不要提交生成日志和大文件；不要把外部证据资产包放进仓库。

## 内容范围

本文内容限定在当前标题所对应的项目记录、教学说明、复现步骤或审查结论内。涉及 current final、historical checkpoint、验证命令和证据材料时，应以 `submissions/evidence_manifest.md`、`patches/integrated-labs/README.md` 和相关脚本为准。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 current final。

## 语言风格

使用中文技术写作风格，命令、文件名、commit、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

# Slides Directory

## 目标

本目录保存最终答辩 PPT 的 Markdown 源稿、结构大纲、生成脚本和 PPTX 产物，保证展示材料可追溯。

## 适用对象

适用于答辩准备人员、队长、指导教师和评审材料维护者。

## 内容范围

`final_ppt_outline.md` 是结构索引，`final_ppt.md` 是正文源稿，`generate_final_ppt.ps1` 是 PowerPoint COM 生成器，`final_defense_ppt.pptx` 是生成产物。PPTX 不保存 raw evidence。

## 结构规范

PPT 文档应围绕项目定位、实验体系、复现证据、教学价值和边界条件展开。每页应有一个明确任务。

## 语言风格

答辩文案应短句、证据导向、避免堆砌口号。所有数字和证据应能回到 evidence manifest。

## 质量标准

PPTX 生成后应检查页数、speaker notes、媒体嵌入和人工排练状态。

## 边界条件

不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

# Slides

本目录存放最终答辩展示材料。PPT 内容必须能追溯到 Markdown 源稿，不能只在 PowerPoint 里无记录手改。

## Final Defense PPT

| 文件 | 状态 | 说明 |
| --- | --- | --- |
| `slides/final_ppt_outline.md` | 已重写 | stage16-redesign-with-ppt-skill 最终 16 页答辩结构，与 PPT 源稿一致 |
| `slides/final_ppt.md` | 已重写 | stage16-redesign-with-ppt-skill 最终 PPT 文案源，每页包含标题、核心信息、bullet、可见图示标签和讲稿备注 |
| `slides/generate_final_ppt.ps1` | 已重写 | 使用 PowerPoint COM 从 Markdown 源稿生成 PPTX；生成 PowerPoint 原生形状、流程图、矩阵和证据卡 |
| `slides/final_defense_ppt.pptx` | 生成产物 | 16:9 答辩 PPTX；由上面两个源文件生成；不嵌入视频、截图、原始 summary 或 raw logs |

生成命令：

```bash
powershell -ExecutionPolicy Bypass -File slides/generate_final_ppt.ps1
```

生成器需要 Windows PowerPoint COM。stage16-redesign-with-ppt-skill 选择该方式，是因为 PowerPoint 对最终 PPTX 的打开结果是硬性验收项。

## Skill Usage Record

本轮重做前读取了以下 PPT / slides / PowerPoint skill 文档，并按其规则执行：

| skill 文档 | 采用规则 |
| --- | --- |
| `C:\Users\Rain\.codex\plugins\cache\openai-primary-runtime\presentations\26.601.10930\skills\presentations\SKILL.md` | 先建立叙事主线、设计系统和 proof objects，再生成 PPTX；生成后必须预览和 QA |
| `C:\Users\Rain\.codex\plugins\cache\openai-primary-runtime\presentations\26.601.10930\skills\presentations\profiles\engineering-platform.md` | 工程类答辩必须使用架构图、流程图、证据图等具体 proof objects，避免泛泛口号 |
| `C:\Users\Rain\.codex\skills\academic-pptx-skill\SKILL.md` | 答辩类材料优先保证论证结构、证据和可读性 |
| `C:\Users\Rain\.codex\skills\academic-pptx-skill\content_guidelines.md` | 每页一个任务，标题和图示共同支撑主论点 |
| `C:\Users\Rain\.codex\skills\pptx\SKILL.md` | PPTX 需要内容 QA、视觉 QA、PowerPoint 打开检查和媒体嵌入检查 |
| `C:\Users\Rain\.codex\skills\pptx\pptxgenjs.md` | 采用 16:9、统一网格、字号层级、形状/线条/矩阵/流程图等原生展示元素 |
| `C:\Users\Rain\.codex\skills\ppt-visual\SKILL.md` | 使用流程、矩阵、对比、时间线和证据卡减少文字堆叠 |

## Sync Policy

- `slides/final_ppt.md` 是 PPT 文案源。
- `slides/final_ppt_outline.md` 是答辩结构索引，必须和源稿页数、标题、事实一致。
- `slides/final_defense_ppt.pptx` 可以提交，但它不是 raw verification evidence。
- 若后续使用 PowerPoint 人工精修，必须同步回 `slides/final_ppt.md` 或在提交记录中说明差异。

## Compliance Boundary

- PPTX 不嵌入外部视频、截图、队友原始 evidence、token、密码或隐私材料。
- final video 只在 `submissions/demo_record.md` 和 `submissions/evidence_manifest.md` 中记录文件名、大小、时长、分辨率、帧率、外部位置和 SHA256。
- 视频、截图、raw logs、summary 原件和网盘资产不进入 Git。
- `caf8ced` 是 evidence documentation commit；`db85947` 才是 final engineering commit。

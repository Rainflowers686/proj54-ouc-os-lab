# Slides

本目录存放答辩展示材料。PPT 内容必须可追踪到 Markdown 源稿，不能只在 PowerPoint 中无记录手改。

## Final Defense PPT

| 文件 | 状态 | 说明 |
| --- | --- | --- |
| `slides/final_ppt_outline.md` | 已完成 | stage10b 答辩大纲，保留为结构草案 |
| `slides/final_ppt.md` | 已完成 | stage10c 正式 PPT 源稿，16 页，每页包含标题、核心信息、bullet、视觉建议和讲稿备注 |
| `slides/generate_final_ppt.py` | 已完成 | 使用 Python 标准库从 `slides/final_ppt.md` 生成 PPTX，不嵌入图片、视频、截图或 raw logs |
| `slides/final_defense_ppt.pptx` | 已生成 | 当前答辩 PPTX 成稿；16:9；含 16 张 slide 和 16 份 speaker notes；无 `ppt/media/` 文件 |

生成命令：

```bash
python slides/generate_final_ppt.py
```

在 Codex desktop 环境中使用 bundled Python 生成过一次；普通环境使用系统 Python 3 也应可运行，因为生成器只依赖标准库。

## Compliance Boundary

- PPTX 可以作为提交材料，但仍需人工最终审阅和排练。
- PPTX 不嵌入视频、截图、队友原始 evidence、token、密码或隐私材料。
- final video 只在 `submissions/demo_record.md` 和 `submissions/evidence_manifest.md` 中记录元数据与 SHA256；视频本体不进入 Git。
- 如果后续用 PowerPoint 精修，必须先同步回 `slides/final_ppt.md` 或在提交记录中说明改动，不要产生不可追踪内容。

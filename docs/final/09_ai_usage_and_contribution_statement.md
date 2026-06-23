# 09 AI Usage and Contribution Statement

## 使用原则

AI 工具用于规划、拆解、审查、文档整理和脚本辅助，不替代真实 make/QEMU/boot/命令验证。所有 PASS、日志、commit、视频和队友复现结果必须来自真实执行或真实反馈。

## 工具分工记录

| 工具 | 使用方式 |
| --- | --- |
| GPT-5.5 Thinking Advanced | 全流程问答辅助、任务拆分、红队判断、提示词生成、验收标准和调度 |
| Claude Desktop / Opus 4.8 Max | 困难任务、大方向规划、红队审核 |
| Codex | 中等难度工程落地、文档整理、PPT 生成 |
| VSCode 侧边栏 + CCswitch DeepSeek v4pro 1M | 简单施工，在明确指导下完成低风险任务 |

以上为团队使用声明。若某一项具体实验结果没有真实命令或真实队友反馈支撑，不能因为 AI 生成过相关文字就写成已完成。

## 人类贡献

- 赛题方向选择、OUC 本校课程定位和提交策略。
- 决定实验范围和不做事项。
- 审核 AI 产出是否符合真实仓库内容。
- 执行或确认真实 WSL2 make/QEMU 验证。
- 最终提交材料、视频和队友反馈的人工复核。

## AI 辅助贡献

- 生成和整理 README、`docs/final/`、提交 checklist、报告索引。
- 辅助编写 shell 脚本的 timeout、cleanup、summary 逻辑。
- 辅助识别“不能夸大”的边界：timeout、fcount、队友复现、视频、外部源码。
- 辅助把旧过程文档整理为评委友好的正式入口。
- 辅助生成 `slides/final_ppt.md` 和 `slides/final_defense_ppt.pptx`；PPT 仍需人工最终审阅。

## 禁止行为

- 不用 AI 伪造日志。
- 不用 AI 伪造 PASS。
- 不用 AI 伪造队友复现。
- 不用 AI 生成未执行命令的“真实结果”。
- 不提交 AI 本地目录（如 `.claude/`）或包含敏感信息的上下文。

## 证据链

AI 使用过程记录在：

```text
docs/05_ai_usage_record.md
docs/06_progress_log.md
```

真实测试摘要记录在：

```text
docs/04_test_report.md
docs/final/06_testing_and_verification.md
```

原始日志在 ignored 的 `logs/` 下，不作为 Git 提交物。

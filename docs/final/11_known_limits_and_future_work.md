# 11 Known Limits and Future Work

## 已知限制

| 项目 | 当前状态 | 说明 |
| --- | --- | --- |
| lab3 memory/pagetable | integrated 已完成 | `pgcount()` 页表映射数量观察已进入 integrated `0006`；不是完整内存管理实验 |
| lab4 file system | v0.2 已完成 | `fcount()` file table 与 `fdcount()` fd table 观察；不是完整文件系统实验 |
| lab5 capstone | 已完成文档闭环 | 综合复现实验；不新增内核机制 |
| 长期稳定性测试 | 未完成 | 当前为 timeout 自动捕获 evidence |
| 队友独立复现 | 新 HEAD 待重跑 | 旧 2 份 full PASS summary 锚定 commit `1ba9db6`；不覆盖 stage9c integrated `0001-0007` |
| 视频提交信息 | 部分补充 | 已录制 3 段，文件名/外部位置/约略大小已记录；时长/平台提交方式待补充 |
| 同类项目引用 URL | 待补充 | uCore/rCore/YatSen OS/F-Tutorials 等需最终核对 |
| 技术报告 v1.0 | 待制作 | 可基于 `docs/final/` 整理 |
| PPT | 待制作 | 可基于 README、overview、testing、tradeoffs 整理 |

## 不能夸大的内容

- `fcount()` / `fdcount()` 不能写成完整文件系统实验。
- `pcount(RUNNING)` 不能写成固定数值。
- `pchildtest` 不能写成固定状态。
- `pgcount()` 不能写成完整内存管理实验；只能写页表映射数量观察。
- Lab5 不能写成新的内核机制；它是综合复现和报告实验。
- timeout evidence 不能写成长期稳定性测试。
- 队长本机 PASS 不能写成队友独立复现；旧队友 PASS 只能按旧 commit `1ba9db6` 的 summary/截图摘要记录。
- 已录制视频不能自动等同于已完成平台提交；还需补充时长和提交方式。

## 后续可扩展实验

### lab1 扩展

- 指针参数：`argaddr()`。
- 字符串参数：`argstr()`。
- 错误输入与返回值约定。
- 学生骨架版和评分 rubric。

### lab2 扩展

- ps-like summary。
- 更明确的进程生命周期观察。
- scheduler trace，但不轻易修改调度策略。
- wait/exit 状态观察。

### lab3 后续计划

- 补一篇正式 Lab3 final 文档和技术报告章节。
- 重新收集 stage9c 新 HEAD 的 teammate `--full` summary。
- 设计学生骨架版和扩展问题。
- 必须先设计安全的最小实验，不应临时堆功能。

### lab4 扩展

- per-process fd table 观察。
- inode 引用观察。
- open file summary。
- 文件系统布局讲解。

## 提交前必须补齐

1. 队友真实姓名、系统版本和队友 B 精确 summary 文件名冲突（如最终材料需要）。
2. 三段视频的时长、内容确认和平台提交方式。
3. 技术报告 v1.0。
4. PPT。
5. 参考来源 URL 和许可证核对。
6. 最终 Git 卫生检查。

## 建议下一轮工作

- `stage8c`: 根据 `docs/final/` 和 stage8b 证据生成技术报告 v1.0。
- `stage8d`: 生成 PPT 大纲和讲稿。
- `stage8e`: 最终提交前红队审核。

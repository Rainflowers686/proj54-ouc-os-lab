# 11 Known Limits and Future Work

## 已知限制

| 项目 | 当前状态 | 说明 |
| --- | --- | --- |
| lab3 memory/pagetable | integrated 已完成 | `pgcount()` 页表映射数量观察已进入 integrated `0006`；不是完整内存管理实验 |
| lab4 file system | v0.2 已完成 | `fcount()` file table 与 `fdcount()` fd table 观察；不是完整文件系统实验 |
| lab5 capstone | 已完成文档闭环 | 综合复现实验；不新增内核机制 |
| 长期稳定性测试 | 未完成 | 当前为 timeout 自动捕获 evidence |
| 队友独立复现 | final full PASS 已记录 | root 与 z2996 两份 `e8e2fb9` / integrated `0001-0007` full PASS 已记录；旧 `1ba9db6` 只作 historical evidence |
| 视频提交信息 | final metadata 已记录 | final integrated `0001-0007` 视频已记录大小、时长、SHA256；平台提交方式和最终隐私复核待确认 |
| 同类项目引用 URL | 待补充 | uCore/rCore/YatSen OS/F-Tutorials 等需最终核对 |
| 技术报告 v1.0 | 草案已完成 | `docs/final/technical_report_v1.0.md` |
| PPT | 大纲已完成，成稿待制作 | `slides/final_ppt_outline.md` 已给出 15 页结构 |

## 不能夸大的内容

- `fcount()` / `fdcount()` 不能写成完整文件系统实验。
- `pcount(RUNNING)` 不能写成固定数值。
- `pchildtest` 不能写成固定状态。
- `pgcount()` 不能写成完整内存管理实验；只能写页表映射数量观察。
- Lab5 不能写成新的内核机制；它是综合复现和报告实验。
- timeout evidence 不能写成长期稳定性测试。
- 队长本机 PASS 不能写成队友独立复现；final 证据中 lead/root/z2996 必须分开记录。
- 旧队友 PASS 只能按旧 commit `1ba9db6` 的 summary/截图摘要记录，不能覆盖 final commit `e8e2fb9`。
- 已录制视频不能自动等同于已完成平台提交；还需确认平台提交方式和最终隐私复核。

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

- 在技术报告 v1.0 中补充 Lab3 final 章节。
- 设计学生骨架版和扩展问题。
- 必须先设计安全的最小实验，不应临时堆功能。

### lab4 扩展

- per-process fd table 观察。
- inode 引用观察。
- open file summary。
- 文件系统布局讲解。

## 提交前必须补齐

1. 队友真实姓名、系统版本（如最终材料需要）。
2. 视频/截图最终隐私复核和平台提交方式。
3. PPT 成稿。
4. 技术报告 v1.0 最终人工校对。
5. 参考来源 URL 和许可证核对。
6. 最终 Git 卫生检查。

## 建议下一轮工作

- 根据 `slides/final_ppt_outline.md` 制作 PPT 成稿。
- 对 `docs/final/technical_report_v1.0.md` 做最终人工校对。
- 最终提交前红队审核。

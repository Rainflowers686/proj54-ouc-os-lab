# 11 Known Limits and Future Work

## 已知限制

| 项目 | 当前状态 | 说明 |
| --- | --- | --- |
| lab3 memory/pagetable | 未完成 | 目前不声称实现内存/页表实验 |
| lab4 file system | 部分完成 | 仅做文件表引用计数观察，不是完整文件系统实验 |
| 长期稳定性测试 | 未完成 | 当前为 timeout 自动捕获 evidence |
| 队友独立复现 | 待补充 | 等待队友 summary，不伪造 |
| 视频提交信息 | 待补充 | 已录制 3 段，文件名/时长/平台提交方式待记录 |
| 同类项目引用 URL | 待补充 | uCore/rCore/YatSen OS/F-Tutorials 等需最终核对 |
| 技术报告 v1.0 | 待制作 | 可基于 `docs/final/` 整理 |
| PPT | 待制作 | 可基于 README、overview、testing、tradeoffs 整理 |

## 不能夸大的内容

- `fcount()` 不能写成完整文件系统实验。
- `pcount(RUNNING)` 不能写成固定数值。
- `pchildtest` 不能写成固定状态。
- timeout evidence 不能写成长期稳定性测试。
- 队长本机 PASS 不能写成队友独立复现。
- 已录制视频不能自动等同于已完成平台提交；还需补充文件名和提交方式。

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

### lab3 计划

- 页表 walk 观察。
- 用户虚拟地址到物理地址映射解释。
- 简单 page fault / copyin 路径教学。
- 必须先设计安全的最小实验，不应临时堆功能。

### lab4 扩展

- per-process fd table 观察。
- inode 引用观察。
- open file summary。
- 文件系统布局讲解。

## 提交前必须补齐

1. 队友 `teammate-verify.sh --full` summary。
2. 三段视频的文件名、时长、内容和平台提交方式。
3. 技术报告 v1.0。
4. PPT。
5. 参考来源 URL 和许可证核对。
6. 最终 Git 卫生检查。

## 建议下一轮工作

- `stage8b`: 根据 `docs/final/` 生成技术报告 v1.0。
- `stage8c`: 生成 PPT 大纲和讲稿。
- `stage8d`: 补充队友 summary 与视频记录。
- `stage8e`: 最终提交前红队审核。

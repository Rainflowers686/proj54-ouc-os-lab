# 11 Known Limits and Future Work

## 已知限制

| 项目 | 当前状态 | 说明 |
| --- | --- | --- |
| lab3 memory/pagetable | integrated 已完成 | `pgcount()` 页表映射数量观察已进入 integrated `0006`；不是完整内存管理实验 |
| lab4 file system | v0.2 已完成 | `fcount()` file table 与 `fdcount()` fd table 观察；不是完整文件系统实验 |
| lab5 capstone | 已完成文档闭环 | 综合复现实验；不新增内核机制 |
| advanced optional patches（stage11b 已进 integrated） | integrated 已完成（队长本机），队友复现 TBD | `memstat`(独立 lab3 `0002`，也作 integrated `0008`，`SYS_memstat = 29`) 与 `fdinfo`(独立 lab4 `0002`，也作 integrated `0009`，`SYS_fdinfo = 30`) 教 `argaddr/argint + copyout + struct ABI`；stage11b 已进入 integrated 主线，final suite 扩展为 `0001-0009`，队长本机 `local-verify --full` overall PASS（含 memstattest/fdinfotest）。旧 `e8e2fb9 / 0001-0007` 三方 PASS 只覆盖 `0001-0007`（historical）；`0001-0009` 队友 full verify 为 **TBD** |
| 长期稳定性测试 | 未完成 | 当前为 timeout 自动捕获 evidence |
| 队友独立复现 | `0001-0007` historical PASS 已记录；`0001-0009` TBD | root 与 z2996 两份 `e8e2fb9` / integrated `0001-0007` full PASS 已记录，降级为 historical stable checkpoint，只覆盖 `0001-0007`；旧 `1ba9db6` 只作 historical evidence；含 memstat/fdinfo 的 `0001-0009` 队友 full verify 尚未进行，为 TBD，不得伪造 |
| 视频提交信息 | `0001-0007` historical 已记录；`0001-0009` TBD | `0001-0007` 视频已记录大小、时长、SHA256，降级为 historical stable checkpoint，只覆盖 `0001-0007`；覆盖 `0001-0009`（含 memstat/fdinfo）的新视频和新 SHA256 尚未录制，为 TBD；平台提交方式和最终隐私复核待确认 |
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
- 旧队友 PASS 只能按旧 commit `1ba9db6` 的 summary/截图摘要记录，不能覆盖 `e8e2fb9`（historical stable checkpoint）。
- 已录制视频不能自动等同于已完成平台提交；还需确认平台提交方式和最终隐私复核。
- `memstat` / `fdinfo` 现有 independent 版（`SYS_*=22`）和 integrated 版（`0008`=`SYS_memstat 29` / `0009`=`SYS_fdinfo 30`）两条线；stage11b 已把它们加入 integrated 主线（final suite `0001-0009`），但只在队长本机 `local-verify --full` 验证，**不能**写成已被 rain/root/z2996 队友验证，也**不能**写成旧 `e8e2fb9` 三方 full PASS 已覆盖 `0001-0009`——旧三方 PASS 只覆盖 `0001-0007`，`0001-0009` 队友复现为 TBD。
- `memstat` 仍是地址空间观察、不是完整内存管理；`fdinfo` 仍是 fd 元数据观察、不是完整文件系统；二者都不返回物理地址、宿主路径、inode 号或文件内容。

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

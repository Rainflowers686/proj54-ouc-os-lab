# 08 Design Decisions and Tradeoffs

## 总体取舍

本项目选择“课程实验包 + 可复现验证体系”而不是“堆内核功能”。原因是 proj54 的重点在教学与实验体系建设，最终材料需要同时经得起源码执行展示、设计方案文档、答辩过程记录和演示视频检查。

取舍不是缺陷掩盖。本项目把边界写清楚，是为了让学生、助教和评委知道哪些结论有证据支撑。

## 为什么选择 xv6-riscv

- 代码规模小，适合低年级同学阅读。
- syscall、进程、文件表等概念边界清晰。
- 适合通过 patch 展示从用户程序到内核实现的完整路径。
- 可以用 QEMU 自动验证输出，便于队友复现。

## 为什么用 patch 而不是提交 external 源码

`external/xv6-riscv/` 是第三方源码，不入库。项目自有贡献以 patch、文档、脚本和测试记录体现：

- 减少仓库体积。
- 避免第三方源码许可证边界混乱。
- 评委可以从 clean baseline 复现每个改动。
- 保留 independent patch 与 integrated patch 两条路线。

## independent patch 与 integrated patch

| 路线 | 用途 | 说明 |
| --- | --- | --- |
| independent lab patch | 单 lab 教学 | lab1/lab2/lab4 可单独讲解 |
| integrated-labs | 综合演示 | 统一 syscall number，避免独立 patch 直接叠加冲突 |

lab2 independent patch 使用 `SYS_pstate=22`，不能直接叠加 lab1。integrated patch 中重新规划为 `hello=22/add2=23/pstate=24/pcount=25/fcount=26`。

## 为什么暂不做 lab3

lab3 内存/页表实验价值高，但需要更长时间设计可解释、可验证且不误导学生的实验。当前阶段先把 lab0/lab1/lab2/lab4、文档体系、验证体系做扎实，避免为了“看起来功能多”而引入未验证内容。

## 为什么 lab4 只做 fcount

`fcount()` 能把用户态 fd、内核 `struct file`、全局 file table、引用计数和锁串起来，适合作为文件系统方向的入门观察实验。

它不覆盖：

- inode 结构。
- 文件系统布局。
- 路径解析。
- per-process fd table。
- 完整文件系统功能。

因此文档中始终称为“文件表观察”，不称为完整文件系统实验。

## 为什么强调 timeout 和 cleanup

队友真实复现时曾遇到 QEMU 等待过久、误按 `Ctrl+Z`、不知道哪步已成功的问题。为降低复现门槛，脚本增加：

- soft timeout。
- hard timeout。
- retry。
- trap cleanup。
- `cleanup-qemu.sh`。
- copy-to-lead summary。

这属于复现体验创新，不等于长期稳定性测试。

## 同类项目参考取舍

| 参考对象 | 借鉴方向 | 本项目取舍 |
| --- | --- | --- |
| uCore | 分阶段教学组织 | 不复制其代码或完整课程体系 |
| rCore | 文档化、实验章节化 | 不引入 Rust 技术栈 |
| YatSen OS / F-Tutorials | 竞赛材料展示与 tutorial 组织 | 具体 URL/许可证待补充，当前只作为对比方向 |
| xv6-riscv | 教学 OS baseline | 只在本地 ignored 目录保留源码，提交 patch 和文档 |

## 风险控制

- 所有 PASS 必须来自真实命令。
- 未完成项写待补充。
- 不上传视频、大文件、隐私材料。
- 不修改 remote。
- integrated `0001-0007` 必须从 clean baseline 真实应用和验证；后续若再改 patch sequence，需要重新收集 teammate full。

# 延伸参考资料

这页是我们做这个项目时翻过、或者觉得后来的同学会用得上的资料，按"什么时候需要"分了四层。README 首页只放了最常用的几个，完整的都在这里。

两条约定先说清楚：

- 每条都标了"是否直接用于本项目"。外部资料用于理解课程组织和背景，绝大多数只是参考思路，**不是本项目的实现来源**——我们的内核增量只来自自己写的 patch（见 `patches/`），第三方源码只有 xv6-riscv baseline 本身，且不入库。
- 标了"未核对"的，是我们收集时没逐页验证的内容（个人博客、个人镜像站），看的时候自己留个心眼，以官方版本为准。

## 1. 赛题与提交要求

| 资料 | 用途 | 什么时候看 | 是否用于本项目 |
| --- | --- | --- | --- |
| [proj0：面向 OS 课程的竞赛和实验（赛题原文）](https://github.com/oscomp/proj0-contest-and-lab-for-os-course?tab=readme-ov-file#%E6%B3%A8%E6%84%8F%E4%BA%8B%E9%A1%B9-1) | 本项目对应的赛题说明和注意事项，proj54 就属于这一类 | 想知道"这个项目为什么长这样"之前；写报告对照评审要求时 | 是——赛题定位的直接依据 |
| [OS 功能挑战赛主页](https://os.educg.net/#/index?TYPE=26OS_F) | 比赛官方入口：赛程、提交方式、平台公告 | 提交前确认平台要求；查赛程节点 | 是——提交流程依据 |
| [oscomp 比赛参考信息 ref-info](https://github.com/oscomp/os-competition-info/blob/main/ref-info.md) | 官方整理的参考资料汇总（文档、往届、工具链都有） | 想找更多资料时先来这里，比盲搜强 | 否——只作索引 |

## 2. xv6 入门（与本项目直接相关）

| 资料 | 用途 | 什么时候看 | 是否用于本项目 |
| --- | --- | --- | --- |
| [MIT 6.1810 课程主页（原 6.S081）](https://pdos.csail.mit.edu/6.1810/2025/) | xv6 的"娘家"课程，讲义、lab、调度安排都在这 | 做完本项目 Lab1-Lab2、想系统学一遍时 | 否——教学参考 |
| [xv6 介绍页（含 xv6 book 入口）](https://pdos.csail.mit.edu/6.1810/2023/xv6.html) | 官方对 xv6 的定位说明和教材链接 | 第一次想知道"xv6 是什么、为什么适合教学" | 否——背景阅读 |
| [mit-pdos/xv6-riscv 源码](https://github.com/mit-pdos/xv6-riscv) | 本项目的 baseline（pin 在 commit `74f84181`，见 `external/README.md`） | 任何时候想读原始内核源码 | **是——唯一的第三方源码基线，不入库** |
| [xv6-riscv-book-CN（中文翻译）](https://github.com/shzhxh/xv6-riscv-book-CN) | xv6 教材的中文翻译 | 英文版读着费劲时；建议对着英文原版交叉看 | 否——阅读辅助 |
| [一篇 6.S081 入门博客（CSDN）](https://blog.csdn.net/2301_79981746/article/details/147405720) | 同学视角的入门记录 | 配环境或做 lab 卡住、想看别人怎么过的 | 否——同学经验，**非官方依据，未逐字核对** |
| [6.S081 lab0 配环境记录（acmicpc.top）](https://acmicpc.top/2024/02/08/MIT-6.S081-lab0-%E9%85%8D%E7%8E%AF%E5%A2%83/) | 环境搭建踩坑记录 | 我们的 `docs/troubleshooting.md` 没覆盖到你的问题时 | 否——同学经验，非官方依据 |
| [xv6-labs-6s081 镜像（Gitee）](https://gitee.com/lgflare/xv6-labs-6s081) | 6.S081 lab 仓库的国内镜像 | GitHub 访问不畅时拉课程 lab 用 | 否——镜像，注意与上游版本差异 |

## 3. 更完整的 OS 课程体系参考

这一层是"做完本项目之后往哪走"。本项目刻意停在观察型入门实验，下面这些是完整得多的课程生态。

| 资料 | 用途 | 什么时候看 | 是否用于本项目 |
| --- | --- | --- | --- |
| [rCore-Tutorial-Book v3](https://rcore-os.github.io/rCore-Tutorial-Book-v3/) | 用 Rust 从零写 RISC-V 内核的成体系教程 | 想从"观察 OS"进阶到"从零写 OS"时 | 否——课程组织参考，不复制内容 |
| [LearningOS rCore-Tutorial-Guide 2025S](https://github.com/LearningOS/rCore-Tutorial-Guide-2025S) | rCore 开源课程当季实验指导 | 想跟一个有作业、有验收的完整课程时 | 否——参考 |
| [LearningOS uCore-Tutorial-Guide 2025S](https://github.com/LearningOS/uCore-Tutorial-Guide-2025S) | uCore（C 语言路线）当季实验指导 | 偏好继续用 C 深入时 | 否——参考 |
| [南开 uCore OS on RISC-V64 讲义](https://nankai.gitbook.io/ucore-os-on-risc-v64/) | uCore 在 RISC-V64 上的课程讲义 | 对照另一种课程组织方式时 | 否——参考 |
| [PKE：基于 RISC-V 代理内核的 OS 课程实验（华科）](https://gitee.com/hustos/pke-doc) | "代理内核"思路的轻量实验设计，每个实验都很小 | 想看"小步实验怎么设计"——和我们的 patch 分关思路最接近 | 否——实验设计思路参考 |
| [hm1229.top 的 OS 教程站](http://hm1229.top/book/index.html) | 个人整理的 rCore 系教程站（搜索引擎未收录，我们没逐页核对） | 作为 rCore 学习的补充材料随手翻 | 否——**个人站，未核对，以 rCore 官方文档为准** |

## 4. 往届作品与文档形态参考

这一层我们主要学的是**文档怎么组织、报告怎么写、证据怎么摆**，不是抄实现。三条都不作为本项目实现来源。

| 资料 | 用途 | 什么时候看 | 是否用于本项目 |
| --- | --- | --- | --- |
| [2021 OS 比赛优秀内核设计合集](https://github.com/oscomp/2021oscomp-best-kernel-design-impl) | 往届获奖项目代码与文档合集 | 写技术报告前看看别人的深度和结构 | 否——只学文档形态 |
| [《一个支点撬动操作系统大山》项目文档 PDF（2021 功能赛，中山大学团队）](https://gitlab.eduxiji.net/os-contest-2021-functional-final/NelsonCheung-project325618-87937/-/blob/master/%E4%B8%80%E4%B8%AA%E6%94%AF%E7%82%B9%E6%92%AC%E5%8A%A8%E6%93%8D%E4%BD%9C%E7%B3%BB%E7%BB%9F%E5%A4%A7%E5%B1%B1.pdf) | 往届功能赛高分项目的完整文档（教学型项目怎么讲故事） | 定稿技术报告/答辩材料前 | 否——文档组织参考（eduxiji 链接可能需要登录） |
| [往届项目文档 PDF（project788067）](https://gitlab.eduxiji.net/15130163373/project788067-123278/-/blob/master/%E9%A1%B9%E7%9B%AE%E6%96%87%E6%A1%A3.pdf) | 另一份往届项目文档样例 | 同上，多一个对照样本 | 否——文档组织参考（可能需要登录） |

## 许可证与引用边界

- 引用任何第三方代码、图片、课件前，先核对许可证；本仓库目前唯一引入的第三方代码是 xv6-riscv（MIT License），见 `docs/final/10_reference_and_license_statement.md`。
- 上面资料的正式引用状态（URL/license 核验）以 `docs/final/10_reference_and_license_statement.md` 为准；这页只是阅读导航，不是引用声明。
- 不复制大段外部内容进仓库。

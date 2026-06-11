# Final Defense PPT Outline

> stage16-redesign-with-ppt-skill outline. This file matches `slides/final_ppt.md` and the regenerated `slides/final_defense_ppt.pptx`.

## Design Principles Adopted From PPT Skills

- Claim first: every slide has one short title and one main takeaway.
- Proof object first: every content slide has a visual exhibit such as a pipeline, matrix, architecture map, evidence card, comparison table, or timeline.
- Chinese-first display: visible labels are Chinese except commit ids, SHA256, commands, file names, syscall names, and PASS-style evidence terms.
- Deep-sea visual system: deep navy, cyan highlight, white/light content slides, and high-contrast typography.
- 无可见制作痕迹：页面里不出现 `source:`、`self-drawn`、`generator`、占位符或工具水印。
- Evidence discipline: do not embed videos/screenshots/raw summaries; cite metadata and SHA256 only.

## Slide Plan

| # | 标题 | 核心观点 | 主要图示 |
| ---: | --- | --- | --- |
| 1 | 从能跑，到能教 | 项目是 OS 入门实验包，不是系统调用列表。 | 封面 + 三个证据锚点 |
| 2 | 评分口径决定路线 | 官方评分看执行展示、文档、答辩过程和演示材料。 | 初赛/决赛/决赛阶段三段评分图 |
| 3 | 复现才是第一道坎 | 环境、QEMU、日志和证据口径是教学复现痛点。 | 痛点卡 + 复现流水线 |
| 4 | 项目定位：课程实验包 | 面向学生、老师、助教和评委四类读者。 | 四角色中心图 |
| 5 | 证据从干净基线开始 | 基线、补丁、验证、摘要、证据索引形成可追溯链路。 | 横向证据流水线 |
| 6 | Lab 矩阵：从环境到 capstone | Lab0-Lab5 每阶段都有学习目标和验收项。 | Lab 学习矩阵 |
| 7 | Lab1/2：先走通内核入口 | 从 syscall 链路进入进程状态观察。 | syscall 路径 + 进程表快照 |
| 8 | Lab3：页表与 copyout | pgcount/memstat 区分地址空间增长与真实页映射。 | eager/lazy 页表对比 + copyout 路径 |
| 9 | Lab4：fd 与 file 的关系 | 区分当前进程 fd table 和全局 file table。 | ofile[] -> struct file -> file table |
| 10 | Lab5：把实验变成验收 | Lab5 是综合复现实验，不是新增内核机制。 | 综合复现验收阶梯 |
| 11 | 工具链：从脚本到课程入口 | labctl、verify、summary、hash check 组成课程工具链。 | 工具链架构图 |
| 12 | 三方复现证据 | rain/root/z2996 的全量验证共同支撑工程复现 commit `db85947`。 | 三方证据卡 + 工程复现 commit |
| 13 | 证据链可以重新计算 | 外部资产不进 Git，但 SHA256 可重新核验。 | 视频元数据 + SHA256 证据链 |
| 14 | 与 uCore/rCore 的差异 | 完整课程生态覆盖更广，本项目聚焦 OUC+xv6 的轻量入门实验和可复现验收。 | 左右对比：完整课程生态 vs 本项目 |
| 15 | 创新在组织方式 | 创新落在 patch workflow、课程材料、复现工具和证据边界。 | 五块创新拼图 |
| 16 | 边界与总结 | 真实、可复现、可教学，同时把提交前最后确认项说清楚。 | 完成/验证/边界/提交前确认总结板 |

## Fixed Evidence Facts

- final engineering commit: `db85947`
- evidence documentation commit: `caf8ced`
- current suite: integrated `0001-0009`
- historical checkpoint: `e8e2fb9 / 0001-0007`（历史检查点）
- three-way full verify: `rain / root / z2996` all PASS（三方全量验证通过）
- grade-summaries: `3 clean PASS / 0 needs attention`
- evidence hash check: `14/14 matched`
- final video: `20260611_final_integrated_0001_0009_demo.mp4`
- final video metadata: `00:03:12`, `2560×1440`, `60 fps`, `31,529,984 bytes`
- final video SHA256: `2A2C9863C185846225A98AC874499867A71588CED2020A64249CBF99C7BC0365`
- Baidu asset package: <https://pan.baidu.com/s/1Xt-G6VgP04eEAumqiMo7Uw?pwd=1234>, 提取码 `1234`, 目录 `proj54_submission_assets`

## Timing Plan

| 段落 | 页码 | 建议时间 |
| --- | --- | ---: |
| 题目理解和项目定位 | 1-4 | 1.5 分钟 |
| 实验体系和技术亮点 | 5-10 | 3 分钟 |
| 工具链与证据 | 11-13 | 1.5 分钟 |
| 对比、创新和收束 | 14-16 | 1.5 分钟 |

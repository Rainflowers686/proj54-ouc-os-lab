# Lab2 Process Observation 复现审查

## 目标

本文审查 Lab2 进程状态观察实验的教学价值和复现边界。Lab2 把 syscall 路径连接到 `struct proc`、进程状态枚举和锁。

## 适用对象

适用于助教、维护者和需要讲解进程观察实验的队员。

## 审查范围

Lab2 包括 `pstate(int pid)`、后续 `pcount(int state)` 和 `pchildtest`。integrated 路线中 `SYS_pstate = 24`，`SYS_pcount = 25`。

## 审查结论

Lab2 的核心不是实现完整 `ps`，而是让学生理解进程表遍历、状态快照和锁保护。`pstate(self) =`、`pcount(RUNNING) =`、`pcount(99) = -1` 和 `pstate(child) =` 是稳定验收入口，但具体数字和子进程状态不应固定。

## 质量标准

文档和任务书应要求学生解释锁的使用位置、负向输入的返回值和调度时序的不确定性。测试程序应真实读取内核状态，不打印写死结果。

## 边界条件

Lab2 不修改调度策略，不提供完整进程管理工具。报告中不能写“RUNNING 恒为某个数”或“child 状态必然为某个值”。

## 内容范围

本文内容限定在当前标题所对应的项目记录、教学说明、复现步骤或审查结论内。涉及 current final、historical checkpoint、验证命令和证据材料时，应以 `submissions/evidence_manifest.md`、`patches/integrated-labs/README.md` 和相关脚本为准。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 current final。

## 语言风格

使用中文技术写作风格，命令、文件名、commit、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

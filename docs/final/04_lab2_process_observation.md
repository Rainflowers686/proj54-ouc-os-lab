# 04 Lab2 Process Observation

## 目标

Lab2 通过 `pstate`、`pcount` 和 `pchildtest` 让学生观察 xv6 进程表、状态枚举、锁和调度时序。

## 适用对象

适用于已经完成 Lab1 的学生和讲解进程管理入门的助教。

## 内容范围

integrated 中 `SYS_pstate = 24`，`SYS_pcount = 25`。实验读取进程状态，不修改调度器，不实现完整 `ps`。

## 学习重点

`pstate(pid)` 帮助学生理解指定进程状态查询。`pcount(state)` 引入进程表遍历和负向输入。`pchildtest` 用子进程观察说明调度结果具有时序不确定性。

## 验证命令

```bash
bash scripts/labctl.sh test lab2
bash scripts/xv6/run-xv6-command.sh pstatetest "pstate(self) ="
bash scripts/xv6/run-xv6-command.sh pcounttest "pcount(RUNNING) ="
bash scripts/xv6/run-xv6-command.sh pcounttest "pcount(99) = -1"
bash scripts/xv6/run-xv6-command.sh pchildtest "pstate(child) ="
```

## 质量标准

报告应说明锁保护、状态枚举和不固定输出。验收只匹配稳定前缀，不固定 `RUNNING` 数量或 child 状态。

## 边界条件

Lab2 不提供完整进程管理工具，不修改调度策略。一次 QEMU 输出不能证明所有调度时序。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 current final。

## 语言风格

使用中文技术写作风格，命令、文件名、commit、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

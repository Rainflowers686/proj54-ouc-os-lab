# Lab2 进程状态观察

## 目标

Lab2 让学生通过 `pstate`、`pcount` 和 `pchildtest` 观察 xv6 进程表、进程状态枚举、锁和调度时序。

## 适用对象

适用于已完成 Lab1、理解 syscall 添加流程的学生。

## 内容范围

本实验覆盖 `struct proc`、`enum procstate`、`proc[]` 遍历、`p->lock` 和用户态测试程序。independent patch 提供 `pstate`；integrated 中 `pstate=24`、`pcount=25`。

## 学习结构

学生先观察当前进程状态，再统计某个状态的进程数量，最后通过 fork 子进程观察调度不确定性。重点是读共享内核状态前必须拿锁，所有返回路径必须释放锁。

## 验证命令

```bash
bash scripts/xv6/run-xv6-command.sh pstatetest "pstate(self) ="
bash scripts/xv6/run-xv6-command.sh pcounttest "pcount(RUNNING) ="
bash scripts/xv6/run-xv6-command.sh pcounttest "pcount(99) = -1"
bash scripts/xv6/run-xv6-command.sh pchildtest "pstate(child) ="
```

## 语言风格

报告应区分“观察到的某次输出”和“机制上必然成立的事实”。不要把 `pcount(RUNNING)` 或 child 状态写成固定值。

## 质量标准

学生应能解释锁保护、负向输入 `pcount(99) = -1` 和 `pchildtest` 的调度不确定性。

## 边界条件

Lab2 不实现完整 `ps`，不修改调度器。不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

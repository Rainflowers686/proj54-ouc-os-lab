# Lab4 File Table 与 FD 观察

## 目标

Lab4 通过 `fcount()`、`fdcount()` 和 `fdinfo()` 让学生区分用户态 fd、当前进程 fd table、内核 `struct file` 与全局 file table。

## 适用对象

适用于已完成 syscall 基础、准备理解文件描述符和内核文件对象的学生。

## 内容范围

本实验覆盖 `proc.ofile[]`、`struct file`、全局 `ftable`、`dup`、`open`、`close`、`argint + argaddr + copyout + struct ABI`。integrated 中 `fcount=26`、`fdcount=28`、`fdinfo=30`。

## 学习结构

学生先观察全局 file table 数量，再观察当前进程 fd 数量，最后用 `fdinfo` 查看单个 fd 的元数据。重点是 `dup` 会增加 fd 引用，但不一定新增全局 file table 条目。

## 验证命令

```bash
bash scripts/xv6/run-xv6-command.sh fcounttest "fcounttest done"
bash scripts/xv6/run-xv6-command.sh fdcounttest "fdcounttest done"
bash scripts/xv6/run-xv6-command.sh fdinfotest "fdinfotest done"
```

## 语言风格

报告应区分 fd 编号、`struct file` 对象和全局 file table，不用“文件数量”泛称所有指标。

## 质量标准

学生应能解释 `open`、`dup`、`close` 对 `fcount` 和 `fdcount` 的不同影响，并覆盖 closed fd / bad fd 负向测试。

## 边界条件

Lab4 是文件表观察实验，不实现完整文件系统。不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

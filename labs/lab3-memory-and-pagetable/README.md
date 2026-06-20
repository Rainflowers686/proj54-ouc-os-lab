# Lab3 页表与地址空间观察

## 目标

Lab3 通过 `pgcount()` 和 `memstat()` 帮助学生区分进程地址空间大小与实际页表映射数量，并学习 `argaddr + copyout + struct ABI`。

## 适用对象

适用于已完成 Lab1 和 Lab2、准备阅读页表和用户指针处理代码的学生。

## 内容范围

本实验覆盖 `walk(pagetable, va, 0)`、`PTE_V`、`PTE_U`、eager/lazy allocation 现象、`argaddr()`、`copyout()` 和共享结构体 ABI。integrated 中 `pgcount=27`、`memstat=29`。

## 学习结构

学生先运行 `pgcounttest` 观察 eager 与 lazy delta，再运行 `memstattest` 观察结构体返回。关键问题是：地址空间变大不等于页表已有映射，内核不能直接写用户指针。

## 验证命令

```bash
bash scripts/xv6/run-xv6-command.sh pgcounttest "pgcounttest done"
bash scripts/xv6/run-xv6-command.sh memstattest "memstattest done"
```

## 语言风格

报告应明确“映射页数”“地址空间大小”“页大小”的口径，不用“内存变多了”这类模糊表述。

## 质量标准

学生应能解释为什么 `walk(..., 0)` 不分配页，为什么只统计 `PTE_V && PTE_U`，为什么 `copyout` 能拦截坏用户指针。

## 边界条件

Lab3 是页表/地址空间观察实验，不实现完整内存管理。不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

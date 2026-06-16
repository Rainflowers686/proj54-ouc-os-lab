# Lab3 Patch Guide

## 目标

本目录保存 Lab3 independent patch，用于教学 `pgcount()` 和进阶 `memstat()`。

## 适用对象

适用于学习页表映射、lazy allocation 和 copyout 的学生、助教和维护者。

## 内容范围

`0001` 增加 `pgcount()`；`0002` 增加 `memstat(struct memstat*)`。integrated 中对应 `SYS_pgcount = 27` 和 `SYS_memstat = 29`。

## 结构规范

说明应区分 independent 编号与 integrated 编号，并写明 `walk(..., 0)`、`PTE_V`、`PTE_U` 和 `copyout` 边界。

## 验证命令

```bash
bash scripts/xv6/run-xv6-command.sh pgcounttest "pgcounttest done"
bash scripts/xv6/run-xv6-command.sh memstattest "memstattest done"
```

## 语言风格

用“页表映射数量观察”描述实验，不用“内存管理实现”。

## 质量标准

测试应验证 eager/lazy delta 和 bad pointer 行为。

## 边界条件

Lab3 patch 不修改 page fault 策略。不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

# Lab4 Patch Guide

## 目标

本目录保存 Lab4 independent patch，用于教学 file table、fd table 和 fd metadata 观察。

## 适用对象

适用于学习 xv6 文件描述符结构的学生、助教和维护者。

## 内容范围

`0001` 增加 `fcount()`，`0002` 增加 `fdinfo(int, struct fdinfo*)`。integrated 中还包含 `fdcount()`，最终编号为 `fcount=26`、`fdcount=28`、`fdinfo=30`。

## 结构规范

说明应区分 fd、`struct file`、全局 `ftable` 和当前进程 `ofile[]`。

## 验证命令

```bash
bash scripts/xv6/run-xv6-command.sh fcounttest "fcounttest done"
bash scripts/xv6/run-xv6-command.sh fdinfotest "fdinfotest done"
```

## 语言风格

用“file/fd 观察接口”描述功能，不写成完整文件系统。

## 质量标准

测试应覆盖 open/dup/close、closed fd 和 bad fd。

## 边界条件

不返回路径、inode 号或文件内容。不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

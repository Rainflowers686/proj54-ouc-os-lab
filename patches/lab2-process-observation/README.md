# Lab2 Patch Guide

## 目标

本目录保存 Lab2 independent patch，用于单独教学 `pstate(int)` 进程状态观察。

## 适用对象

适用于学习进程表和锁的学生、助教和维护者。

## 内容范围

patch 从 clean baseline 增加 `pstate`、用户声明、stub、测试程序和 Makefile 入口。integrated 中相关功能扩展为 `pstate=24`、`pcount=25`。

## 结构规范

说明应包含 baseline、应用方式、输出前缀和锁边界。

## 验证命令

```bash
cd external/xv6-riscv
git reset --hard 74f84181a3404d1d6a6ff98d342233979066ebb8
git clean -fdx
git apply ../../patches/lab2-process-observation/0001-add-pstate-syscall.patch
make
```

## 语言风格

不要把一次 `RUNNING` 输出写成固定规律。

## 质量标准

`pstatetest` 应输出 `pstate(self) =`，并能解释锁路径。

## 边界条件

Lab2 independent patch 不可直接叠加到 Lab1 independent patch。不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

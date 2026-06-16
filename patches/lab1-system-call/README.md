# Lab1 Patch Guide

## 目标

本目录保存 Lab1 independent patch，用于从 clean xv6 baseline 单独教学 `hello()` 和 `add2(int,int)`。

## 适用对象

适用于学生单关学习、助教演示和维护者审查 Lab1 增量。

## 内容范围

`0001-add-hello-syscall.patch` 增加最小 syscall，`0002-add-argint-add2-syscall.patch` 增加整数参数读取。两者按顺序应用。

## 结构规范

patch 文档必须写明 baseline、应用顺序、测试命令和与 integrated sequence 的关系。

## 验证命令

```bash
cd external/xv6-riscv
git reset --hard 74f84181a3404d1d6a6ff98d342233979066ebb8
git clean -fdx
git apply ../../patches/lab1-system-call/0001-add-hello-syscall.patch
git apply ../../patches/lab1-system-call/0002-add-argint-add2-syscall.patch
make
```

## 语言风格

说明应聚焦 syscall 七件套，不把示例返回值写成实验价值本身。

## 质量标准

`hello` 和 `add2test` 应能在 clean baseline 上构建并输出稳定文本。

## 边界条件

Lab1 independent patch 不代表其他 lab 可直接叠加。不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

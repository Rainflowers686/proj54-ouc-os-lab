# Lab1 系统调用入门

## 目标

Lab1 让学生完成第一个 xv6 系统调用。`hello()` 用最小返回值打通 user/kernel 路径，`add2(int,int)` 引入 `argint()` 参数读取，为后续进程、页表和文件表观察实验打基础。

## 适用对象

适用于已完成 Lab0、能构建并启动 xv6 的学生。教师可用本实验讲解 syscall 七件套。

## 内容范围

本实验覆盖 `kernel/syscall.h`、`kernel/syscall.c`、`kernel/sysproc.c`、`user/user.h`、`user/usys.pl`、`Makefile` 和用户测试程序。independent patch 为 `0001-add-hello-syscall.patch` 与 `0002-add-argint-add2-syscall.patch`；integrated 中 `hello=22`、`add2=23`。

## 学习结构

学生先复现 `hello()`，再复现 `add2()`，最后独立实现一个同等难度整数 syscall。学习重点不是返回 `2026` 或 `26`，而是理解 `usys.pl` stub、`ecall`、`syscall()` 分发、`argint()` 和 `a0` 返回值。

## 验证命令

```bash
bash scripts/xv6/run-xv6-command.sh hello "hello syscall returned 2026"
bash scripts/xv6/run-xv6-command.sh add2test "add2(20, 6) returned 26"
```

## 语言风格

实验报告应使用“调用路径、修改文件、验证输出、失败症状”的结构，不写成泛泛心得。

## 质量标准

学生应能说明七个文件各自作用，并能解释漏改 `user/usys.pl` 或 `syscall.c` 表项时的不同失败现象。

## 边界条件

Lab1 只覆盖整数参数 syscall，不覆盖用户指针、字符串参数或结构体 copyout。不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

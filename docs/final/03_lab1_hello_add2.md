# 03 Lab1 Hello Add2

## 目标

Lab1 让学生从最小系统调用进入 xv6 的 user/kernel 边界。`hello()` 建立 syscall 链路，`add2(int,int)` 引入参数读取。

## 适用对象

适用于第一次学习 xv6 syscall 的学生，以及需要讲解系统调用路径的助教。

## 内容范围

Lab1 涉及 `kernel/syscall.h`、`kernel/syscall.c`、`kernel/sysproc.c`、`user/user.h`、`user/usys.pl`、`Makefile` 和用户程序。integrated 中 `SYS_hello = 22`，`SYS_add2 = 23`。

## 学习重点

学生应理解用户程序调用如何经 `usys.pl` 生成的 stub、`ecall`、`syscall.c` 分发表进入内核 `sys_*` 函数，并把返回值带回用户态。`add2` 要求理解 `argint()` 如何按索引读取整数参数。

## 验证命令

```bash
bash scripts/labctl.sh test lab1
bash scripts/xv6/run-xv6-command.sh hello "hello syscall returned 2026"
bash scripts/xv6/run-xv6-command.sh add2test "add2(20, 6) returned 26"
```

## 质量标准

报告应能解释每个文件修改的作用，并至少记录一种破坏-修复症状。不能只写“加了系统调用并运行成功”。

## 边界条件

Lab1 不讨论复杂参数安全，不代表完整 syscall 设计。独立 patch 与 integrated patch 的 syscall 编号上下文不同，引用时应说明路线。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 current final。

## 语言风格

使用中文技术写作风格，命令、文件名、commit、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

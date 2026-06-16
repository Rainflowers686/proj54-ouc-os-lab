# 00 Project Overview

## 目标

OUC xv6 Lab Kit 是面向中国海洋大学操作系统课程的 xv6-riscv 分阶段实验指导、参考实现与可复现验证体系。项目目标是把 syscall、进程、页表、文件表和 copyout 这几类入门关键概念组织成可教学、可复现、可验收的实验包。

## 适用对象

本项目面向低年级学生、操作系统课程助教、准备复现实验的队友和 OS 功能挑战赛评审。学生用它学习 xv6 入门机制，教师用它布置实验，评审用它查看课程价值和证据链。

## 内容范围

项目包括 Lab0 到 Lab5、独立 lab patches、integrated `0001-0009`、验证脚本、教师材料、评分标准、排障手册、正式技术报告和提交证据索引。第三方 xv6 源码不进入仓库，本仓库只保存本队增量。

## 当前状态

current final 为 `db85947 feat(course): add lab runner and grading helpers`，integrated suite 为 `0001-0009`。syscall 编号为 hello=22、add2=23、pstate=24、pcount=25、fcount=26、pgcount=27、fdcount=28、memstat=29、fdinfo=30。rain、root、z2996 三方 full verification 已登记为 PASS。

## 项目价值

项目价值不在于堆叠复杂内核功能，而在于把低年级学生能理解的最小机制变成一套课程路径。Lab1 建立系统调用链路，Lab2 引入进程表和锁，Lab3 区分页表映射与地址空间大小，Lab4 区分 fd、`struct file` 和全局 file table，`memstat`/`fdinfo` 补充结构体 copyout，Lab5 训练综合复现和证据表达。

## 质量标准

项目材料应能回答“怎么跑、为什么这样设计、证据在哪、边界是什么”。所有完成状态应能追溯到 patch、脚本、summary、视频元数据或 evidence manifest。

## 边界条件

本项目不是 LTP 覆盖项目，不实现完整内存管理、文件系统或调度器。Lab5 不新增内核机制。historical `e8e2fb9 / 0001-0007` 只作为历史稳定检查点。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 current final。

## 语言风格

使用中文技术写作风格，命令、文件名、commit、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

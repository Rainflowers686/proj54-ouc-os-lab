# Lab5 综合复现

## 目标

Lab5 要求学生从 clean xv6-riscv baseline 出发，应用 integrated `0001-0009`，完成 build、boot、全部用户程序验证和证据报告。

## 适用对象

适用于已完成 Lab0-Lab4、准备进行课程综合验收的学生。

## 内容范围

Lab5 串联 Lab0-Lab4 和进阶 `memstat`、`fdinfo`，但不新增内核机制。它关注可复现流程、证据记录和边界表达。

## 学习结构

学生按环境诊断、clean apply、make、boot、用户程序验证、patch 阅读、报告写作的顺序完成。最终报告应让另一台机器上的同学能复现同一流程。

## 验证命令

```bash
bash scripts/xv6/doctor.sh
bash scripts/xv6/apply-integrated-labs.sh --make --yes
bash scripts/xv6/teammate-verify.sh --full
```

## 语言风格

报告应分清本机验证、队友复现、视频证据和历史证据，不用“全部稳定”替代具体命令结果。

## 质量标准

合格报告应包含 suite、baseline、patch 顺序、summary、失败记录、证据边界和不提交 raw evidence 的说明。

## 边界条件

Lab5 是 capstone 综合复现实验，不新增内核机制。不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

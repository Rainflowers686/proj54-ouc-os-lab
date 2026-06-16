# Teammate Reproduction Record

## 目标

本文记录队长和队友 full verification 的摘要索引，说明 current final 与 historical reproduction 的边界。

## 适用对象

适用于队长、队友、评审和提交材料维护者。

## 内容范围

本文记录 `db85947 / 0001-0009` 的 rain/root/z2996 full PASS，以及 `e8e2fb9 / 0001-0007` 和更早 `1ba9db6` 的 historical 记录。

## Current Final Summary

| 角色 | user | suite | result |
| --- | --- | --- | --- |
| team lead | `rain` | `0001-0009` | PASS |
| teammate A | `root` | `0001-0009` | PASS |
| teammate B | `z2996` | `0001-0009` | PASS |

## 结构规范

记录必须包含 user、commit、suite、mode、result 和外部证据路径。raw summary 原件不入 Git。

## 语言风格

使用复现记录语言，不把失败删除，不手工美化 summary。

## 质量标准

记录应可被 `grade-summaries.sh` 和 evidence manifest 交叉核对。

## 边界条件

不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

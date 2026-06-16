# Demo Record

## 目标

本文记录演示视频和历史视频的元数据、范围和证据边界，不保存视频本体。

## 适用对象

适用于评审、队长、提交材料维护者和隐私复核人员。

## 内容范围

本文覆盖 current final `20260611_final_integrated_0001_0009_demo.mp4`、historical `0001-0007` 视频和更早历史视频。视频原件位于外部证据资产包。

## Current Final Video

| 字段 | 内容 |
| --- | --- |
| file | `20260611_final_integrated_0001_0009_demo.mp4` |
| scope | `db85947 / integrated 0001-0009` |
| duration | `00:03:12` |
| resolution | `2560x1440` |
| frame rate | `60 fps` |
| size | `31,529,984 bytes` |
| SHA256 | `2A2C9863C185846225A98AC874499867A71588CED2020A64249CBF99C7BC0365` |

## 结构规范

每条视频记录必须写明范围、文件名、大小、时长、分辨率、SHA256 和是否为 historical。

## 语言风格

视频记录只描述事实，不替代验证报告。

## 质量标准

视频元数据应与 evidence manifest 一致。

## 边界条件

不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

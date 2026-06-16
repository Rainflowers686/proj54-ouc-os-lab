# Demo Script

## 目标

本文提供演示视频脚本，帮助录制者按项目定位、复现流程和证据边界组织讲解。

## 适用对象

适用于录屏人员、答辩讲者和提交材料维护者。

## 内容范围

脚本覆盖 README 项目定位、baseline、integrated patches、环境检查、apply+make、boot、用户程序验证、证据索引和边界说明。

## 演示流程

1. 展示 README 中项目定位和 current final。
2. 展示 `patches/integrated-labs/README.md` 的 `0001-0009`。
3. 运行或展示 `teammate-verify.sh --full` summary。
4. 展示 `submissions/evidence_manifest.md` 的视频 SHA256 和三方复现。
5. 说明 raw logs、视频、截图和隐私材料不入 Git。

## 语言风格

讲解应控制在事实和证据范围内，不说“长期稳定”或“完整文件系统/内存管理”。

## 质量标准

录制前应关闭隐私窗口和通知，确认没有 token、密码、报名材料或个人信息。

## 边界条件

不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

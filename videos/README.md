# Videos Directory

## 目标

本目录只保存视频说明，不保存视频原件。视频原件位于外部证据资产包，仓库内只记录元数据和 SHA256。

## 适用对象

适用于提交材料维护者、评审和隐私复核人员。

## 内容范围

说明覆盖 final demo video、historical videos、外部资产位置、隐私边界和 SHA256 核验方式。

## 结构规范

视频记录应转写到 `submissions/demo_record.md` 和 `submissions/evidence_manifest.md`，不要在本目录保存大文件。

## 语言风格

使用证据管理语言，避免“视频证明长期稳定”这类过度表述。

## 质量标准

视频元数据应包含文件名、大小、时长、分辨率、帧率、范围和 SHA256。

## 边界条件

不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

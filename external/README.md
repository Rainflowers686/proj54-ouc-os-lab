# External Directory

## 目标

本目录说明第三方 xv6-riscv 源码的本地放置方式和不入库边界。

## 适用对象

适用于复现人员、维护者和评审。

## 内容范围

`external/xv6-riscv/` 是本地工作目录，用于 clone 上游 xv6-riscv 并应用 patch。该目录被 Git 忽略。baseline metadata 可记录在 `external/xv6-baseline-record.md`。

## 结构规范

外部源码说明应写清上游仓库、baseline commit、用途和不提交策略。

## 语言风格

使用依赖说明语言，不把上游源码写成本队贡献。

## 质量标准

任何复现文档引用 baseline 时应与这里和正式文档一致。

## 边界条件

不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

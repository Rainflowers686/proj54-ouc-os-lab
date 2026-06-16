# Logs Directory

## 目标

本目录说明日志文件策略。raw logs、console captures 和 summary 原件默认不提交 Git。

## 适用对象

适用于学生、队友复现人员、助教和维护者。

## 内容范围

脚本运行产生的 `*.log`、`*.summary.txt`、`*.console.txt` 可用于本地定位问题，但正式仓库只保存摘要、元数据和 SHA256。

## 结构规范

日志说明应写清哪些文件可本地保存、哪些禁止入库、哪些信息可复制到报告。

## 语言风格

使用仓库卫生说明语言。

## 质量标准

`scripts/check-final-hygiene.sh` 应确认 raw logs 和 summary 原件未被跟踪。

## 边界条件

不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

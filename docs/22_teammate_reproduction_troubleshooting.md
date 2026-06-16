# 队友复现故障排查

## 目标

本文面向队友复现时的高频故障，说明 QEMU 卡住、`Ctrl+Z` 挂起、timeout 和路径性能问题的处理方式。

## 适用对象

适用于运行 `teammate-verify.sh --full` 的队友、助教和验收人员。

## 快速处理

遇到异常先运行：

```bash
bash scripts/xv6/doctor.sh
bash scripts/xv6/cleanup-qemu.sh
```

若同一终端里按过 `Ctrl+Z`，再运行 `jobs -l` 查看挂起任务，并用 `kill %<job>` 清理。

## 常见原因

仓库位于 `/mnt/d/...` 时，第一次 make 或 boot 可能偏慢，这是 drvfs 性能和 mtime 行为导致的常见现象。`Ctrl+Z` 不是退出 QEMU，而是挂起进程，后续脚本可能遇到残留进程。期望文本过窄也会导致 `COMMAND_EVIDENCE_NOT_FOUND`。

## 质量标准

报告故障时应提供 doctor 输出、执行命令、失败日志尾部和是否按过 `Ctrl+Z`。不要只发截图，不要手工改 summary。

## 边界条件

排障文档不替代 full verification。清理 QEMU 只能修复本地残留进程，不能证明项目通过。

## 内容范围

本文内容限定在当前标题所对应的项目记录、教学说明、复现步骤或审查结论内。涉及 current final、historical checkpoint、验证命令和证据材料时，应以 `submissions/evidence_manifest.md`、`patches/integrated-labs/README.md` 和相关脚本为准。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 current final。

## 语言风格

使用中文技术写作风格，命令、文件名、commit、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

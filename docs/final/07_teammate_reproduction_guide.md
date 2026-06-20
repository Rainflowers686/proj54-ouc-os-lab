# 07 Teammate Reproduction Guide

## 目标

本文说明队友如何独立复现 当前正式验证范围，并提交可审查 summary。

## 适用对象

适用于队友、助教、评审复现人员和提交前独立验证人员。

## 前置条件

使用 WSL2 Ubuntu 或 Linux。确认有 git、bash、make、QEMU 和 RISC-V gcc。若不确定环境状态，先运行 `bash scripts/xv6/doctor.sh`。

## 标准流程

```bash
bash scripts/xv6/teammate-verify.sh --full
```

脚本会执行环境检查、baseline 检查、integrated patch 应用、make、boot 和用户程序检查，并输出可复制给队长的 summary 块。

## 输出要求

队友应复制 `COPY THIS SUMMARY TO TEAM LEAD` 块，不手工修改。若失败，也应保留失败 summary 和日志尾部，便于定位。

## 质量标准

summary 应包含 user、suite、mode、各项 PASS/FAIL 和 overall。队长可用 `scripts/grade-summaries.sh` 批量检查。

## 边界条件

队友复现只证明某台机器按脚本完成一次验证，不代表长期稳定性。summary 原件和截图不入 Git，正式索引写入 `submissions/evidence_manifest.md`。

## 内容范围

本文内容限定在当前标题所对应的项目记录、教学说明、复现步骤或审查结论内。涉及 当前正式验证范围、历史证据、验证命令和证据材料时，应以 `submissions/evidence_manifest.md`、`patches/integrated-labs/README.md` 和相关脚本为准。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 当前正式验证范围。

## 语言风格

使用中文技术写作风格，命令、文件名、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

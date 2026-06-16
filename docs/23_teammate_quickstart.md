# 队友正式复现 Quickstart

## 目标

本文提供队友从零运行 final verification 的最短路径，确保 summary 能被队长和 `grade-summaries.sh` 解析。

## 适用对象

适用于队友、助教、评审复现人员和提交前独立验证人员。

## 前置条件

在 WSL2 Ubuntu 或 Linux 中运行。需要 `git`、`bash`、`make`、`qemu-system-riscv64` 和 RISC-V gcc。Windows Git Bash 不适合运行 make/QEMU。

## 复现命令

```bash
bash scripts/xv6/doctor.sh
bash scripts/xv6/teammate-verify.sh --full
```

如果已经完成 make，只想重测用户程序，可以使用：

```bash
bash scripts/xv6/teammate-verify.sh --quick
```

## 交付内容

复现完成后，复制输出中的 `COPY THIS SUMMARY TO TEAM LEAD` 块给队长。不要手工改 commit、时间、user 或 PASS/FAIL。raw logs 和 summary 文件默认在 ignored `logs/` 下，不提交 Git。

## 质量标准

summary 应包含 commit、suite、user、mode、逐项结果和 overall。队长会用 `scripts/grade-summaries.sh` 批量解析。

## 边界条件

队友复现只证明当前机器按脚本完成一次验证，不等于长期稳定性测试。失败 summary 也有价值，不应删除或篡改。

## 内容范围

本文内容限定在当前标题所对应的项目记录、教学说明、复现步骤或审查结论内。涉及 current final、historical checkpoint、验证命令和证据材料时，应以 `submissions/evidence_manifest.md`、`patches/integrated-labs/README.md` 和相关脚本为准。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 current final。

## 语言风格

使用中文技术写作风格，命令、文件名、commit、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

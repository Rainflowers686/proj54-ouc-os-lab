# 02 Lab0 Baseline Build Boot

## 目标

Lab0 的目标是在修改 xv6 前建立可信 baseline：确认上游源码、构建环境、make 过程和 boot evidence 都可用。

## 适用对象

适用于所有学生和复现人员。未完成 Lab0 不建议继续 Lab1。

## 内容范围

Lab0 覆盖 `external/xv6-riscv/` 的 baseline 版本、构建命令、QEMU 启动和关键输出捕获。baseline 版本由 `scripts/xv6/apply-integrated-labs.sh` 和 `external/xv6-baseline-record.md` 记录。

## 推荐命令

```bash
bash scripts/labctl.sh doctor
bash scripts/labctl.sh setup --yes
bash scripts/labctl.sh boot
```

底层命令包括：

```bash
bash scripts/xv6/check-xv6-baseline.sh --make
bash scripts/xv6/boot-xv6.sh
```

## 验收标准

make 阶段应成功退出。boot 阶段应捕获 `xv6 kernel is booting` 和 `init: starting sh`。日志保存在 ignored `logs/` 下，不提交 Git。

## 质量标准

报告应写清环境、命令、baseline 版本 和 boot 证据。若失败，应提供 `doctor` 输出和日志尾部。

## 边界条件

Lab0 不修改内核，不证明后续 syscall 已存在。boot timeout 成功捕获不是长期稳定性测试。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 当前正式验证范围。

## 语言风格

使用中文技术写作风格，命令、文件名、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

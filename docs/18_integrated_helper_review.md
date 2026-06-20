# Integrated Helper 安全性与可复现性审查

## 目标

本文审查 `scripts/xv6/apply-integrated-labs.sh` 等 helper 的作用、风险控制和使用边界。

## 适用对象

适用于队友复现人员、助教、维护者和评审。

## 审查范围

helper 负责检查路径、重置本地 xv6 源码、清理 ignored 文件、按顺序应用 integrated patches、可选运行 make，并把日志放入 ignored `logs/`。它不应修改主仓库 tracked 文件。

## 审查结论

helper 把容易出错的手动流程收束为可重复命令，适合 final demo 和队友复现。预览模式只读；执行 reset/apply/make 需要明确参数和确认。

## 质量标准

脚本应清楚输出将要处理的 baseline、patch 列表和 make 状态。失败时应保留可定位日志。文档应提醒用户 `external/xv6-riscv/` 会被重置，不要在其中保存未提交个人改动。

## 边界条件

helper 不验证长期稳定性，不提交证据，不保证外部视频存在。它只负责把源码树带到可构建和可测试状态。

## 内容范围

本文内容限定在当前标题所对应的项目记录、教学说明、复现步骤或审查结论内。涉及 当前正式验证范围、历史证据、验证命令和证据材料时，应以 `submissions/evidence_manifest.md`、`patches/integrated-labs/README.md` 和相关脚本为准。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 当前正式验证范围。

## 语言风格

使用中文技术写作风格，命令、文件名、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

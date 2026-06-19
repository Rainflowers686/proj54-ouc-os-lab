# 提交就绪度审查

## 目标

本文给出提交前的系统检查清单，确认代码、文档、证据和边界说明是否达到可提交状态。

## 适用对象

适用于队长、答辩材料维护者、指导教师和提交前红队审查人员。

## 审查范围

审查覆盖 当前正式验证范围 身份、integrated patch sequence、验证脚本、正式技术报告、PPT、证据 manifest、外部证据资产包、仓库卫生和隐私边界。

## 当前状态

当前正式验证范围 为 `integrated 0001-0009`。rain、root、z2996 三方 full verification PASS，最终演示视频和 SHA256 已登记，PPTX 已生成但答辩前仍需人工最终审阅和排练。平台提交方式需按官方要求确认。

## 必跑命令

```bash
bash scripts/check-docs-consistency.sh
bash scripts/check-final-hygiene.sh
git diff --check
```

如需核验证据资产包，下载外部目录后运行：

```bash
XV6_EVIDENCE_BASE=<local path>/proj54_submission_assets bash scripts/check-evidence-sha256.sh
```

## 质量标准

提交材料应能独立说明项目目标、课程价值、实现路线、验证结果、证据位置、AI 使用和许可证边界。所有 PASS 应可追溯到真实 summary、视频或脚本输出。

## 边界条件

不把“PPT 已生成”写成“答辩已完成”。不把“视频已录制”写成“平台已提交”。不把 历史证据 写成 当前正式验证范围。

## 内容范围

本文内容限定在当前标题所对应的项目记录、教学说明、复现步骤或审查结论内。涉及 当前正式验证范围、历史证据、验证命令和证据材料时，应以 `submissions/evidence_manifest.md`、`patches/integrated-labs/README.md` 和相关脚本为准。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 当前正式验证范围。

## 语言风格

使用中文技术写作风格，命令、文件名、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

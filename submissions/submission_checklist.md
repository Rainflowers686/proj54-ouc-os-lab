# 提交检查清单

## 目标

本文提供最终提交前自查清单，确认仓库卫生、工程复现、文档材料、视频记录、队友复现和红队审核均有明确状态。

## 适用对象

适用于队长、提交材料维护者、指导教师和最终红队审查人员。

## 内容范围

清单覆盖平台合规、Git 卫生、工程复现、正式文档、PPT、证据 manifest、视频记录、队友复现、最终命令和剩余待补充项。

## 必跑命令

```bash
bash scripts/collect-report.sh
bash scripts/check-final-hygiene.sh
bash scripts/check-docs-consistency.sh
bash scripts/check-evidence-sha256.sh
git diff --check
git status --short
```

## 当前提交状态

当前正式版本采用 integrated suite `0001-0009`，rain/root/z2996 三方 full PASS，final video 与 SHA256 已登记，外部资产包已上传并可按 SHA256 核验。平台提交方式、最终 PPT 人工审阅、答辩排练和外部引用许可证核对仍需人工确认。

## 结构规范

每个检查项应写明期望状态、命令或证据位置。不可机器判断的项目应标记为人工确认。

## 语言风格

使用检查清单语言，避免宣传性描述。

## 质量标准

提交前不得存在未解释的 FAIL、过期的当前正式验证范围 描述或禁止入库文件。

## 边界条件

不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

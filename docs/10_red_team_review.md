# 红队审查报告

## 目标

本文给出项目红队审查的通用结论和检查方法，帮助维护者发现事实漂移、证据夸大、文档不一致和复现链路断裂。

## 适用对象

适用于队长、文档维护者、答辩准备人员和评审预审人员。

## 审查范围

红队审查覆盖四类风险：代码与文档不一致，current final 与 historical evidence 混淆，观察型实验被夸大为完整子系统，验证命令无法支撑文档声称。

## 关键结论

当前必须坚持 `db85947 / 0001-0009` 为 final identity，`e8e2fb9 / 0001-0007` 只能作为 historical checkpoint。`memstat` 和 `fdinfo` 已在 current final 中验证，但仍只是结构体 copyout 观察接口。timeout evidence 不能写成长期稳定性。

## 审查方法

优先运行 `scripts/check-docs-consistency.sh` 检查 patch 列表、syscall 编号、验证脚本覆盖和 stale wording。再运行 `scripts/check-final-hygiene.sh` 检查禁止提交的源码、日志、媒体和隐私文件。人工审查应重点读 `submissions/evidence_manifest.md`、正式技术报告和 PPT。

## 质量标准

红队结论必须带证据位置或命令，不用主观判断替代验证。发现问题后应写清影响范围、修复文件和复查命令。

## 边界条件

红队审查不生成新的 PASS，不替代队友复现，不替代平台提交检查。

## 内容范围

本文内容限定在当前标题所对应的项目记录、教学说明、复现步骤或审查结论内。涉及 current final、historical checkpoint、验证命令和证据材料时，应以 `submissions/evidence_manifest.md`、`patches/integrated-labs/README.md` 和相关脚本为准。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 current final。

## 语言风格

使用中文技术写作风格，命令、文件名、commit、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

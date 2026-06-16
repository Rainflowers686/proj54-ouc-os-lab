# xv6-riscv Baseline Plan

## 目标

本文说明 xv6 baseline 的选择、保存方式和复现边界，确保所有 patch 都能从同一个干净基底解释和验证。

## 适用对象

适用于维护 patch、运行复现脚本、审查贡献边界的队员和评审。

## baseline 信息

上游仓库为 `https://github.com/mit-pdos/xv6-riscv.git`，baseline commit 为 `74f84181a3404d1d6a6ff98d342233979066ebb8`。本地源码路径为 `external/xv6-riscv/`，该目录不进入 Git。

## 使用方式

自动路线使用 `bash scripts/xv6/apply-integrated-labs.sh --make --yes`，脚本会 reset、clean、按顺序应用 integrated `0001-0009` 并运行 make。手动路线必须先 reset 到 baseline，再按 patch README 中的顺序应用。

## 质量标准

任何 patch 声称可复现，都应说明基底、应用顺序、构建命令和验证方式。baseline 元数据应与 `external/README.md` 和 `external/xv6-baseline-record.md` 保持一致。

## 边界条件

不要把第三方 xv6 源码提交到本仓库。不要在已经叠加其他 independent patch 的源码树上继续应用另一组 independent patch。组合演示只使用 integrated sequence。

## 内容范围

本文内容限定在当前标题所对应的项目记录、教学说明、复现步骤或审查结论内。涉及 current final、historical checkpoint、验证命令和证据材料时，应以 `submissions/evidence_manifest.md`、`patches/integrated-labs/README.md` 和相关脚本为准。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 current final。

## 语言风格

使用中文技术写作风格，命令、文件名、commit、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

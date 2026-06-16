# Integrated Labs 综合序列复现审查

## 目标

本文审查 integrated `0001-0009` 作为最终综合演示路线的完整性、教学价值和验证边界。

## 适用对象

适用于评审、队友复现人员、维护者和答辩准备人员。

## 审查范围

integrated sequence 从 clean xv6 baseline 顺序应用九个 patch，提供十个用户程序检查：`hello`、`add2test`、`pstatetest`、`pcounttest`、`pchildtest`、`fcounttest`、`pgcounttest`、`fdcounttest`、`memstattest`、`fdinfotest`。

## 审查结论

该序列能在同一内核中展示系统调用、进程、页表、文件表、fd table 和结构体 copyout。current final `db85947 / 0001-0009` 已有三方 full verification PASS 记录。`e8e2fb9 / 0001-0007` 只证明旧序列稳定，不覆盖后两个进阶接口。

## 质量标准

复现应优先使用 `bash scripts/xv6/apply-integrated-labs.sh --make --yes` 和 `bash scripts/xv6/teammate-verify.sh --full`。报告应贴 summary 块，并说明 commit 与 suite。

## 边界条件

integrated sequence 是课程实验组合，不是生产级内核功能集合。`memstat` 不返回物理地址；`fdinfo` 不返回路径、inode 号或文件内容。

## 内容范围

本文内容限定在当前标题所对应的项目记录、教学说明、复现步骤或审查结论内。涉及 current final、historical checkpoint、验证命令和证据材料时，应以 `submissions/evidence_manifest.md`、`patches/integrated-labs/README.md` 和相关脚本为准。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 current final。

## 语言风格

使用中文技术写作风格，命令、文件名、commit、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

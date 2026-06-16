# 11 Known Limits and Future Work

## 目标

本文列出项目已知限制和后续可扩展方向，防止正式材料夸大当前成果。

## 适用对象

适用于评审、教师、队伍成员和后续维护者。

## 已知限制

`pgcount()` 只观察用户页表映射数量，不是完整内存管理。`memstat()` 只返回地址空间统计，不返回物理地址，也不实现分配策略。`fcount()`、`fdcount()` 和 `fdinfo()` 只观察 file/fd 状态，不是完整文件系统。Lab5 是 capstone 综合复现，不新增内核机制。

timeout 自动捕获只说明一次匹配成功，不代表长期稳定性。final video 已登记，但平台提交方式仍需按官方要求确认。PPT 已生成，但答辩前仍需人工审阅和排练。外部参考 URL 与许可证应在最终发布前继续核对。

## 后续工作

课程侧可以增加学生骨架版、更多自动评分脚本、扩展挑战和课堂讲解素材。技术侧可设计更深入但安全的页表、进程生命周期或文件系统观察实验。提交侧应继续保持 evidence manifest、SHA256 核验和仓库卫生检查。

## 质量标准

后续工作应与当前边界区分清楚。未完成事项不得写成已完成，扩展设想不得混入 current final 功能列表。

## 边界条件

本文件承认限制，不降低 current final 已验证部分的有效性。current final 仍以 `db85947 / 0001-0009` 三方 full verification 和 evidence manifest 为准。

## 内容范围

本文内容限定在当前标题所对应的项目记录、教学说明、复现步骤或审查结论内。涉及 current final、historical checkpoint、验证命令和证据材料时，应以 `submissions/evidence_manifest.md`、`patches/integrated-labs/README.md` 和相关脚本为准。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 current final。

## 语言风格

使用中文技术写作风格，命令、文件名、commit、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

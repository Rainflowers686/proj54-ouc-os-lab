# Lab4 文件表观察实验复现审查

## 目标

本文审查 Lab4 对全局 file table、当前进程 fd table 和 fd 元数据观察的教学价值。

## 适用对象

适用于教师、助教、维护者和评审。

## 审查范围

Lab4 包括 `fcount()`、`fdcount()` 和 `fdinfo(int, struct fdinfo*)`。integrated 编号分别为 `SYS_fcount = 26`、`SYS_fdcount = 28`、`SYS_fdinfo = 30`。

## 审查结论

`fcount` 观察全局 `struct file` 中 ref 大于 0 的条目，`fdcount` 观察当前进程 `ofile[]` 非空项，`fdinfo` 返回单个 fd 的 type/readable/writable/ref。三者共同帮助学生区分用户态 fd、内核 `struct file` 和全局 file table。

## 质量标准

文档应解释 `dup` 对 fdcount 与 fcount 的不同影响。验收不应固定全局 fcount 的绝对值，应检查稳定前缀和程序内部断言。`fdinfo` 应覆盖 open/dup、closed fd 和 bad fd。

## 边界条件

Lab4 不是完整文件系统实验，不涉及 inode 布局、路径解析、磁盘块管理或文件内容读取。`fdinfo` 不返回路径、inode 号或宿主文件信息。

## 内容范围

本文内容限定在当前标题所对应的项目记录、教学说明、复现步骤或审查结论内。涉及 当前正式验证范围、历史证据、验证命令和证据材料时，应以 `submissions/evidence_manifest.md`、`patches/integrated-labs/README.md` 和相关脚本为准。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 当前正式验证范围。

## 语言风格

使用中文技术写作风格，命令、文件名、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

# 05 Lab4 File Table Observation

## 目标

Lab4 通过 `fcount()`、`fdcount()` 和 `fdinfo()` 让学生区分用户 fd、当前进程 fd table、内核 `struct file` 和全局 file table。

## 适用对象

适用于已完成 syscall 基础、准备学习文件描述符与内核文件结构的学生。

## 内容范围

integrated 中 `SYS_fcount = 26`，`SYS_fdcount = 28`，`SYS_fdinfo = 30`。`fcount` 观察全局 file table 中 ref 大于 0 的条目，`fdcount` 观察当前进程 `ofile[]`，`fdinfo` 返回单个 fd 的 type/readable/writable/ref。

## 学习重点

学生应理解 `dup()` 会增加当前进程 fd 数，但不一定新增全局 `struct file` 条目。`fdinfo` 通过 `argint + argaddr + copyout + struct ABI` 展示带 fd 参数和用户结构体输出的 syscall 写法。

## 验证命令

```bash
bash scripts/labctl.sh test lab4
bash scripts/xv6/run-xv6-command.sh fcounttest "fcounttest done"
bash scripts/xv6/run-xv6-command.sh fdcounttest "fdcounttest done"
bash scripts/xv6/run-xv6-command.sh fdinfotest "fdinfotest done"
```

## 质量标准

报告应解释 fd 和 file 的层次差异，说明为什么不固定 fcount 绝对值，并覆盖 closed fd 与 bad fd 的负向检查。

## 边界条件

Lab4 不是完整文件系统实验，不讲磁盘布局、路径解析或 inode 管理。`fdinfo` 不返回路径、inode 号、宿主文件信息或文件内容。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 当前正式验证范围。

## 语言风格

使用中文技术写作风格，命令、文件名、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

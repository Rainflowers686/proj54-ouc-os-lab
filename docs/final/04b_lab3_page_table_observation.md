# 04b Lab3 Page Table Observation

## 目标

Lab3 通过 `pgcount()` 和 `memstat()` 让学生观察用户页表映射数量，并理解 `argaddr + copyout + struct ABI` 的结构体返回方式。

## 适用对象

适用于已理解 syscall 基础、准备学习页表和用户指针处理的学生。

## 内容范围

integrated 中 `SYS_pgcount = 27`，`SYS_memstat = 29`。`pgcount()` 统计当前进程 `[0, p->sz)` 范围内 `PTE_V && PTE_U` 的页映射。`memstat(struct memstat*)` 返回地址空间大小、映射页数和页大小。

## 学习重点

学生应区分进程地址空间大小与实际页表映射。eager `sbrk` 会使 mapped pages 增加，lazy allocation 在触碰前不产生实际映射。`memstat` 让学生第一次面对内核向用户缓冲区安全写回结构体。

## 验证命令

```bash
bash scripts/labctl.sh test lab3
bash scripts/xv6/run-xv6-command.sh pgcounttest "pgcounttest done"
bash scripts/xv6/run-xv6-command.sh memstattest "memstattest done"
```

## 质量标准

报告应解释 `walk(..., 0)` 为什么不分配页，为什么只统计 `PTE_V` 和 `PTE_U`，以及 bad pointer 时 copyout 应失败。

## 边界条件

Lab3 不是完整内存管理实验，不修改 page fault 策略，不返回物理地址。`memstat` 是地址空间观察接口，不是内存分配器。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 current final。

## 语言风格

使用中文技术写作风格，命令、文件名、commit、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

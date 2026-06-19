# Integrated Lab Patch Sequence

## 目标

本目录保存最终综合演示使用的 integrated patch sequence，使同一个 xv6-riscv 构建能同时运行 Lab1 到 Lab4 及进阶 copyout 实验。

## 适用对象

适用于评审、队友复现人员、助教和维护者。学生单关学习可优先使用各 lab 的 independent patch。

## 内容范围

sequence 覆盖 `0001-0009`：`hello`、`add2`、`pstate`、`pcount`、`fcount`、`pgcount`、`fdcount`、`memstat`、`fdinfo`。baseline 由 `scripts/xv6/apply-integrated-labs.sh` 声明，并由 `external/xv6-baseline-record.md` 记录元数据；本教学文档只说明复现入口。

## 结构规范

每个 patch 应有唯一顺序、教学主题、syscall number 和用户程序。新增 patch 时必须同步更新 helper、验证脚本、labctl 矩阵和文档门禁。

## Patch Map

| Patch | 内容 | syscall | 用户程序 |
| --- | --- | --- | --- |
| `0001` | `hello()` | `SYS_hello = 22` | `hello` |
| `0002` | `add2(int,int)` | `SYS_add2 = 23` | `add2test` |
| `0003` | `pstate(int)` | `SYS_pstate = 24` | `pstatetest` |
| `0004` | `pcount(int)` 与子进程观察 | `SYS_pcount = 25` | `pcounttest`、`pchildtest` |
| `0005` | `fcount()` | `SYS_fcount = 26` | `fcounttest` |
| `0006` | `pgcount()` | `SYS_pgcount = 27` | `pgcounttest` |
| `0007` | `fdcount()` | `SYS_fdcount = 28` | `fdcounttest` |
| `0008` | `memstat(struct memstat*)` | `SYS_memstat = 29` | `memstattest` |
| `0009` | `fdinfo(int, struct fdinfo*)` | `SYS_fdinfo = 30` | `fdinfotest` |

## 验证命令

```bash
bash scripts/xv6/apply-integrated-labs.sh --make --yes
bash scripts/xv6/teammate-verify.sh --full
```

## 语言风格

文档应使用“综合演示路线”和“单关教学路线”区分 integrated 与 independent patch。

## 质量标准

`scripts/check-docs-consistency.sh` 必须能确认 patch 列表、syscall 编号和验证覆盖一致。

## 边界条件

不要把 independent patch 互相叠加。不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

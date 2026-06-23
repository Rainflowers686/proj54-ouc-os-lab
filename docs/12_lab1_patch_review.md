# lab1 patch 复现审查报告（红队）

本文件是对 `patches/lab1-system-call/0001-add-hello-syscall.patch` 的内部红队复现审查，目的是验证 patch 是否能从 clean baseline 复现、文档是否诚实、证据链是否足以被评委验收。

- 审查阶段：stage2b
- 审查日期：2026-06-04
- 审查角色：严格评委 + 工程红队 + OS 实验助教
- 审查方式：在 WSL2 Ubuntu 中对被 `.gitignore` 忽略的 `external/xv6-riscv/` 做真实 clean reset + apply + make + run，未提交第三方源码与原始日志。
- 重要声明：本报告结论基于实际命令输出；原始日志默认不提交，仅摘录关键证据；AI 仅整理证据，不替代真实运行。

## 1. 总体结论

**lab1 patch 可从 clean baseline 复现，结论：通过（reproducible）。**

- `git apply --check` 对 clean baseline commit `74f84181a3404d1d6a6ff98d342233979066ebb8` 返回 exit 0（无 fuzz、无 offset、无 reject）。
- clean 全量 `make` 成功（exit 0）。
- xv6 shell 中捕获到 `hello syscall returned 2026`。
- patch 只改 lab1 必需文件，无 build artifact、日志、个人路径；syscall number 无冲突；用户态到内核态调用链完整。

红队保留意见（不影响"可复现"结论，但需在文档诚实标注）：boot/hello 证据来自 timeout 自动捕获，**不等于长期稳定性或完整人工交互测试**；patch 绑定固定 baseline commit；`riscv64-unknown-elf-gcc` 缺失（用 `riscv64-linux-gnu-gcc` 构建）；存在 linker RWX warning。

## 2. patch 修改文件列表

patch 为 `git diff` 文本格式（非 `git format-patch`，无 commit 头），应使用 `git apply`（不能用 `git am`）。

| 文件 | 改动 | 说明 |
| --- | --- | --- |
| `Makefile` | 改 | `UPROGS` 仅新增 `$U/_hello`，无其他改动 |
| `kernel/syscall.h` | 改 | 新增 `#define SYS_hello 22` |
| `kernel/syscall.c` | 改 | 新增 `extern uint64 sys_hello(void);` 与分发表项 `[SYS_hello] sys_hello` |
| `kernel/sysproc.c` | 改 | 新增 `sys_hello()`，返回 `2026` |
| `user/user.h` | 改 | 新增用户态声明 `int hello(void);` |
| `user/usys.pl` | 改 | 新增 `entry("hello");`，生成用户态 stub |
| `user/hello.c` | 新增 | 用户态测试程序，调用 `hello()` 并打印返回值 |

红队核对：以上 7 处恰好是 clean baseline 工作树应出现的全部改动，无多余文件。

## 3. syscall 调用链审查

```text
user/hello.c  main()
  -> user/user.h   声明 int hello(void)
  -> user/usys.pl  生成 usys.S 中的 hello stub（li a7, SYS_hello; ecall）
  -> ecall 触发 trap，进入内核
  -> kernel/syscall.c  syscall() 用 a7 (=22=SYS_hello) 查分发表
  -> kernel/sysproc.c  sys_hello() 返回 2026
  -> 返回值经 a0 回到用户态，printf 打印 "hello syscall returned 2026"
```

- syscall number：baseline 最大为 `SYS_close 21`，新增 `SYS_hello 22` 为下一个空号，**无冲突**。
- 返回值：`sys_hello()` 返回 `2026`，与用户态打印一致。
- 参数传递：`hello()` 无参数，未演示 `argint/argaddr`，属"最小 syscall"的有意取舍（参数传递可作为后续扩展）。

## 4. clean baseline apply 验证步骤（真实执行）

在 WSL2 Ubuntu、被忽略的 `external/xv6-riscv/` 中执行（主仓库不受影响）：

```bash
# 1) 备份当前本地状态到 /tmp（不进仓库）
git -C external/xv6-riscv add -A
git -C external/xv6-riscv diff --cached --binary > /tmp/xv6_full_backup.patch
git -C external/xv6-riscv reset -q

# 2) 恢复 clean baseline
git -C external/xv6-riscv reset --hard 74f84181a3404d1d6a6ff98d342233979066ebb8
git -C external/xv6-riscv clean -fdx
# 校验：git status --porcelain 为空 => CLEAN

# 3) 应用 patch
cd external/xv6-riscv
git apply --check ../../patches/lab1-system-call/0001-add-hello-syscall.patch   # exit 0
git apply        ../../patches/lab1-system-call/0001-add-hello-syscall.patch   # exit 0
```

真实结果：

| 步骤 | 结果 |
| --- | --- |
| clean baseline 校验 | CLEAN（工作树为空，HEAD = `74f8418`） |
| `git apply --check` | exit 0（patch 可干净应用） |
| `git apply` | exit 0 |
| 应用后文件集 | `M Makefile / syscall.c / syscall.h / sysproc.c / user.h / usys.pl` + `?? user/hello.c`，与 patch 完全一致 |

## 5. make 验证结果（真实执行）

```bash
bash scripts/xv6/check-xv6-baseline.sh --make
```

| 项目 | 结果 |
| --- | --- |
| 命令退出码 | 0（make 成功） |
| 构建方式 | clean 全量构建（先 `git clean -fdx` 后从零编译） |
| compiler / linker | `riscv64-linux-gnu-gcc` / `riscv64-linux-gnu-ld` |
| patched 目标 | `kernel/syscall.o`、`kernel/sysproc.o` 在 `-Wall -Werror` 下编译通过 |
| warning | `riscv64-linux-gnu-ld: warning: kernel/kernel has a LOAD segment with RWX permissions`（上游已知，非致命） |
| 本次日志（忽略，不提交） | `logs/xv6-make-20260604-004515.log` |

## 6. boot / hello 验证结果（真实执行）

```bash
bash scripts/xv6/boot-xv6.sh
bash scripts/xv6/run-xv6-command.sh hello "hello syscall returned 2026"
```

| 项目 | 结果 |
| --- | --- |
| baseline boot evidence | 检测到 `xv6 kernel is booting` 与 `init: starting sh`（团队记录 `logs/xv6-boot-20260604-001736.log`） |
| hello 输出 | 本次复现捕获到 `hello syscall returned 2026`（`COMMAND_EVIDENCE_FOUND`） |
| 本次 hello 日志（忽略，不提交） | `logs/xv6-command-hello-20260604-004630.log` |
| 捕获方式 | `make qemu` 在 timeout 内运行，脚本注入 `hello` 命令并 grep 预期输出 |

> 本次为**独立二次复现**：从 clean baseline 重新 apply 后构建并运行，结果与团队 stage2a 记录一致。

## 7. 原始日志策略

- 原始 `logs/*.log` 一律被 `.gitignore` 忽略，**不提交**（已验证 `git ls-files 'logs/*.log'` 为空）。
- 第三方源码 `external/xv6-riscv/` 被忽略，**不提交**（已验证 `git ls-files external/xv6-riscv` 为空）。
- 可提交证据：本报告、`docs/04_test_report.md`、`tests/lab1/README.md`、`patches/lab1-system-call/`、`external/xv6-baseline-record.md` 中的关键摘录与命令。
- 评委如需原始日志，可按第 9 节自行复现生成。

## 8. 当前风险

| 风险 | 说明 | 处理 |
| --- | --- | --- |
| timeout 自动捕获 ≠ 长期稳定 | boot/hello 证据由 timeout 内 grep 关键字得到，非长跑稳定性，也非完整人工交互 | 文档统一标注；长期稳定与人工交互列为 TODO |
| `riscv64-unknown-elf-gcc` 缺失 | 当前用 `riscv64-linux-gnu-gcc` 构建成功；xv6 Makefile 自动识别工具链前缀 | 文档说明；若改 Makefile/工具链需复验 |
| linker RWX warning | `kernel/kernel has a LOAD segment with RWX permissions`，上游已知，不阻塞 build | 在技术报告中解释，不当作错误 |
| patch 绑定固定 baseline | `git apply` 依赖 `74f8418` 的上下文；baseline 变更可能导致 apply 失败 | patch/文档显式钉死 commit；baseline 变更时重新生成并复验 |
| 单人验证 | 目前由一名成员 + AI 复现 | 第二名队员独立复核列为 TODO |

## 9. 评委复现路径

```bash
# 0) 环境：WSL2 Ubuntu，已装 qemu-system-misc 与 gcc-riscv64-linux-gnu
bash scripts/check-env.sh

# 1) 获取 baseline 到忽略目录（任选其一）
bash scripts/xv6/fetch-xv6.sh --run
#   或手动：git clone https://github.com/mit-pdos/xv6-riscv external/xv6-riscv

# 2) 钉死 baseline commit
git -C external/xv6-riscv checkout 74f84181a3404d1d6a6ff98d342233979066ebb8

# 3) 预览/应用 lab1 patch
bash scripts/xv6/apply-lab1-patch.sh            # 默认仅预览
bash scripts/xv6/apply-lab1-patch.sh --run      # clean 重置 + 应用 patch

# 4) 构建并捕获 hello 证据
bash scripts/xv6/check-xv6-baseline.sh --make
bash scripts/xv6/run-xv6-command.sh hello "hello syscall returned 2026"
```

预期：`make` 成功；输出中出现 `hello syscall returned 2026`。

## 10. 后续建议

1. 让第二名队员在另一台机器独立按第 9 节复现，记录结果（消除单人/单机偏差）。
2. lab1 增加一个带参数的 syscall 扩展（演示 `argint`），与最小版形成"基础 + 进阶"两档。
3. 在技术报告中用一段解释 linker RWX warning 的来由与无害性。
4. 若后续升级 baseline commit，更新 patch 并重跑本报告的第 4-6 节验证。
5. 长期稳定性与人工交互测试仍为 TODO，完成后补 `docs/04_test_report.md`。

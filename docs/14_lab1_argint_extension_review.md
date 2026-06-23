# lab1 argint syscall extension 复现审查

本文件记录 stage3a 对 lab1 进阶 patch 的真实复现审查。目标是确认 `0002-add-argint-add2-syscall.patch` 能在 `0001` 之后应用，并真实构建、运行。

## 基本信息

| 字段 | 内容 |
| --- | --- |
| 阶段 | stage3a |
| 日期 | 2026-06-04 |
| baseline commit | `74f84181a3404d1d6a6ff98d342233979066ebb8` |
| minimal patch | `patches/lab1-system-call/0001-add-hello-syscall.patch` |
| advanced patch | `patches/lab1-system-call/0002-add-argint-add2-syscall.patch` |
| 第三方源码 | `external/xv6-riscv/`，被 Git 忽略 |
| 原始日志 | `logs/*.log`，被 Git 忽略 |

## 设计结论

`0002` 增加 `add2(int a, int b)` syscall，用于演示 xv6-riscv 中 `argint()` 获取整数参数的机制。

预期用户输出：

```text
add2(20, 6) returned 26
```

## 修改点审查

| 文件 | 变化 |
| --- | --- |
| `kernel/syscall.h` | 新增 `SYS_add2 23`，不与 `SYS_hello 22` 冲突。 |
| `kernel/syscall.c` | 新增 `extern uint64 sys_add2(void);` 与 `[SYS_add2] sys_add2`。 |
| `kernel/sysproc.c` | 新增 `sys_add2()`，使用 `argint(0, &a)` 和 `argint(1, &b)`。 |
| `user/user.h` | 新增 `int add2(int, int);`。 |
| `user/usys.pl` | 新增 `entry("add2");`。 |
| `Makefile` | 新增 `_add2test` 到 `UPROGS`。 |
| `user/add2test.c` | 新增用户态测试程序。 |

## 真实执行记录

### 1. 初始状态检查

已运行：

```bash
git status --short
git status --ignored --short external logs
git ls-files external/xv6-riscv
git ls-files logs/*.log
bash scripts/check-env.sh
bash scripts/xv6/check-xv6-baseline.sh
bash scripts/xv6/run-xv6-command.sh hello "hello syscall returned 2026"
git diff --check
```

结果摘要：

- 主仓库初始干净。
- `external/xv6-riscv/` 未被 Git 跟踪。
- `logs/*.log` 未被 Git 跟踪。
- hello 输出仍可捕获。
- 环境中 `qemu-system-riscv64` 和 `riscv64-linux-gnu-gcc` OK，`riscv64-unknown-elf-gcc` WARN。

### 2. 开发中问题记录

- 直接在 PowerShell 工作目录执行 `make` 失败，原因是 Windows shell 找不到 `make`。后续使用 WSL/bash 执行等价构建命令并成功。
- 手写 `0002` patch 的第一次版本因 hunk 计数错误导致 `git apply` 报 `corrupt patch`。后续改用 WSL Git 基于 `0001` index 自动生成增量 patch。
- 曾混用 Windows Git 与 WSL Git，触发行尾差异风险。后续在 external xv6 子仓库设置并使用 WSL Git 流程重新生成 patch，最终 `0002` 为小型增量 patch。

以上失败均为真实过程问题，未写成成功。

### 3. clean baseline 复现

已真实执行：

```bash
git -C external/xv6-riscv reset --hard 74f84181a3404d1d6a6ff98d342233979066ebb8
git -C external/xv6-riscv clean -fdx
git -C external/xv6-riscv apply ../../patches/lab1-system-call/0001-add-hello-syscall.patch
git -C external/xv6-riscv apply ../../patches/lab1-system-call/0002-add-argint-add2-syscall.patch
```

结果：两个 patch 均成功应用。`user/usys.pl` 曾出现 file mode warning，但未阻塞 patch 应用或构建。

### 4. make 验证

已真实执行：

```bash
cd external/xv6-riscv
make
```

结果：

- `make` 成功。
- 使用 `riscv64-linux-gnu-gcc`。
- linker 仍有已知 `LOAD segment with RWX permissions` warning。

### 5. hello 回归

已真实执行：

```bash
bash scripts/xv6/run-xv6-command.sh hello "hello syscall returned 2026"
```

结果：捕获到 `hello syscall returned 2026`。

### 6. add2test 验证

已真实执行：

```bash
bash scripts/xv6/run-xv6-command.sh add2test "add2(20, 6) returned 26"
```

结果：捕获到 `add2(20, 6) returned 26`。

## 边界

- 当前只验证了 timeout 自动捕获证据，不等于长期稳定性测试。
- 当前未录制人工交互 Demo。
- 当前未完成第二名队员独立复现。
- 本轮未做 lab2/lab4。
- `external/xv6-riscv/` 和 `logs/*.log` 不提交。

## 结论

`0002-add-argint-add2-syscall.patch` 可在 clean baseline + `0001` 之后应用，且通过 `make`、hello 回归和 add2test 输出捕获。它可以作为 lab1 的进阶 syscall 参数传递实验材料。

---

## stage3b 红队补充审查

本节由 stage3b 红队（严格评委 + OS 实验助教视角）补充，目标是回答两个问题：`0002` 是否真正可独立复现，以及 lab1 现在是否够得上"教学实验体系"。

## stage3b 总体结论

- **可复现性：通过。** stage3b 独立从 clean baseline 重做了 `0001` + `0002` 序列，`git apply --check` 两次均 exit 0，clean `make` 成功，`hello` 与 `add2test` 输出均被捕获。
- **patch 增量性：通过。** `0002` 的 blob 基线索引（`f2499f5/d790a71/57abe5b/f76ffe1/de76c8c/ef380bf`）正是 `0001` 的输出 blob，证明 `0002` 是 `0001` 之上的干净增量，必须在 `0001` 后应用，无重叠、无重复。
- **教学价值：部分达成。** lab1 已是一个**诚实、可复现、有递进（无参→有参）的双档 syscall 迷你实验**，但还不是完整"教学实验体系"——缺少给学生动手的练习、负向实验、评分标准，且参数仅覆盖 `int`（未覆盖指针 `argaddr`／字符串 `argstr`）。详见下文教学价值评估。

## add2 syscall 调用链

```text
user/add2test.c  main(): add2(20, 6)
  -> user/user.h    声明 int add2(int, int)
  -> user/usys.pl   生成 usys.S 中的 add2 stub：参数已在 a0,a1；li a7, SYS_add2(23)；ecall
  -> ecall 触发 trap：uservec -> usertrap() -> syscall()
  -> kernel/syscall.c  syscall() 读 p->trapframe->a7 (=23) 查 syscalls[] 分发
  -> kernel/sysproc.c  sys_add2()
       argint(0, &a)  从 trapframe->a0 取 20
       argint(1, &b)  从 trapframe->a1 取 6
       return a + b   (=26)
  -> syscall() 把返回值写回 p->trapframe->a0
  -> 返回用户态，printf 输出 "add2(20, 6) returned 26"
```

## argint() 取参机制解释

理解 `add2` 的关键不是"它能加法"，而是**内核如何拿到用户态传入的参数**：

1. **用户态传参**：RISC-V 调用约定下，`add2(20, 6)` 的两个整数在进入 stub 时已位于寄存器 `a0`、`a1`。`usys.pl` 生成的 stub 只把系统调用号写入 `a7` 然后 `ecall`，并不重新搬运 `a0/a1`。
2. **trap 保存现场**：`ecall` 进入内核后，trap 代码把用户寄存器（含 `a0`–`a5`、`a7`）保存到当前进程的 `trapframe`。
3. **内核取号分发**：`syscall()` 读 `trapframe->a7` 得到 `SYS_add2`，调用 `sys_add2()`。
4. **argint 读参**：`argint(n, &ip)` 内部经 `argraw(n)` 返回 `trapframe` 中第 `n` 个参数寄存器（`n=0` → `a0`，`n=1` → `a1`…），再按 `int` 取出。因此 `argint(0,&a)` 得 20、`argint(1,&b)` 得 6。
5. **本 baseline 的细节**：此 xv6-riscv 版本中 `argint` 返回 `void`（寄存器参数恒存在，无需检查失败）；指针/字符串参数应改用 `argaddr`／`argstr`，这正是 lab1 下一步可扩展的教学点。

教学要点：`add2` 把"参数从用户寄存器经 trapframe 到内核"的链路具体化，是从 `hello`（无参）到真实 syscall（带参、带指针）的关键过渡。

## stage3b 独立复现结果（真实执行，未伪造）

在 WSL2 Ubuntu、被忽略的 `external/xv6-riscv/` 中独立重做（主仓库不受影响）：

```bash
git -C external/xv6-riscv reset --hard 74f84181a3404d1d6a6ff98d342233979066ebb8
git -C external/xv6-riscv clean -fdx
( cd external/xv6-riscv && git apply --check ../../patches/lab1-system-call/0001-add-hello-syscall.patch && git apply ../../patches/lab1-system-call/0001-add-hello-syscall.patch )
( cd external/xv6-riscv && git apply --check ../../patches/lab1-system-call/0002-add-argint-add2-syscall.patch && git apply ../../patches/lab1-system-call/0002-add-argint-add2-syscall.patch )
bash scripts/xv6/check-xv6-baseline.sh --make
bash scripts/xv6/run-xv6-command.sh hello "hello syscall returned 2026"
bash scripts/xv6/run-xv6-command.sh add2test "add2(20, 6) returned 26"
```

| 步骤 | 结果 |
| --- | --- |
| clean baseline 校验 | CLEAN（HEAD = `74f8418`） |
| `0001` `git apply --check` / apply | exit 0 / exit 0 |
| `0002` `git apply --check` / apply | exit 0 / exit 0（在 `0001` 之后） |
| 合并文件集 | `M Makefile/syscall.c/syscall.h/sysproc.c/user.h/usys.pl` + `?? user/hello.c` + `?? user/add2test.c` |
| `syscall.h` 尾部 | `SYS_hello 22`、`SYS_add2 23`（无冲突） |
| clean `make` | 成功（exit 0；仅已知 `LOAD segment with RWX permissions` 警告） |
| `hello` 输出 | 捕获 `hello syscall returned 2026`（`COMMAND_EVIDENCE_FOUND`） |
| `add2test` 输出 | 捕获 `add2(20, 6) returned 26`（`COMMAND_EVIDENCE_FOUND`） |
| 本次日志（忽略，不提交） | `logs/xv6-make-20260604-081018.log`、`logs/xv6-command-add2test-20260604-081330.log` 等 |

## 教学价值评估（stage3b 重点）

严格评价 lab1 当前作为"教学材料"的成色，而非只看"能不能跑"。

**已具备的教学要素（真实加分项）：**

- **递进结构**：`hello`（无参最小闭环）→ `add2`（`argint` 参数传递），覆盖 syscall number、用户态 stub、trap/dispatch、参数读取、返回值五个关键点。
- **可复现**：固定 baseline commit + 有序增量 patch + 自动证据捕获脚本，学生/评委可从零复现。
- **诚实边界**：自动捕获 ≠ 长期稳定/人工交互，文档明确标注，符合教学诚信。
- **排错支架**：lab1 README 的"常见错误"表把 syscall 号冲突、stub 缺失、参数序号错误等列出，具备 TA 讲解价值。

**距离"教学实验体系"仍缺的要素（红队判定，需诚实承认）：**

1. **缺学生动手任务**：目前给的是完整答案 patch，缺"留白让学生实现"的版本（如给出骨架，让学生自己补 `sys_add2`）。
2. **缺负向/失败实验**：有错误清单但无"故意制造并修复"的引导实验（如故意漏 `entry("add2")` 观察现象）。
3. **参数维度单一**：只演示 `int`（`argint`），未覆盖指针 `argaddr`、字符串 `argstr`，而后者是真实 syscall 的常见需求。
4. **测试用例单一**：仅 `add2(20,6)`，无边界用例（负数、0、溢出）培养健壮性意识。
5. **缺评分/验收标准**：教学体系需要"学生作业如何被评判"的 rubric。

结论：lab1 是一个**合格的、可复现的双档 syscall 教学 demo + 参考实现**，但要成为"实验体系"，下一步应补"学生任务 + 负向实验 + 指针/字符串参数 + 评分标准"。这些属于设计中/TODO，不在本轮声称完成。

## 当前不足（明确 TODO）

- 仍是最小参数实验，不是完整进程/调度实验，也未覆盖全部 syscall 参数机制。
- timeout 自动捕获不是长期稳定性测试。
- 第二名队员独立复现：TODO。
- 人工交互录屏：TODO。
- 学生练习版、负向实验、指针/字符串参数、评分标准：设计中/TODO。

## 评委复现路径

```bash
# WSL2 Ubuntu，已装 qemu-system-misc 与 gcc-riscv64-linux-gnu
bash scripts/check-env.sh
bash scripts/xv6/fetch-xv6.sh --run            # 或手动 clone 到 external/xv6-riscv
git -C external/xv6-riscv reset --hard 74f84181a3404d1d6a6ff98d342233979066ebb8
git -C external/xv6-riscv clean -fdx
( cd external/xv6-riscv && git apply ../../patches/lab1-system-call/0001-add-hello-syscall.patch )
( cd external/xv6-riscv && git apply ../../patches/lab1-system-call/0002-add-argint-add2-syscall.patch )
bash scripts/xv6/check-xv6-baseline.sh --make
bash scripts/xv6/run-xv6-command.sh hello "hello syscall returned 2026"
bash scripts/xv6/run-xv6-command.sh add2test "add2(20, 6) returned 26"
```

预期：两个 patch 顺序应用成功；`make` 成功；输出中分别出现 `hello syscall returned 2026` 与 `add2(20, 6) returned 26`。

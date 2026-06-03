# lab1：系统调用实验设计

## 实验目标

lab1 的目标是帮助学生理解系统调用从用户态到内核态的完整路径：用户程序发起调用，进入 trap 处理流程，内核根据 syscall number 查表分发，执行内核实现，再将结果返回用户态。

本轮只完成实验设计，不写“已完成实现”。实际代码需要在后续引入 xv6-riscv baseline 后完成并验证。

## 前置知识

- user/kernel：用户态和内核态的边界。
- syscall number：系统调用号及其分发作用。
- trap：用户态进入内核态的机制。
- argument passing：系统调用参数传递和读取方式。
- xv6-riscv 基本目录结构：TODO，待引入 baseline 后根据实际版本验证。

## 实验任务草案

后续计划添加一个简单系统调用，例如：

- `hello()`：返回固定值或打印受控信息，用于理解最小 syscall 链路。
- trace-like minimal syscall：记录或控制简单的系统调用行为。

最终系统调用名称、参数和返回值待确认。任务拆分如下：

1. 修改用户态声明。
   - TODO：根据 xv6-riscv baseline 确认应修改的用户头文件和生成脚本。
2. 修改系统调用号。
   - TODO：新增 syscall number，避免与已有编号冲突。
3. 修改 syscall 分发表。
   - TODO：将 syscall number 映射到内核处理函数。
4. 添加内核实现。
   - TODO：实现最小功能，并明确参数和返回值。
5. 添加用户态测试程序。
   - TODO：编写用户程序调用新 syscall。
6. 修改构建配置。
   - TODO：将测试程序加入 Makefile 或对应构建入口。
7. 记录错误排查过程。
   - TODO：记录编译错误、运行错误和修复过程。

## 预期产物

- 代码 diff：新增或修改的用户态声明、系统调用号、分发表、内核实现、测试程序和构建配置。
- 测试程序：用于触发新系统调用。
- 运行输出：真实执行后记录，不得提前伪造。
- 错误排查记录：包括现象、原因、修复方式和关联 commit。

## 测试方式

后续引入 xv6-riscv baseline 后，测试流程计划为：

1. 编译检查。
   - TODO：运行实际构建命令。
2. 启动 xv6。
   - TODO：运行 QEMU 启动命令。
3. 运行用户测试程序。
   - TODO：记录程序名、输入和输出。
4. 保存测试证据。
   - TODO：将命令、输出和结论写入 docs/04_test_report.md 或对应测试记录。

当前不执行 xv6 构建或运行，因此没有测试通过记录。

## 常见错误

| 问题 | 可能原因 | 处理建议 |
| --- | --- | --- |
| syscall number 冲突 | 新编号与已有系统调用重复 | TODO：对照 baseline 中 syscall 编号表检查 |
| 用户态声明遗漏 | 用户程序找不到 syscall 声明 | TODO：检查用户头文件和 syscall 生成入口 |
| Makefile 未加入测试程序 | 用户程序未被构建进 xv6 文件系统 | TODO：确认测试程序加入构建列表 |
| 参数传递错误 | 内核读取参数方式不正确 | TODO：阅读 xv6-riscv 参数读取函数并补充说明 |
| 返回值异常 | 内核函数返回值或用户态封装不一致 | TODO：统一设计返回类型和错误语义 |

## 最小 syscall 实现前置检查清单

在动手实现前，先确认以下条件全部满足（未满足项写明阻塞点）：

- [ ] lab0 环境已真实跑通：xv6-riscv 能构建并启动（见 [../lab0-env-setup/README.md](../lab0-env-setup/README.md) 真实验证记录）。
- [ ] 已确认 xv6-riscv baseline 的来源、commit 与许可证，并记录在 [../../docs/08_reference_and_license.md](../../docs/08_reference_and_license.md)。
- [ ] 已能在 baseline 中定位用户态系统调用声明文件、syscall 号定义、分发表和内核实现文件（具体文件名待 baseline 引入后确认）。
- [ ] 已选定最小 syscall 目标（如 `trace`、`getppid` 或受控 `hello`），并确定参数与返回值语义。
- [ ] 已规划用户态测试程序的位置与构建入口。
- [ ] 已准备好测试记录位置（[../../docs/04_test_report.md](../../docs/04_test_report.md) 或 `tests/lab1/`）。

> 说明：以上清单为实现前置条件，**当前均待 xv6-riscv baseline 引入后逐项核对**，不代表已满足。

## 代码修改点清单（待 baseline 引入后验证）

下表列出新增一个最小 syscall 通常需要改动的位置。**文件名为基于一般 xv6-riscv 结构的预期，必须在真实 baseline 引入后核对并修正**，不得当作既成事实。

| 修改点 | 预期文件（待核对） | 修改内容 | 验证状态 |
| --- | --- | --- | --- |
| 用户态系统调用声明 | `user/user.h`（待核对） | 声明新 syscall 的用户态原型 | TODO：待 baseline 验证 |
| 用户态汇编入口生成 | `user/usys.pl` 或等价生成入口（待核对） | 注册新 syscall 的用户态入口 | TODO：待 baseline 验证 |
| 系统调用号定义 | `kernel/syscall.h`（待核对） | 新增不与已有冲突的 syscall number | TODO：待 baseline 验证 |
| 系统调用分发表 | `kernel/syscall.c`（待核对） | 把 syscall number 映射到内核处理函数 | TODO：待 baseline 验证 |
| 内核实现 | `kernel/sysproc.c` 或新增文件（待核对） | 实现最小功能，明确参数读取与返回值 | TODO：待 baseline 验证 |
| 用户态测试程序 | `user/<test>.c`（待核对） | 编写调用新 syscall 的测试程序 | TODO：待 baseline 验证 |
| 构建配置 | `Makefile`（待核对） | 把测试程序加入 UPROGS 或等价构建列表 | TODO：待 baseline 验证 |

> 提醒：上表「预期文件」仅用于规划，真实 xv6-riscv 不同版本的文件名与生成机制可能不同；引入 baseline 后必须逐行核对并把「验证状态」更新为真实结论（参见 [../../docs/10_red_team_review.md](../../docs/10_red_team_review.md)）。

## 当前状态

设计初版，待引入 xv6-riscv baseline 后实现和验证；前置检查清单与代码修改点清单已就位，文件名待真实核对。

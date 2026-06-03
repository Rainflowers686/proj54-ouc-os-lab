# 复现包 README

本目录用于整理 lab0/lab1 当前工程闭环的复现流程。复现目标是让队友或评委从清晰步骤开始，验证环境、baseline、patch、build、boot evidence 和 hello 输出。

当前状态：

- 队长 / agent 本地复现已完成。
- stage2b clean baseline patch reproducibility review 已完成，见 `docs/12_lab1_patch_review.md`。
- 第二名队员独立复现：TODO。

## 复现目标

1. 检查本机环境。
2. 获取 xv6-riscv baseline。
3. 应用 lab1 hello syscall patch。
4. 运行 `make`。
5. 捕获 boot evidence。
6. 捕获 `hello syscall returned 2026` 输出。
7. 如失败，记录真实失败原因，不伪造成功。

## 复现前提

推荐环境：

- WSL2 Ubuntu 24.04 或 Linux。
- `git`
- `bash`
- `make`
- `qemu-system-riscv64`
- `riscv64-linux-gnu-gcc`

当前环境中 `riscv64-unknown-elf-gcc` 为 WARN，但 `riscv64-linux-gnu-gcc` 已可完成当前 xv6 构建。复现时应记录自己的工具链状态。

## 复现路径 A：使用现有脚本

在仓库根目录运行：

```bash
bash scripts/check-env.sh
bash scripts/xv6/fetch-xv6.sh --run
bash scripts/xv6/apply-lab1-patch.sh --run --make
bash scripts/xv6/boot-xv6.sh
bash scripts/xv6/run-xv6-command.sh hello "hello syscall returned 2026"
```

说明：

- `fetch-xv6.sh --run` 会 clone baseline 到 `external/xv6-riscv/`。
- `external/xv6-riscv/` 被 Git 忽略，不提交第三方源码。
- `apply-lab1-patch.sh --run --make` 会在 ignored 的 external tree 中 reset 到 baseline commit、clean、apply patch 并运行 make。
- `boot-xv6.sh` 只捕获 boot evidence，不代表长期稳定性测试。
- `run-xv6-command.sh` 使用 timeout 捕获 hello 输出，不代表人工交互录屏。

## 复现路径 B：手动复现

```bash
cd external/xv6-riscv
git reset --hard 74f84181a3404d1d6a6ff98d342233979066ebb8
git clean -fdx
git apply ../../patches/lab1-system-call/0001-add-hello-syscall.patch
make
make qemu
```

进入 xv6 shell 后输入：

```text
hello
```

预期输出：

```text
hello syscall returned 2026
```

手动退出 QEMU：

```text
Ctrl-a
x
```

## 复现记录模板

| 字段 | 内容 |
| --- | --- |
| 复现人 | TODO |
| 日期 | TODO |
| 机器环境 | TODO |
| WSL/Linux 版本 | TODO |
| 工具链状态 | TODO |
| 执行命令 | TODO |
| 结果 | TODO |
| 失败原因 | TODO，如未失败写“无” |
| 是否提交给队长核验 | TODO |
| 备注 | TODO |

## 禁止事项

- 不伪造成功。
- 不提交 `external/xv6-riscv/`。
- 不提交 `logs/*.log`。
- 不上传报名材料、个人隐私、账号密码、token、截图原件或大型二进制文件。
- 不把自动 timeout 捕获写成人工录屏或长期稳定性测试。

## 后续 TODO

- TODO: 第二名队员在另一台机器独立复现。
- TODO: 将复现结果摘要补充到 `docs/04_test_report.md` 或单独复现记录中。
- TODO: 失败时补充 FAQ 和 issue 记录。

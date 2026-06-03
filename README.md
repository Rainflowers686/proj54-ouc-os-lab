# proj54-ouc-os-lab

## 赛事与赛题信息

- 比赛名称：2026 全国大学生计算机系统能力大赛 OS 功能挑战赛
- 赛题编号：proj54
- 赛题名称：面向操作系统课程的操作系统竞赛和实验
- 赛题类型：教学型
- 当前阶段：初赛 MVP；xv6-riscv baseline 已引入并构建，lab1 最小 hello syscall 已通过 clean baseline 复现验证

## 队伍信息

- 学校：中国海洋大学
- 队伍：蓝色系统队
- 队内分工：TODO，持续维护在 [docs/00_project_plan.md](docs/00_project_plan.md)

## 代码仓库与提交说明

- 官方比赛主仓库（最终提交以此为准）：GitLab `origin`。
- 私有协作备份仓库：GitHub `github`，仅用于备份、协作和 issue 管理，**不是最终提交平台**。
- 两个 remote 同时存在，推送时需分别 `git push origin main` 与 `git push github main`，详见 [docs/09_github_workflow.md](docs/09_github_workflow.md)。
- 仓库不提交报名材料、个人隐私、账号密码、token、截图原件或大型二进制文件。

## 评委快速查看路径

为便于快速评审，建议按以下顺序查看：

1. 项目首页与定位：[README.md](README.md)
2. 赛题拆解与评分项对应：[docs/01_requirement_analysis.md](docs/01_requirement_analysis.md)
3. 项目计划与里程碑：[docs/00_project_plan.md](docs/00_project_plan.md)
4. lab0 环境与 baseline 验证：[labs/lab0-env-setup/README.md](labs/lab0-env-setup/README.md)
5. lab1 最小 hello syscall 实验：[labs/lab1-system-call/README.md](labs/lab1-system-call/README.md)
6. lab1 patch 与应用说明：[patches/lab1-system-call/README.md](patches/lab1-system-call/README.md)
7. lab1 patch 复现审查报告：[docs/12_lab1_patch_review.md](docs/12_lab1_patch_review.md)
8. 测试报告（真实证据摘要）：[docs/04_test_report.md](docs/04_test_report.md)
9. AI 使用记录：[docs/05_ai_usage_record.md](docs/05_ai_usage_record.md)
10. 引用与许可证：[docs/08_reference_and_license.md](docs/08_reference_and_license.md)
11. 内部红队审查报告：[docs/10_red_team_review.md](docs/10_red_team_review.md)
12. 初赛材料索引：[submissions/draft-report-index.md](submissions/draft-report-index.md)

## 项目定位

本项目面向中国海洋大学低年级计算机学生，建设一套 OS 竞赛入门实验体系。项目暂定以 xv6-riscv 为主线，参考 rCore/uCore 课程资源的组织方式，构建从环境配置、系统调用、进程与调度、页表与内存、文件系统到最终集成的 step by step 实验教程、代码框架、测试用例、参考实现、FAQ 和过程记录。

这样设计的原因是：proj54 属于教学型赛题，最终评价目标不是单纯追求实现难度，而是形成适合本校学生学习、复现和继续扩展的实验体系。因此本仓库强调：

- 可复现：环境、命令、依赖和问题记录尽量清晰。
- 可验证：实验任务需要配套测试方式和真实执行记录。
- 可扩展：lab0-lab5 保持模块化，后续可逐步增加实验深度。
- 可传承：面向后续同学保留教程、FAQ、过程记录和引用说明。

## 当前状态

下表反映真实进度，已验证项均有日志/命令证据；自动捕获的证据不等于长期稳定或完整人工交互测试。

| 模块 | 状态 | 说明 |
| --- | --- | --- |
| scaffold | 已完成 | 已建立 README、docs、labs、scripts、tests、references、slides、videos、submissions 等目录 |
| xv6-riscv baseline | 已引入（不提交源码） | commit `74f84181a3404d1d6a6ff98d342233979066ebb8`；源码在被 `.gitignore` 忽略的 `external/xv6-riscv/`，仓库只提交 patch 与 metadata |
| lab0 环境与 baseline | 已真实验证 | WSL2 Ubuntu 工具链 OK；baseline `make` 成功；boot evidence 捕获到 `xv6 kernel is booting` 与 `init: starting sh`（timeout 自动捕获） |
| lab1 最小 hello syscall | patch 已复现验证 | `patches/lab1-system-call/` 中 patch 可从 clean baseline `git apply` 成功、`make` 成功、捕获到 `hello syscall returned 2026`；属最小 syscall 闭环，非完整实验体系 |
| xv6 脚本 | 可运行 | `scripts/xv6/` 提供 fetch/check/boot/run 与 apply 脚本，原始日志写入被忽略的 `logs/` |
| lab2-lab5 / 教学正文 | 占位/计划中 | `docs/03`、lab2-lab5 仍为模板或 TODO |
| 技术报告 / PPT / Demo | TODO | 初赛报告索引见 `submissions/draft-report-index.md` |

## 当前未完成事项

为避免夸大，明确列出当前**尚未完成**的关键事项（详见 [docs/10_red_team_review.md](docs/10_red_team_review.md) 与 [docs/12_lab1_patch_review.md](docs/12_lab1_patch_review.md)）：

- lab1 仅为最小 `hello()` syscall 闭环，未演示参数传递等进阶内容；lab2-lab5 与 `docs/03_step_by_step_guide.md` 仍为占位或 TODO。
- 长期 QEMU 稳定性测试、人工交互 shell 测试、负向测试、第二名队员独立复核均为 TODO。
- 队内分工尚未具名。
- 仓库根目录尚无自有 LICENSE 文件，待团队确认开源许可后补充。
- 技术报告、PPT、Demo 视频均为 TODO。
- 创新性落地物（如海大特色一键自检/自动评分）仍较薄。

> 注意：xv6-riscv 第三方源码（`external/xv6-riscv/`）与原始日志（`logs/*.log`）按策略不提交；可提交的 lab1 产物是 patch 与复现文档。

## 仓库目录说明

```text
docs/                         项目计划、赛题拆解、实验设计、测试报告、AI 使用记录、进度日志
labs/lab0-env-setup/          lab0：环境搭建与工具链检查
labs/lab1-system-call/        lab1：系统调用实验设计
labs/lab2-process-and-scheduling/
                              lab2：进程与调度观察实验
labs/lab3-memory-and-pagetable/
                              lab3：页表与内存观察实验
labs/lab4-file-system/        lab4：文件系统实验
labs/lab5-final-integration/  lab5：最终集成与报告
scripts/                      环境检查、实验入口提示、材料索引收集脚本
tests/lab1/                   lab1 测试设计与未来测试用例记录
tests/lab2/                   lab2 测试设计与未来测试用例记录
tests/lab3/                   lab3 测试设计与未来测试用例记录
tests/lab4/                   lab4 测试设计与未来测试用例记录
references/                   参考资料清单与许可证记录
slides/                       PPT 或展示材料说明，当前 TODO
videos/                       Demo 视频脚本或链接说明，当前 TODO，不提交大型视频文件
submissions/                  初赛材料索引与提交说明，不存放报名材料或隐私信息
```

## 快速开始

当前快速开始仅覆盖仓库文档和最小脚本，不代表 xv6-riscv 已经跑通。

1. 克隆仓库。

   ```bash
   git clone <repo-url>
   cd proj54-ouc-os-lab
   ```

2. 运行环境预检查脚本。

   ```bash
   bash scripts/check-env.sh
   ```

3. 查看 lab0/lab1 文档。

   ```bash
   bash scripts/run-lab.sh lab0
   bash scripts/run-lab.sh lab1
   ```

4. 生成或更新初赛材料索引草案。

   ```bash
   bash scripts/collect-report.sh
   ```

注意：当前脚本不会构建、启动或测试 xv6-riscv。后续引入 baseline 后，需要补充真实运行命令和测试记录。

## 协作规范

- 小步提交：文档、脚本、测试和代码变更尽量拆分提交。
- commit message 建议使用 `type: summary` 格式，例如 `docs: refine MVP plan and lab0 lab1 documentation`。
- 每 1-2 天至少形成一次有效 commit，优先提交可复核的文档、脚本或真实验证记录。
- 不上传报名材料、个人隐私、账号密码、token、截图原件或大型二进制文件。
- 不伪造实验结果、运行截图、测试通过记录、真实 commit hash 或真实视频链接。
- 所有未真实验证内容必须标注 `TODO`、`待验证` 或 `计划中`。
- 引用外部资料时必须记录来源、许可证、使用位置和改造说明。

## AI 工具使用说明

AI 辅助使用记录统一维护在 [docs/05_ai_usage_record.md](docs/05_ai_usage_record.md)。AI 可用于生成草稿、整理结构、检查文档和脚本，但不能替代人工复核，不能将未执行内容写成真实结果。

## 引用与许可证说明

参考资料和许可证记录统一维护在 [docs/08_reference_and_license.md](docs/08_reference_and_license.md)。当前尚未引入第三方源码；后续若引入 xv6-riscv baseline，必须保留原许可证与来源说明。

# Submission Checklist

> 维护时间：2026-06-07（stage10c final defense PPT and pre-submission materials）。
> 本 checklist 面向最终提交前自查，不包含报名信息、个人隐私、token、视频文件或大文件。

## 1. 平台提交合规

| 检查项 | 状态 | 说明 |
| --- | --- | --- |
| 官方主仓库 | 待最终确认 | 最终以比赛 GitLab / 平台要求为准，不修改 remote |
| GitHub 使用边界 | 已说明 | GitHub 仅作私有备份/协作，不作为最终提交平台 |
| 报名材料 | 禁止入库 | 姓名、学号、手机号、身份证等不进 Git |
| 视频文件 | 禁止入库 | `0001-0007` 视频（historical stable checkpoint，只覆盖 `0001-0007`）与 3 段 historical 视频元数据已记录到 `submissions/demo_record.md`；覆盖 `0001-0009`（含 memstat/fdinfo）的新视频与新 SHA256 为 TBD；平台提交方式和最终隐私复核待确认 |
| 大文件/压缩包/截图 | 禁止入库 | `.mp4/.mov/.zip/.7z/.rar/.png/.jpg` 等均禁止提交 |

## 2. Git 仓库卫生

| 检查项 | 期望 |
| --- | --- |
| `external/xv6-riscv/` | ignored，不被 `git ls-files` 跟踪 |
| `logs/*.log` | ignored，不被跟踪 |
| `logs/*.summary.txt` | ignored，不被跟踪 |
| `.claude/`、`.vscode/` | ignored，不被跟踪 |
| integrated patches | 当前为 `patches/integrated-labs/0001-0009`；`0006` pgcount，`0007` fdcount，`0008` memstat（`SYS_memstat 29`），`0009` fdinfo（`SYS_fdinfo 30`）；不得修改 `0001-0007` 内容 |
| remote | 不修改 GitLab/GitHub remote |

## 3. 工程复现

| 项目 | 命令 | 当前状态 |
| --- | --- | --- |
| 环境诊断 | `bash scripts/xv6/doctor.sh` | PASS；可能有可接受 WARN |
| clean apply + make | `bash scripts/xv6/apply-integrated-labs.sh --make --yes` | PASS |
| boot evidence | `bash scripts/xv6/boot-xv6.sh` | PASS |
| Lab3 integrated pgcount | `bash scripts/xv6/run-xv6-command.sh pgcounttest "pgcounttest done"` | PASS；已进入 integrated `0006` |
| Lab4 fdcount | `bash scripts/xv6/run-xv6-command.sh fdcounttest "fdcounttest done"` | PASS；已进入 integrated `0007` |
| Lab3 进阶 memstat | `bash scripts/xv6/run-xv6-command.sh memstattest "memstattest done"` | PASS；stage11b 已进入 integrated `0008`（`SYS_memstat 29`）；队长本机 `local-verify --full` 已验证；非完整内存管理 |
| Lab4 进阶 fdinfo | `bash scripts/xv6/run-xv6-command.sh fdinfotest "fdinfotest done"` | PASS；stage11b 已进入 integrated `0009`（`SYS_fdinfo 30`）；队长本机 `local-verify --full` 已验证；非完整文件系统 |
| 一键 full 验证 | `bash scripts/xv6/teammate-verify.sh --full` | historical：`e8e2fb9` 队长本机、root、z2996 full verification 均 PASS（只覆盖 `0001-0007`）；TBD：含 memstat/fdinfo 的 `0001-0009` 队友 full verify 尚未进行，不得伪造 |
| 本地录屏前预检 | `bash scripts/xv6/local-verify.sh --quick` | 队长本机 `0001-0009` full PASS 已完成；录屏前仍推荐 quick |
| QEMU cleanup | `bash scripts/xv6/cleanup-qemu.sh` | 可用 |

## 4. 文档材料

| 文档 | 路径 | 状态 |
| --- | --- | --- |
| 评委入口 README | `README.md` | stage8a 已重构 |
| 正式文档入口 | `docs/final/` | stage8a 已新增正式初版 |
| 测试覆盖表 | `docs/final/06_testing_and_verification.md` | 已包含 doctor/baseline/boot/用户程序/pgcount/fdcount/memstat/fdinfo/local/teammate/manual demo |
| Lab3 patch | `patches/lab3-memory-and-pagetable/0001-add-pgcount-syscall.patch` 与 integrated `0006` | 已生成并本机验证 |
| AI 使用声明 | `docs/final/09_ai_usage_and_contribution_statement.md` | 已补充 |
| 引用与许可证声明 | `docs/final/10_reference_and_license_statement.md` | 已补充 xv6 MIT 与参考项目待核对项 |
| 已知限制 | `docs/final/11_known_limits_and_future_work.md` | 已补充 |
| 技术报告 v1.0 | `docs/final/technical_report_v1.0.md` | 已形成 judge-facing 草案 |
| PPT 大纲 | `slides/final_ppt_outline.md` | 已形成 15 页答辩结构草案 |
| PPT 源稿 | `slides/final_ppt.md` | 已形成 16 页正式答辩源稿 |
| PPT 生成器 | `slides/generate_final_ppt.py` | 使用 Python 标准库生成 PPTX；不嵌入视频、截图或 raw logs |
| PPT 成稿 | `slides/final_defense_ppt.pptx` | 已生成；16:9；16 张 slide 与 16 份 speaker notes；`63,695 bytes`；无 `ppt/media/` 文件；仍需人工最终审阅和排练 |
| 材料索引 | `submissions/draft-report-index.md` | 由 `scripts/collect-report.sh` 生成 |
| 最终证据 manifest | `submissions/evidence_manifest.md` | 已记录 integrated `0001-0009` 边界、`e8e2fb9 / 0001-0007` historical stable checkpoint、新 final commit/verification/video/SHA256 TBD、外部目录和 non-committed evidence policy |
| docs 导引 | `docs/README.md` | 已说明正式文档与过程文档边界 |
| 队友复现记录 | `submissions/teammate_reproduction_record.md` | `e8e2fb9` lead/root/z2996 full PASS 记录为 historical `0001-0007` checkpoint；含 memstat/fdinfo 的 `0001-0009` 队友 full verify 为 TBD；旧 `1ba9db6` 记录为 historical evidence |

## 5. 视频记录

| 检查项 | 状态 |
| --- | --- |
| `0001-0007` 视频（historical stable checkpoint） | 已记录大小、时长、分辨率、帧率和 SHA256；只覆盖 `0001-0007` |
| `0001-0009` 新视频（含 memstat/fdinfo） | TBD：尚未录制；须重新录制并登记新 SHA256，不得伪造 |
| historical 视频 3 段 | 已记录为 earlier `0001-0005` / stage7-stage8 evidence |
| 视频文件不入库 | 必须保持 |
| 视频文件名 | 已记录 |
| 视频时长 | final 与 historical 视频均已记录 |
| 外部存放位置 | 已记录 |
| 平台提交方式 | 待补充 |
| 隐私/token/密码检查 | pending final manual review |

记录文件：`submissions/demo_record.md`。

## 6. 队友复现

| 检查项 | 状态 |
| --- | --- |
| 队友使用命令 | `bash scripts/xv6/teammate-verify.sh --full` |
| copy-to-lead summary | `e8e2fb9` root 与 z2996 full PASS 已记录为 historical `0001-0007` checkpoint；含 memstat/fdinfo 的 `0001-0009` 队友 full verify 为 TBD；旧 `1ba9db6` 只作 historical evidence |
| 失败时 cleanup 流程 | `bash scripts/xv6/cleanup-qemu.sh` |
| 是否伪造队友结果 | 禁止；未知姓名/系统版本保持待补充 |

记录文件：`submissions/teammate_reproduction_record.md`。

## 7. 红队审核

提交前至少检查：

- README 是否是评委入口，而不是开发流水账。
- `docs/final/` 是否覆盖项目概述、环境、每个 lab、测试、队友复现、设计取舍、AI、许可证、限制。
- 是否仍把 timeout 捕获夸大成长期稳定性。
- 是否把 fcount/fdcount 夸大成完整文件系统。
- 是否把 pgcount 夸大成完整内存管理实验。
- 是否把旧队友 summary 写成 final `e8e2fb9` 复现。
- 是否把 `e8e2fb9 / 0001-0007` 三方 full PASS 写成已覆盖 `0001-0009`（含 memstat/fdinfo）；旧三方 PASS 只覆盖 `0001-0007`。
- 是否把 memstat 夸大成完整内存管理，或把 fdinfo 夸大成完整文件系统。
- 是否把本机验证写成队友复现。
- 是否存在 external/logs/.claude/video/隐私材料入库风险。

## 8. 最终提交前命令

```bash
bash scripts/collect-report.sh
git diff --check
git status --short
git status --ignored --short external logs .claude
git ls-files external/xv6-riscv
git ls-files logs/*.log
git ls-files logs/*.summary.txt
git ls-files logs/*.console.txt
git ls-files .claude
git ls-files | grep -Ei '\.(mp4|mov|avi|mkv|zip|7z|rar|png|jpg|jpeg)$' || true
```

如需重新验证工程：

```bash
bash scripts/xv6/doctor.sh
bash scripts/xv6/teammate-verify.sh --full
```

## 9. 当前剩余待补充

- integrated `0001-0009`（含 memstat/fdinfo）的 rain/root/z2996 三方 full verify 重新复现，以及新 commit hash 登记（当前 TBD）。
- 覆盖 `0001-0009` 的新演示视频录制与新 SHA256 登记（当前 TBD，不得伪造）。
- 队友真实姓名和系统版本（如最终材料需要）。
- 平台提交方式和最终隐私复核结论。
- PPT 人工最终审阅和答辩排练。
- uCore/rCore/YatSen OS/F-Tutorials/往届资料的最终 URL 与许可证核对。

## 10. 结论

当前工程功能、验证链、`e8e2fb9 / 0001-0007` lead/root/z2996 full PASS 摘要（historical stable checkpoint）、`0001-0007` 视频元数据和 SHA256、技术报告 v1.0、PPT 源稿和 PPTX 成稿已经形成提交证据基础；stage11b 已把 integrated 扩展为 `0001-0009`（新增 memstat `0008` / fdinfo `0009`）并在队长本机 `local-verify --full` overall PASS。冲奖前仍必须完成 integrated `0001-0009` 的 rain/root/z2996 三方 full verify 重新复现、新视频录制与新 SHA256 登记（当前 TBD）、PPT 人工最终审阅/排练、平台提交方式确认、最终隐私复核、引用 URL/许可证核对和最终红队审核。

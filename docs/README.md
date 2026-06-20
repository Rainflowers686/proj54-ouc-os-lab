# docs 文档导航

## 目标

本目录提供 OUC xv6 Lab Kit 的课程说明、正式提交材料、复现说明、教师材料、阶段审查和历史记录。读者不应从 `00` 顺序读到 `25`，而应按身份进入对应路径。

## 适用对象

学生优先阅读根目录 `README.md`、`docs/final/01_environment_setup.md`、各 `labs/<lab>/README.md` 和 `student_tasks.md`。教师和助教优先阅读 `teacher_guide.md`、`grading_and_rubric.md` 与 `troubleshooting.md`。评审和队友复现人员优先阅读 `docs/final/technical_report_v1.0.md`、`docs/final/06_testing_and_verification.md` 和 `submissions/evidence_manifest.md`。

## 内容范围

正式文档位于 `docs/final/`，覆盖项目概述、环境、Lab0-Lab5、测试验证、队友复现、设计取舍、AI 使用、许可证和已知限制。顶层 `docs/00` 到 `docs/25` 是开发过程、审查、计划和历史记录，保留用于追溯决策，不作为学生首次学习路线。

`docs/documentation_standard.md` 是本目录的写作规范，规定目标、适用对象、结构规范、语言风格、质量标准和边界条件。后续新增文档应先对照该规范，再进入正式提交材料或历史记录层。

## 推荐阅读路径

新手按根 `README.md` 的 Lab0 到 Lab5 路线学习。已经能启动 xv6 的读者可以直接从 `labs/lab1-system-call/README.md` 开始。需要复现最终结果的读者运行 `bash scripts/labctl.sh verify` 或 `bash scripts/xv6/teammate-verify.sh --full`，再对照 `docs/final/06_testing_and_verification.md`。

## 当前工程事实

当前正式版本采用 integrated suite `0001-0009`，覆盖 `hello`、`add2`、`pstate`、`pcount`、`fcount`、`pgcount`、`fdcount`、`memstat` 和 `fdinfo`，syscall 编号为 22 到 30。rain、root、z2996 三方 full verification 已登记为 PASS。`historical integrated 0001-0007` 只作为 historical stable checkpoint。

## 质量标准

引用本目录内容时应同时说明 suite、验证命令和证据位置。旧阶段文档只能用于解释“当时为什么这么做”，不能覆盖 当前正式验证范围。正式提交和评审以 `docs/final/` 与 `submissions/evidence_manifest.md` 为准。

## 边界条件

仓库不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图和隐私材料。timeout evidence 只说明一次脚本匹配成功，不代表长期稳定性。Lab5 是 capstone 综合复现实验，不新增内核机制。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 当前正式验证范围。

## 语言风格

使用中文技术写作风格，命令、文件名、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

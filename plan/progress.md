# docs 全量重写进度

## 当前阶段

阶段：S5 Review + S4 Drafting。任务属于项目文档系统重写，不是论文正文写作，但使用科研写作技能中的结构规划、质量门控和验证机制。

## 已完成

- 已读取 `caveman`、`caveman-compress`、`universal-fable-5`、`graphify` 和科研写作相关技能。
- 已通过 code-review-graph 获取项目结构摘要：主要代码社区为 `xv6-cleanup`、`scripts-status`、`scripts-usage`。
- 已通过 graphify 查询已有项目图，确认文档图中包含 `docs/25_project_graph_snapshot.md` 和 `docs/00_project_plan.md`。
- 已读取根 README、`docs/README.md`、正式技术报告、项目概述、integrated patch README、证据 manifest、测试文档、教师指南、评分文档和排障文档。

## 待完成

- 已重写 `docs/` 正式入口、规范、教学和复现文档。
- 已重写 `docs/final/` 正式提交文档。
- 已重写 `docs/00` 到 `docs/25` 历史追溯文档。
- 已运行验证命令并记录结果。

## 验证记录

- `git diff --check`：通过，未发现空白错误。
- `bash scripts/check-docs-consistency.sh`：通过，patch 列表、syscall 编号、teammate-verify 覆盖、labctl 覆盖、stale wording、课程关键文件和 report index 均通过。
- `bash scripts/check-final-hygiene.sh`：通过，未跟踪外部源码、raw logs、summary、console captures、`.claude`、`.vscode` 或未允许媒体文件。
- 文档结构抽查：除报告体例文件补充前存在缺口外，补充后所有 `docs/**/*.md` 均包含目标、适用对象、质量标准和边界条件。

### Capability-use audit

- Required skills: research-writing-assistant, using-research-writing, paper-orchestration, writing-core, verification, universal-fable-5, graphify, caveman, caveman-compress.
- Skills actually used: 已读取并按 research-writing、paper-orchestration、writing-core、verification、universal-fable-5、graphify、caveman、caveman-compress 执行；使用 code-review-graph 和 graphify 获取项目结构。
- Inputs consumed: 根 README、`docs/` 现有文档、`docs/final/`、`patches/integrated-labs/README.md`、`submissions/evidence_manifest.md`、`scripts/check-docs-consistency.sh`、`scripts/check-final-hygiene.sh`、code-review-graph 输出、graphify 查询结果。
- Inputs not used and why: 未读取 raw logs、视频和截图原件，因为它们不在 Git 中，正式证据以 evidence manifest 和 SHA256 索引为准。
- Artifacts produced: 重写后的 `docs/**/*.md`，新增 `docs/documentation_standard.md`，新增 `plan/` 任务包与审计记录。
- Verification run: `git diff --check`，`bash scripts/check-docs-consistency.sh`，`bash scripts/check-final-hygiene.sh`，结构抽查命令。
- Remaining risk: 文档语义质量仍需人工最终审阅；外部证据真实性仍不能由文档门禁证明，必须继续以 `submissions/evidence_manifest.md` 和人工核验为准。

### README full-redraft audit

- Required skills: research-writing-assistant, using-research-writing, paper-orchestration, writing-core, verification, universal-fable-5, graphify, caveman.
- Skills actually used: 使用 code-review-graph 获取项目结构摘要，使用 graphify 查询 README 相关图谱节点；按 `docs/documentation_standard.md` 和 evidence manifest 重写根 README。
- Inputs consumed: `README.md`、`docs/README.md`、`docs/documentation_standard.md`、`submissions/evidence_manifest.md`、code-review-graph minimal context、graphify query output。
- Artifacts produced: 重写后的根 `README.md`；新增 `plan/task-packets/readme-full-redraft.md`。
- Verification run: README 本地链接检查 `README_LINKS: PASS`；`git diff --check` 通过；`bash scripts/check-docs-consistency.sh` 输出 `CONSISTENCY_RESULT: PASS`；`bash scripts/check-final-hygiene.sh` 输出 `HYGIENE_RESULT: PASS`。
- Remaining risk: README 已统一 current final 和证据边界，但最终提交前仍需人工检查语气、比赛平台要求和外部资产可访问性。

## 目标

本文记录本次文档重写任务的计划、范围、输入材料、验证命令和能力使用审计。

## 适用对象

本文适用于任务执行者、审计人员和后续接手维护者。

## 内容范围

内容覆盖本次文档重写的任务包、执行进度、技能使用、产物、验证结果和剩余风险。

## 结构规范

计划类文档应保留 Scope、Files to read、Files allowed to edit、Required skills、Evidence inputs、Required artifacts、Rejection checks 和 Validation commands。进度文档应保留阶段、完成项、验证记录和 capability-use audit。

## 语言风格

使用任务审计语言，短句记录事实、命令和结果。不得把计划写成已完成事实。

## 质量标准

计划记录应能解释为什么修改这些文件、使用了哪些技能、验证了哪些门禁、还剩什么风险。

## 边界条件

不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

## 全仓库 Markdown 重写审计

### 阶段状态

阶段：S6 Verification。根 `README.md`、`docs/`、`labs/`、`patches/`、`submissions/`、`slides/`、`tests/`、`references/`、`videos/`、`external/`、`logs/`、`reproducibility/` 和 `plan/` 下 Markdown 已完成全量结构化重写或规范补齐。`graphify-out/` 作为工具缓存排除。

### 技能使用

- Required skills: `caveman`、`caveman-compress`、`universal-fable-5`、`graphify`、`research-writing-assistant`、`using-research-writing`、`paper-orchestration`、`writing-core`、`verification`。
- Skills actually used: 已读取并遵循上述技能；使用 `code-review-graph` 获取 minimal context 与 change detection；使用 `graphify query` 获取文档分层、证据清单、README 和写作规范相关图谱节点。
- Inputs consumed: 全仓库 Markdown 列表、根 README、`docs/documentation_standard.md`、`submissions/evidence_manifest.md`、`slides/final_ppt.md`、`slides/final_ppt_outline.md`、`scripts/collect-report.sh`、`scripts/check-docs-consistency.sh`、`scripts/check-final-hygiene.sh`、code-review-graph 输出和 graphify 查询结果。
- Inputs not used and why: 未读取视频、截图、raw logs 和 raw summary 原件，因为这些材料按仓库边界不入 Git，正式证据以 `submissions/evidence_manifest.md` 与 SHA256 核验脚本为准。

### 产物

- 全量重写或规范补齐所有仓库内 Markdown，排除 `graphify-out/`。
- 更新 `scripts/collect-report.sh`，使生成型 `submissions/draft-report-index.md` 也具备目标、适用对象、内容范围、结构规范、语言风格、质量标准和边界条件。
- 保留 `submissions/evidence_manifest.md`、`slides/final_ppt.md` 和 `slides/final_ppt_outline.md` 的主体证据/讲稿内容，只补齐规范章节，未压缩或删除 SHA256、视频元数据和 16 页 PPT 内容。
- 新增或保留任务包：`plan/task-packets/docs-full-redraft.md`、`plan/task-packets/readme-full-redraft.md`、`plan/task-packets/all-markdown-full-redraft.md`。

### 验证记录

- Markdown structure scan: `MD_STRUCTURE: PASS`，所有仓库内 Markdown 均包含目标、适用对象、内容范围、结构规范或等价结构、语言风格、质量标准和边界条件。
- Local Markdown link scan: `MD_LINKS: PASS`。
- `git diff --check`: 通过；Git 输出 CRLF/LF 规范化 warning，无空白错误。
- `bash scripts/check-docs-consistency.sh`: `CONSISTENCY_RESULT: PASS`。
- `bash scripts/check-final-hygiene.sh`: `HYGIENE_RESULT: PASS`。
- stale wording scan: 未发现 `new evidence TBD`、`teammate verify TBD`、`future integrated`、`未进入 integrated` 等旧状态污染正式 Markdown；仅门禁脚本自身说明中保留检查规则文本。
- code-review-graph change detection: 81 个文档/脚本变更，0 changed functions/classes，0 affected flows，risk score 0.00。

### 剩余风险

文档门禁只能验证结构、链接、脚本一致性和仓库卫生，不能证明外部视频、截图、summary 的真实性。最终提交前仍需人工复核平台提交要求、PPT 排练效果、外部资产可访问性和证据隐私边界。

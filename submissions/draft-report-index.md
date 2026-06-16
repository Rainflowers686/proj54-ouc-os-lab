# Initial Submission Material Index Draft

Generated time: stable generated index; regenerate with `bash scripts/collect-report.sh` before final submission if a timestamped copy is required

This file is generated or updated by `scripts/collect-report.sh`.
It is not the final technical report, does not generate PDF, and does not include registration materials, private data, or fabricated results.

## 目标

本文生成仓库提交材料索引，用于快速核对 README、正式文档、课程材料、脚本、patch、PPT、证据索引和提交记录是否存在。它是材料目录草案，不是最终技术报告。

## 适用对象

本文适用于队长、提交材料维护者、指导教师和最终自查人员。评审可用它了解仓库材料布局，但不应把它当作唯一技术说明。

## 内容范围

索引覆盖仓库内主要 Markdown 文档、验证脚本、patch、PPT 产物和证据说明。本文只记录文件存在性和内容状态，不保存 raw logs、summary 原件、视频、截图、报名材料或隐私材料。

## 结构规范


索引条目应包含材料名称、路径、文件存在状态和内容状态。生成脚本是本文件的来源，人工补充若需要长期保留，应同步写入 `scripts/collect-report.sh` 或转写到正式文档。

## 语言风格


本文使用材料索引语言，描述应短、准、可核对。不得使用报告结论语气，也不得把待确认项、historical evidence 或生成状态写成 current final 结论。

## 质量标准


本文应由 `scripts/collect-report.sh` 稳定生成，并由 `scripts/check-docs-consistency.sh` 检查是否新鲜。文件存在性由脚本判断，内容质量仍需人工审阅。

## 边界条件


不提交 `external/xv6-riscv/`、raw logs、summary 原件、视频、截图、token、密码或隐私材料。不把 timeout evidence 写成长期稳定性测试。不把 `pgcount`/`memstat` 写成完整内存管理；不把 `fcount`/`fdcount`/`fdinfo` 写成完整文件系统；Lab5 不新增内核机制。

## Material Index

| Material | Path | File | Content status |
| --- | --- | --- | --- |
| Project homepage | `README.md` | exists | stage19 student-first front door: first-time orientation, prerequisite knowledge list, six curated readings (full pool in references/), learning path, labctl quick run, teacher section, judge entry moved lower with Baidu asset link, directory tour, honest evidence status and real-pothole closing note |
| Documentation guide | `docs/README.md` | exists | stage19 reader routing: first-time learners (now incl. references reading list), lab runners, teachers/TAs, judges (incl. submission checklist), and historical process records (lowest priority for newcomers) |
| teacher guide | `docs/teacher_guide.md` | exists | stage12: 2/3/5-session course plans, mandatory vs optional labs, acceptance via teammate-verify summary blocks, anti-fabrication spot checks, student environment handling |
| grading and rubric | `docs/grading_and_rubric.md` | exists | stage12: four grading dimensions, per-lab focus, unified deduction table (hardcoded outputs = fabrication), bonus items, grade bands |
| troubleshooting | `docs/troubleshooting.md` | exists | stage12: symptom/cause/fix/what-to-report for WSL, PATH, /mnt slowness, Ctrl+Z + cleanup-qemu, git apply order, usys.pl filemode warning, RWX warning, DIRSIZ, timeout semantics |
| Project plan | `docs/00_project_plan.md` | exists | MVP draft |
| Requirement and scoring analysis | `docs/01_requirement_analysis.md` | exists | MVP draft |
| Lab system design | `docs/02_lab_design.md` | exists | MVP draft |
| Step-by-step guide outline | `docs/03_step_by_step_guide.md` | exists | outline draft |
| Test report | `docs/04_test_report.md` | exists | includes real baseline make, hardened boot evidence retry, lab1/lab2/lab3/lab4 outputs, integrated 0001-0007 evidence, and lab2 v0.2 outputs |
| AI usage record | `docs/05_ai_usage_record.md` | exists | active record |
| Progress log | `docs/06_progress_log.md` | exists | active record |
| FAQ and issue record | `docs/07_faq_and_issues.md` | exists | template |
| Reference and license record | `docs/08_reference_and_license.md` | exists | active record |
| GitHub workflow | `docs/09_github_workflow.md` | exists | workflow draft |
| Internal red-team review | `docs/10_red_team_review.md` | exists | draft |
| xv6 baseline plan | `docs/11_xv6_baseline_plan.md` | exists | stage1b plan |
| lab1 patch reproducibility review | `docs/12_lab1_patch_review.md` | exists | stage2b red-team; clean-baseline apply/make/hello verified |
| lab1 argint extension review | `docs/14_lab1_argint_extension_review.md` | exists | stage3b red-team: 0001+0002 reproduced (make/hello/add2); add2 call chain, argint mechanism, teaching-value assessment |
| lab2 process observation review | `docs/15_lab2_process_observation_review.md` | exists | stage4b red-team: clean-baseline apply/make/pstatetest verified; teaching limits + lab1/lab2 conflict measured |
| patch strategy and integration plan | `docs/16_patch_strategy_and_integration_plan.md` | exists | stage4b conflict measured; stage4c integrated-labs sequence built and verified |
| integrated-labs review | `docs/17_integrated_labs_review.md` | exists | stage4d red-team plus stage6a update: 0001-0005 reproduced; hello/add2test/pstatetest/pcounttest/pchildtest/fcounttest in one build |
| integrated apply helper safety review | `docs/18_integrated_helper_review.md` | exists | stage4f red-team plus stage6a update: preview safe; --run/--make always require --yes; --make --yes applies 0001-0005 |
| lab2 v0.2 process observation review | `docs/19_lab2_v0.2_process_observation_review.md` | exists | stage5a + stage5b red-team: pcount/pcounttest/pchildtest and negative input; integrated 0001-0004 re-reproduced from clean baseline; 0004 patch unchanged; lock/snapshot analysis and benign usys.pl mode warning documented |
| lab4 file table observation review | `docs/20_lab4_file_table_observation_review.md` | exists | stage6a + stage6b red-team: fcount/fcounttest; independent lab4 patch and integrated 0005 re-reproduced from clean baseline; both patches unchanged; filecount lock/deadlock/no-leak analysis; sys_fcount in sysfile.c; open/close +1/-1 delta; fcount numbers non-fixed |
| submission readiness review | `docs/21_submission_readiness_review.md` | exists | stage6d historical snapshot: full integrated 0001-0005 reproduced at that time; superseded by final e8e2fb9 integrated 0001-0007 evidence manifest |
| teammate reproduction troubleshooting | `docs/22_teammate_reproduction_troubleshooting.md` | exists | stage7a0: explains apply/make completion, boot normal duration, Ctrl+Z risk, qemu/make cleanup, continuation steps, feedback format, and no-log/no-secret boundaries |
| teammate quickstart | `docs/23_teammate_quickstart.md` | exists | stage7a2: official teammate testing entry; --full first run, --quick retest after make, local-verify before recording, cleanup-qemu after stuck/Ctrl+Z, summary feedback, no external/logs/secrets |
| lab3/lab5 completion plan | `docs/24_lab3_lab5_completion_plan.md` | exists | stage9c process record with stage11b banner: described 0001-0007 state is historical; current integrated suite is 0001-0009; e8e2fb9 evidence is a historical stable checkpoint recorded elsewhere |
| final project overview | `docs/final/00_project_overview.md` | exists | current final overview: OUC xv6 Lab Kit positioning, scoring weights, integrated 0001-0009, db85947 three-way PASS, e8e2fb9 0001-0007 historical, evidence boundaries |
| final environment setup | `docs/final/01_environment_setup.md` | exists | stage8a formal environment and repository hygiene guide |
| final lab0 guide | `docs/final/02_lab0_baseline_build_boot.md` | exists | stage8a formal lab0 baseline/build/boot guide |
| final lab1 guide | `docs/final/03_lab1_hello_add2.md` | exists | stage8a formal hello/add2 syscall lab guide |
| final lab2 guide | `docs/final/04_lab2_process_observation.md` | exists | stage8a formal pstate/pcount/pchild process observation lab guide |
| final lab3 guide | `docs/final/04b_lab3_page_table_observation.md` | exists | stage9c formal pgcount page-table observation guide; stage11b advanced memstat section now covers independent + integrated 0008 |
| final lab4 guide | `docs/final/05_lab4_file_table_observation.md` | exists | stage9c formal fcount/fdcount file table and fd table observation lab guide; stage11b advanced fdinfo section now covers independent + integrated 0009 |
| final testing and verification | `docs/final/06_testing_and_verification.md` | exists | current final testing coverage includes memstat/fdinfo; db85947 0001-0009 rain/root/z2996 full PASS; e8e2fb9 0001-0007 is historical; real-result boundaries |
| final teammate reproduction guide | `docs/final/07_teammate_reproduction_guide.md` | exists | current final teammate reproduction guide: db85947 0001-0009 full verification recorded for rain/root/z2996; e8e2fb9 remains historical checkpoint |
| final design decisions | `docs/final/08_design_decisions_and_tradeoffs.md` | exists | stage8a formal design tradeoffs and scope control |
| final AI usage statement | `docs/final/09_ai_usage_and_contribution_statement.md` | exists | stage8a formal AI usage and contribution statement |
| final reference and license statement | `docs/final/10_reference_and_license_statement.md` | exists | stage8a formal xv6 MIT license boundary and reference-project notes |
| final limits and future work | `docs/final/11_known_limits_and_future_work.md` | exists | stage11b limits: pgcount/fdcount/memstat/fdinfo observation-only scope boundaries, integrated suite 0001-0009, e8e2fb9 evidence historical, new evidence/platform/privacy/reference items still pending |
| technical report v1.0 | `docs/final/technical_report_v1.0.md` | exists | judge-facing technical report: positioning, labs, integrated 0001-0009, db85947 three-way PASS evidence, e8e2fb9 historical, teaching value, license/AI/limits |
| submission checklist | `submissions/submission_checklist.md` | exists | stage16 submission checklist: current final db85947/0001-0009 three-way PASS + new video recorded; Baidu external-asset row added; video/screenshot privacy review confirmed OK; remaining items include platform method and final rehearsal |
| demo video record | `submissions/demo_record.md` | exists | stage16: current final 0001-0009 video metadata recorded with duration/resolution/fps/size/SHA256 (20260611 demo, db85947); old 0001-0007 video is historical stable checkpoint; 3 earlier videos are historical; no video files in Git |
| teammate reproduction record | `submissions/teammate_reproduction_record.md` | exists | stage14: current final db85947/0001-0009 three-way full PASS recorded with summary/screenshot SHA256 and grade-summaries 3/3 clean; e8e2fb9 and 1ba9db6 records historical; raw files not committed |
| final evidence manifest | `submissions/evidence_manifest.md` | exists | stage16 central index: current final db85947/0001-0009 with three-way full PASS, grade-summaries 3/3 clean, final video metadata + SHA256, 14/14 hash verification, External Asset Package link, e8e2fb9 0001-0007 historical stable checkpoint, and non-committed evidence policy |
| Technical report v0.1 | `docs/13_technical_report_v0.1.md` | exists | historical stage2c draft with stage8b obsolete notice; not final report |
| Reproducibility package | `reproducibility/README.md` | exists | lab0/lab1/lab2/integrated-labs reproduction checklist and template |
| lab0 environment guide | `labs/lab0-env-setup/README.md` | exists | environment and baseline guide; covers doctor/setup/boot evidence and records interactive shell use as optional teaching extension |
| lab1 syscall lab | `labs/lab1-system-call/README.md` | exists | stage12 tutorial-style: hello minimal and add2 argint, 7-file checklist, call path, hands-on pointer to student tasks |
| lab1 student tasks | `labs/lab1-system-call/student_tasks.md` | exists | stage12 assignment sheet: reproduce, build your own integer syscall, break-and-fix experiment, rubric and deduction list |
| lab2 process state observation | `labs/lab2-process-and-scheduling/README.md` | exists | stage12 tutorial-style: pstate/pcount/pchildtest, proc table and lock discipline, scheduling nondeterminism |
| lab2 student tasks | `labs/lab2-process-and-scheduling/student_tasks.md` | exists | stage12 assignment sheet: lock path audit, new observation syscall, repeated-run timing observation, rubric |
| lab3 memory and pagetable | `labs/lab3-memory-and-pagetable/README.md` | exists | stage12 tutorial-style: pgcount int observation vs memstat struct-copyout observation; eager/lazy delta experiment; integrated 0006/0008 |
| lab3 student tasks | `labs/lab3-memory-and-pagetable/student_tasks.md` | exists | stage12 assignment sheet: predict-then-verify lazy deltas, copyout data-flow walkthrough, add a struct field with padding analysis, rubric |
| lab4 file system | `labs/lab4-file-system/README.md` | exists | stage12 tutorial-style: fcount global trend / fdcount per-process / fdinfo single-fd struct view; open-dup-close contrast; not a complete file system lab |
| lab4 student tasks | `labs/lab4-file-system/student_tasks.md` | exists | stage12 assignment sheet: predict-verify dup effects, fdinfo validation audit, ref observation, negative cases, rubric |
| lab5 final integration | `labs/lab5-final-integration/README.md` | exists | stage12 tutorial-style capstone for integrated 0001-0009; reproducibility and evidence discipline; no new kernel mechanism |
| lab5 student tasks | `labs/lab5-final-integration/student_tasks.md` | exists | stage12 assignment sheet: full-suite reproduction with summary block, patch walkthrough incl. 0008/0009, fault log, evidence boundary statement, rubric |
| lab1 test record | `tests/lab1/README.md` | exists | records patched make and hello output evidence |
| lab2 test record | `tests/lab2/README.md` | exists | records pstatetest, pcounttest, and pchildtest output evidence |
| lab3 test record | `tests/lab3/README.md` | exists | records pgcount eager/lazy output captures from independent and integrated 0006; final teammate coverage recorded in submissions evidence manifest |
| lab4 test record | `tests/lab4/README.md` | exists | records fcounttest/fdcounttest captures and non-fixed count boundary |
| xv6 fetch script | `scripts/xv6/fetch-xv6.sh` | exists | stage1b tooling |
| xv6 baseline check script | `scripts/xv6/check-xv6-baseline.sh` | exists | stage1b tooling; make not run by default |
| xv6 boot evidence script | `scripts/xv6/boot-xv6.sh` | exists | captures boot keywords under soft+hard timeout; default 45s soft, max(timeout+15,75)s hard, 2 attempts, per-attempt logs, trap cleanup |
| xv6 command evidence script | `scripts/xv6/run-xv6-command.sh` | exists | captures user program output under soft+hard timeout; default 60s soft, max(timeout+15,75)s hard, 2 attempts, fs.img prebuild, trap cleanup, fast QEMU exit on expected output match (stage7a3) |
| lab1 patch apply helper | `scripts/xv6/apply-lab1-patch.sh` | exists | preview by default; --run resets clean baseline and applies; --make optional |
| integrated labs apply helper | `scripts/xv6/apply-integrated-labs.sh` | exists | preview by default; --run/--make always require --yes; applies integrated 0001-0009; make has XV6_MAKE_TIMEOUT_SECONDS; make logs ignored |
| xv6 doctor script | `scripts/xv6/doctor.sh` | exists | stage7a2 read-only environment diagnosis: time/cwd/uname/commit, Git repo, tools, baseline files, logs ignored, QEMU leftovers, /mnt warning; no make or QEMU run |
| xv6 QEMU cleanup helper | `scripts/xv6/cleanup-qemu.sh` | exists | stage7a2 rescue tool: explains Ctrl+C interrupt vs Ctrl+Z suspend, lists qemu/make qemu processes before/after, warns pkill may affect same-WSL QEMU, exits 0 |
| teammate one-shot verification | `scripts/xv6/teammate-verify.sh` | exists | stage11b workflow: --full clean apply+make and --quick retest; doctor/check-env/baseline, boot, hello/add2/pstate/pcount/pchild/fcount/pgcount/fdcount/memstat/fdinfo verification, copy-to-lead summary in ignored logs |
| local pre-recording verification | `scripts/xv6/local-verify.sh` | exists | stage7a2 team-lead wrapper around teammate-verify; --full/--quick; recommended --quick before recording |
| course command entry | `scripts/labctl.sh` | exists | stage13 unified dispatcher: doctor/setup/boot/test/verify/quick/precheck/clean/grade/consistency/hygiene/evidence/report subcommands delegate to existing scripts; adds the lab-to-test matrix (test lab1..lab4/all, list) |
| TA summary batch parser | `scripts/grade-summaries.sh` | exists | stage13 acceptance aid (not a grader): parses teammate-verify summary blocks into one row per file; flags overall/item inconsistency, missing memstattest-fdinfotest (old suite), duplicate content, commit mismatch; exit 1 when attention needed |
| docs/state consistency gate | `scripts/check-docs-consistency.sh` | exists | stage13 drift gate: PATCHES list vs patch files, SYS numbers 22-30 in patches, teammate-verify and labctl matrix coverage, stale wording scan outside changelogs, course file presence, report-index freshness |
| final hygiene gate | `scripts/check-final-hygiene.sh` | exists | stage12 read-only pre-submission gate: external/logs/.claude/.vscode/media-office tracking checks with single PPTX whitelist plus git diff --check |
| external evidence SHA256 check | `scripts/check-evidence-sha256.sh` | exists | stage14: hashes both evidence sets in place against recorded SHA256 (historical e8e2fb9/0001-0007 plus current final db85947/0001-0009: video, 3 summaries, 2 screenshots); skips when evidence dir absent; latest real run 14/14 matched |
| lab1 hello syscall patch | `patches/lab1-system-call/0001-add-hello-syscall.patch` | exists | tracked patch; third-party source not submitted |
| lab1 add2 argint syscall patch | `patches/lab1-system-call/0002-add-argint-add2-syscall.patch` | exists | commit-ready incremental patch after 0001 |
| lab1 patch guide | `patches/lab1-system-call/README.md` | exists | apply/build/run instructions |
| lab2 pstate syscall patch | `patches/lab2-process-observation/0001-add-pstate-syscall.patch` | exists | commit-ready independent patch from clean baseline |
| lab2 patch guide | `patches/lab2-process-observation/README.md` | exists | apply/build/run instructions |
| lab3 pgcount syscall patch | `patches/lab3-memory-and-pagetable/0001-add-pgcount-syscall.patch` | exists | stage9b independent patch from clean baseline; SYS_pgcount 22; eager/lazy pgcounttest verified |
| lab3 memstat advanced optional patch | `patches/lab3-memory-and-pagetable/0002-add-memstat-syscall.patch` | exists | stage11a independent advanced patch; memstat(struct memstat*) via argaddr+copyout; SYS_memstat 22; clean-baseline round-trip verified; stage11b also integrates this as integrated 0008 (SYS_memstat 29); independent variant not teammate-verified; does not affect historical e8e2fb9 |
| lab3 patch guide | `patches/lab3-memory-and-pagetable/README.md` | exists | apply/build/run instructions and eager/lazy allocation teaching notes |
| lab4 fcount syscall patch | `patches/lab4-file-table-observation/0001-add-fcount-syscall.patch` | exists | commit-ready independent patch from clean baseline |
| lab4 fdinfo advanced optional patch | `patches/lab4-file-table-observation/0002-add-fdinfo-syscall.patch` | exists | stage11a independent advanced patch; fdinfo(int,struct fdinfo*) via argint+argaddr+copyout; SYS_fdinfo 22; self-only ofile[fd]; clean-baseline round-trip verified; stage11b also integrates this as integrated 0009 (SYS_fdinfo 30); independent variant not teammate-verified; does not affect historical e8e2fb9 |
| lab4 patch guide | `patches/lab4-file-table-observation/README.md` | exists | apply/build/run instructions |
| integrated hello syscall patch | `patches/integrated-labs/0001-add-hello-syscall.patch` | exists | comprehensive demo sequence step 1 |
| integrated add2 argint syscall patch | `patches/integrated-labs/0002-add-argint-add2-syscall.patch` | exists | comprehensive demo sequence step 2 |
| integrated pstate syscall patch | `patches/integrated-labs/0003-add-pstate-syscall.patch` | exists | comprehensive demo sequence step 3; uses SYS_pstate 24 |
| integrated lab2 v0.2 process observation patch | `patches/integrated-labs/0004-extend-process-observation.patch` | exists | comprehensive demo sequence step 4; adds SYS_pcount 25, pcounttest, pchildtest |
| integrated lab4 file table observation patch | `patches/integrated-labs/0005-add-file-table-observation.patch` | exists | comprehensive demo sequence step 5; adds SYS_fcount 26 and fcounttest |
| integrated lab3 pgcount patch | `patches/integrated-labs/0006-add-pgcount-page-table-observation.patch` | exists | comprehensive demo sequence step 6; adds SYS_pgcount 27 and pgcounttest |
| integrated lab4 fdcount patch | `patches/integrated-labs/0007-add-fdcount-observation.patch` | exists | comprehensive demo sequence step 7; adds SYS_fdcount 28 and fdcounttest |
| integrated lab3 memstat patch | `patches/integrated-labs/0008-add-memstat-copyout-observation.patch` | exists | stage11b comprehensive demo sequence step 8; adds SYS_memstat 29 and memstattest; argaddr+copyout+struct ABI; reuses uvmpagecount; address-space observation only, not full memory management |
| integrated lab4 fdinfo patch | `patches/integrated-labs/0009-add-fdinfo-copyout-observation.patch` | exists | stage11b comprehensive demo sequence step 9; adds SYS_fdinfo 30 and fdinfotest; argint+argaddr+copyout+struct ABI; self-only ofile[fd]; fd metadata observation only, not full file system |
| integrated patch guide | `patches/integrated-labs/README.md` | exists | current integrated guide for combined lab1+lab2+lab3+lab4 demo: sequence 0001-0009 incl. memstat 0008 and fdinfo 0009; old 0001-0007 evidence marked historical |
| external directory guide | `external/README.md` | exists | baseline management notes |
| xv6 baseline metadata | `external/xv6-baseline-record.md` | exists | metadata generated; records baseline commit, make success, and boot evidence; interactive shell use remains a teaching extension |
| logs directory guide | `logs/README.md` | exists | raw logs ignored by default; current make log is not tracked |
| reference reading list | `references/README.md` | exists | stage19 layered reading guide: contest pages, official xv6/MIT entries, rCore/uCore/PKE course ecosystems, past winning docs; every link annotated with purpose, when-to-read, and not-an-implementation-source boundary; unverified personal pages clearly flagged |
| PPT directory guide | `slides/README.md` | exists | stage16 guide for final PPT source, outline, generator, PPTX sync policy, and no-media boundary |
| final PPT outline | `slides/final_ppt_outline.md` | exists | stage16 16-slide high-impact defense outline: lab kit story, current db85947/0001-0009 facts, evidence cards, tooling map, comparison, and honest boundaries |
| final PPT source | `slides/final_ppt.md` | exists | stage16 16-slide final defense source: core story (course lab kit, not just syscalls), current final db85947/0001-0009 three-way PASS, 00:03:12 final video, 14/14 evidence hash, Baidu asset package, teaching value, honest boundaries |
| final PPT generator | `slides/generate_final_ppt.ps1` | exists | stage16 PowerPoint COM generator; reads slides/final_ppt.md and writes a self-drawn deep-blue/cyan 16:9 deck without embedded media |
| final PPTX | `slides/final_defense_ppt.pptx` | exists | stage16 generated defense deck; 16 slides, 16 speaker notes, self-drawn shapes, no embedded video/screenshot media |
| Demo video notes | `videos/README.md` | exists | records video policy and no-video-in-Git boundary |
| Demo script draft | `videos/demo_script.md` | exists | historical 2-3 minute demo flow; final recorded video metadata is tracked in submissions/demo_record.md |
| Final submission | `submissions/` | - | organize final upload package against official platform requirements before submission |

## Notes

- File existence is checked by this script; content quality still needs human review.
- `external/xv6-riscv/` is intentionally not listed as a tracked submission artifact.
- xv6 baseline make, hardened boot evidence retry, lab1 patched make, hello output, add2 output, pstatetest output, pcounttest output, pchildtest output, fcounttest output, and integrated sequence evidence are summarized in docs/04_test_report.md.
- lab1 now has two patch levels: 0001 hello minimal syscall and 0002 add2 argint extension.
- lab2 has an independent pstate process observation patch from clean baseline.
- lab3 has an independent pgcount patch, integrated 0006 pgcount, and an independent memstat patch also integrated as 0008; e8e2fb9 0001-0007 full verification by lead/root/z2996 is a historical stable checkpoint in submissions/evidence_manifest.md, and current db85947 0001-0009 has lead/root/z2996 full PASS recorded as final evidence.
- integrated-labs provides the verified comprehensive demo sequence with hello=22, add2=23, pstate=24, pcount=25, fcount=26, pgcount=27, fdcount=28, memstat=29, fdinfo=30.
- The child-state demo command is pchildtest; the longer pstatechildtest name is not used because xv6 DIRSIZ caused a real mkfs failure.
- scripts/xv6/apply-integrated-labs.sh is the recommended helper for final integrated demo reproduction and now applies integrated 0001-0009.
- scripts/xv6/doctor.sh is the read-only environment diagnosis entry and does not run make/QEMU.
- scripts/xv6/teammate-verify.sh --full is the recommended first teammate workflow; --quick is for retesting after make already succeeded.
- scripts/xv6/local-verify.sh --quick is recommended for team-lead pre-recording checks.
- scripts/xv6/cleanup-qemu.sh is the rescue command when QEMU is stuck or Ctrl+Z suspended a job.
- stage12 reorganized the repo learner-first: README and docs/README route students/teachers/judges separately; every lab has a tutorial README plus a student_tasks.md assignment sheet; teacher_guide/grading_and_rubric/troubleshooting support running this as a course; submission evidence stays rigorous under submissions/ and docs/final/.
- scripts/check-final-hygiene.sh and scripts/check-evidence-sha256.sh are the pre-submission gates; evidence hashes are verified in place outside Git; current final db85947 evidence has a recorded 14/14 SHA256 match.
- stage13 added scripts/labctl.sh (single course entry + per-lab test matrix), scripts/grade-summaries.sh (TA batch acceptance aid, not a grader), and scripts/check-docs-consistency.sh (mechanical drift gate); all three delegate to or check existing assets instead of reimplementing verification.
- docs/final/ is the formal submission documentation portal for stage8a and should be the basis for technical report v1.0 and PPT.
- docs/README.md explains the boundary between formal docs/final documentation and historical process records.
- Technical report v1.0 draft is docs/final/technical_report_v1.0.md; technical report v0.1 is historical only.
- Final PPT source is slides/final_ppt.md and current PPTX output is slides/final_defense_ppt.pptx; stage16 rebuilt the deck with high-impact visual design using slides/generate_final_ppt.ps1; final human review and rehearsal are still required.
- docs/13_technical_report_v0.1.md is explicitly marked as a historical draft superseded by docs/final and a future technical report v1.0.
- Raw logs remain ignored by Git; do not submit logs/*.log.
- boot-xv6.sh now defaults to 45s soft timeout, hard timeout max(timeout+15,75), and 2 attempts; QEMU long-running stability and manual interactive shell testing are outside automated timeout evidence.
- run-xv6-command.sh now defaults to 60s soft timeout, hard timeout max(timeout+15,75), and 2 attempts; success is still based only on real log matching.
- apply-integrated-labs.sh --make --yes uses XV6_MAKE_TIMEOUT_SECONDS, default 600 seconds; make success is never fabricated.
- Teammate QEMU cleanup troubleshooting is documented in docs/22_teammate_reproduction_troubleshooting.md.
- Plain-language teammate quickstart is documented in docs/23_teammate_quickstart.md; teammates should copy the COPY THIS SUMMARY TO TEAM LEAD block to the team lead.
- Video files are not committed; final and historical video metadata plus SHA256 are recorded in submissions/demo_record.md.
- e8e2fb9 lead/root/z2996 full PASS (integrated 0001-0007) is recorded as a historical stable checkpoint in submissions/teammate_reproduction_record.md; current final db85947/0001-0009 lead/root/z2996 full PASS is recorded as final evidence; old 1ba9db6 records remain historical evidence only.
- submissions/evidence_manifest.md is the central final evidence index and does not store raw evidence files.

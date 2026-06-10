#!/usr/bin/env bash
# check-docs-consistency — machine gate against state drift.
#
# Background: this repo restates the integrated suite identity (patch list,
# syscall numbers 22-30, test program set) in many documents. Stage11b's red
# team found ~14 places where docs still described an older suite as current.
# Humans fixed it once; this script keeps it fixed.
#
# All checks are mechanical greps/diffs over tracked files — no QEMU, no make.
# [ERROR] findings exit 1; [WARN] findings exit 0. Things that need human
# judgment are printed as [MANUAL], never as a pass.
set -u

fail=0
warn=0

repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
  echo "[ERROR] not inside a Git repository"
  exit 1
}
cd "$repo_root" || exit 1

if [ "${1:-}" = "help" ] || [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  cat <<'EOF'
用法: bash scripts/check-docs-consistency.sh

检查项 (全部只读, 除了第 7 项会重新生成 submissions/draft-report-index.md):
  1. apply-integrated-labs.sh 的 PATCHES 列表 <-> patches/integrated-labs/*.patch 双向一致
  2. integrated patch 内新增的 #define SYS_* 编号 == 文档承诺的 22-30
  3. teammate-verify.sh 覆盖全部 10 个用户程序检查 (含 memstattest/fdinfotest)
  4. labctl.sh 测试矩阵中的程序都被 teammate-verify.sh 覆盖
  5. 已跟踪 *.md 中不存在已失效的措辞 (如 "未进入 integrated"), changelog 除外
  6. 课程关键文件存在 (student_tasks x5, 教师三件套, 门禁脚本)
  7. draft-report-index.md 是否新鲜 (用 collect-report.sh 重新生成并对比)
EOF
  exit 0
fi

echo "docs/state consistency check"
echo "repo : $repo_root"
echo

# 1 ------------------------------------------------------------------
listed="$(sed -n '/^PATCHES="/,/^"/p' scripts/xv6/apply-integrated-labs.sh | grep '^patches/' | sort)"
actual="$(ls patches/integrated-labs/*.patch 2>/dev/null | sort)"
if [ "$listed" = "$actual" ]; then
  n="$(printf '%s\n' "$actual" | grep -c .)"
  echo "[OK]   1. PATCHES list matches patches/integrated-labs/ (${n} patches)"
else
  echo "[ERROR] 1. PATCHES list and patch files differ:"
  diff <(printf '%s\n' "$listed") <(printf '%s\n' "$actual") | sed 's/^/        /'
  fail=1
fi

# 2 ------------------------------------------------------------------
expected_sys="SYS_hello 22
SYS_add2 23
SYS_pstate 24
SYS_pcount 25
SYS_fcount 26
SYS_pgcount 27
SYS_fdcount 28
SYS_memstat 29
SYS_fdinfo 30"
# awk normalizes the alignment spacing some patches use between name and number
found_sys="$(grep -h '^+#define SYS_' patches/integrated-labs/*.patch | awk '{print $2, $3}' | sort -k2 -n)"
if [ "$found_sys" = "$expected_sys" ]; then
  echo "[OK]   2. integrated syscall numbers are exactly hello=22 ... fdinfo=30"
else
  echo "[ERROR] 2. syscall numbers in patches differ from the documented map:"
  diff <(printf '%s\n' "$expected_sys") <(printf '%s\n' "$found_sys") | sed 's/^/        /'
  fail=1
fi

# 3 ------------------------------------------------------------------
missing3=""
for prog in hello add2test pstatetest pcounttest pchildtest fcounttest pgcounttest fdcounttest memstattest fdinfotest; do
  grep -q "run-xv6-command.sh ${prog} " scripts/xv6/teammate-verify.sh || missing3="${missing3}${prog} "
done
if [ -z "$missing3" ]; then
  echo "[OK]   3. teammate-verify.sh covers all 10 user-program checks"
else
  echo "[ERROR] 3. teammate-verify.sh is missing checks for: ${missing3}"
  fail=1
fi

# 4 ------------------------------------------------------------------
missing4=""
for prog in $(sed -n '/^MATRIX="/,/^"/p' scripts/labctl.sh | grep '^lab' | cut -d'|' -f2 | sort -u); do
  grep -q "run-xv6-command.sh ${prog} " scripts/xv6/teammate-verify.sh || missing4="${missing4}${prog} "
done
if [ -z "$missing4" ]; then
  echo "[OK]   4. every labctl matrix program is also covered by teammate-verify.sh"
else
  echo "[ERROR] 4. labctl matrix programs not covered by teammate-verify.sh: ${missing4}"
  fail=1
fi

# 5 ------------------------------------------------------------------
# Changelogs may quote historical phrasing; everything else must not claim
# memstat/fdinfo are outside integrated or that 0008/0009 are future work.
stale="$(git grep -nE "未进入 integrated|未来的? integrated|future integrated" -- "*.md" \
  ":(exclude)docs/05_ai_usage_record.md" ":(exclude)docs/06_progress_log.md" || true)"
if [ -z "$stale" ]; then
  echo "[OK]   5. no stale 'not yet integrated / future 0008-0009' wording outside changelogs"
else
  echo "[ERROR] 5. stale wording found (suite is 0001-0009 since stage11b):"
  printf '%s\n' "$stale" | sed 's/^/        /'
  fail=1
fi

# 6 ------------------------------------------------------------------
missing6=""
for f in \
  labs/lab1-system-call/student_tasks.md \
  labs/lab2-process-and-scheduling/student_tasks.md \
  labs/lab3-memory-and-pagetable/student_tasks.md \
  labs/lab4-file-system/student_tasks.md \
  labs/lab5-final-integration/student_tasks.md \
  docs/teacher_guide.md docs/grading_and_rubric.md docs/troubleshooting.md \
  scripts/check-final-hygiene.sh scripts/check-evidence-sha256.sh \
  scripts/labctl.sh scripts/grade-summaries.sh; do
  [ -f "$f" ] || missing6="${missing6}${f} "
done
if [ -z "$missing6" ]; then
  echo "[OK]   6. course-critical files all present"
else
  echo "[ERROR] 6. missing course files: ${missing6}"
  fail=1
fi

# 7 ------------------------------------------------------------------
idx="submissions/draft-report-index.md"
if [ -f "$idx" ]; then
  before="$(mktemp)"
  cp "$idx" "$before"
  bash scripts/collect-report.sh >/dev/null
  if diff -q "$before" "$idx" >/dev/null; then
    echo "[OK]   7. ${idx} was already up to date"
  else
    echo "[WARN] 7. ${idx} was stale; collect-report.sh has regenerated it — review and commit the diff"
    warn=1
  fi
  rm -f "$before"
else
  echo "[ERROR] 7. ${idx} missing; run bash scripts/collect-report.sh"
  fail=1
fi

# ----------------------------------------------------------------------
echo
echo "[MANUAL] 证据真实性 (队友复现/视频/SHA256 的 TBD 状态) 无法机器判定:"
echo "[MANUAL] 以 submissions/evidence_manifest.md 为准, 不要让任何工具替它宣布 PASS。"
echo
if [ "$fail" -ne 0 ]; then
  echo "CONSISTENCY_RESULT: FAIL"
  exit 1
fi
if [ "$warn" -ne 0 ]; then
  echo "CONSISTENCY_RESULT: PASS_WITH_WARNINGS"
  exit 0
fi
echo "CONSISTENCY_RESULT: PASS"
exit 0

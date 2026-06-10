#!/usr/bin/env bash
# grade-summaries — TA helper that batch-parses teammate-verify summary files.
#
# Students/teammates run `bash scripts/xv6/teammate-verify.sh --full` and send
# back either the whole summary file or the COPY THIS SUMMARY TO TEAM LEAD
# block. A TA with 30 of these should not eyeball them one by one. This tool
# parses each file into one table row and flags things a human must look at.
#
# IMPORTANT: this is an acceptance AID, not a grader. It checks the summary's
# internal consistency; it cannot prove the student really ran anything.
# Spot checks (docs/teacher_guide.md) are still required, and the final grade
# is always the teacher's call.
#
# Flags raised per file:
#   OVERALL_FAIL      overall is not PASS
#   INCONSISTENT      overall says PASS but some item line says FAIL
#   MISSING:<items>   expected check lines absent
#   OLD_SUITE?        memstattest/fdinfotest lines absent -> probably produced
#                     before integrated 0001-0009; ask the student to re-run
#   MODE_QUICK        quick mode; formal acceptance expects --full
#   NO_BLOCK          COPY...END markers absent (parsed whole file instead)
#   COMMIT_MISMATCH   commit line does not contain --expect-commit value
#   DUP_OF:<file>     byte-identical content with another submitted file
#
# Exit code: 1 if any OVERALL_FAIL / INCONSISTENT / COMMIT_MISMATCH / DUP_OF
# was found (needs TA attention), else 0. WARN-level flags do not fail.
set -u

EXPECT_COMMIT=""
ITEMS="apply+make boot hello add2test pstatetest pcounttest pchildtest fcounttest pgcounttest fdcounttest memstattest fdinfotest"

usage() {
  cat <<'EOF'
用法:
  bash scripts/grade-summaries.sh [--expect-commit <substring>] <文件|目录> [更多...]

参数:
  --expect-commit <substring>   要求每份 summary 的 current commit 行包含该子串
                                (通常给短 hash, 例如 --expect-commit b89eece)
  <文件|目录>                   summary 文件, 或装满 summary 的目录(只取一层)

约定:
  - 学生提交物建议收集到 logs/student-summaries/ (已被 .gitignore 忽略, 不会入库)。
  - 本工具只做辅助验收: 解析 + 内部一致性 + 重复检测。它不能证明学生真的跑过,
    最终评分以教师抽查和 docs/grading_and_rubric.md 为准。

示例:
  bash scripts/grade-summaries.sh logs/student-summaries/
  bash scripts/grade-summaries.sh --expect-commit b89eece logs/student-summaries/
  bash scripts/labctl.sh grade logs/student-summaries/
EOF
}

# ---- argument parsing -------------------------------------------------
files=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --expect-commit)
      EXPECT_COMMIT="${2:-}"
      [ -z "$EXPECT_COMMIT" ] && { echo "[ERROR] --expect-commit 需要一个值"; exit 2; }
      shift 2
      ;;
    help|-h|--help)
      usage
      exit 0
      ;;
    *)
      if [ -d "$1" ]; then
        for f in "$1"/*; do
          [ -f "$f" ] && files="${files}${f}
"
        done
      elif [ -f "$1" ]; then
        files="${files}$1
"
      else
        echo "[WARN] not a file or directory, skipped: $1"
      fi
      shift
      ;;
  esac
done

if [ -z "$files" ]; then
  echo "[ERROR] 没有可解析的输入文件。"
  echo
  usage
  exit 2
fi

attention=0
total=0
pass=0

printf '%-44s %-8s %-10s %-6s %-8s %s\n' "FILE" "USER" "COMMIT" "MODE" "OVERALL" "FLAGS"
printf '%-44s %-8s %-10s %-6s %-8s %s\n' "----" "----" "------" "----" "-------" "-----"

# duplicate detection across files (hash -> first filename)
dupdb="$(mktemp)"
trap 'rm -f "$dupdb"' EXIT

while IFS= read -r f; do
  [ -z "$f" ] && continue
  total=$((total + 1))

  content="$(tr -d '\r' < "$f")"

  # Prefer the marker block; fall back to the whole file.
  block="$(printf '%s\n' "$content" | sed -n '/COPY THIS SUMMARY TO TEAM LEAD/,/END SUMMARY/p')"
  flags=""
  if [ -z "$block" ]; then
    block="$content"
    flags="${flags}NO_BLOCK "
  fi

  commit="$(printf '%s\n' "$block" | grep -m1 '^current commit:' | sed 's/^current commit:[[:space:]]*//')"
  mode="$(printf '%s\n' "$block" | grep -m1 '^mode:' | sed 's/^mode:[[:space:]]*//')"
  overall="$(printf '%s\n' "$block" | grep -m1 '^overall:' | sed 's/^overall:[[:space:]]*//')"
  # user only exists in the full summary header, not the COPY block
  user="$(printf '%s\n' "$content" | grep -m1 '^user' | sed 's/^user[[:space:]]*:[[:space:]]*//')"

  missing=""
  inconsistent=0
  for item in $ITEMS; do
    line="$(printf '%s\n' "$block" | grep -m1 "^${item}:")"
    if [ -z "$line" ]; then
      missing="${missing}${item},"
      continue
    fi
    # Only an explicit FAIL contradicts overall PASS. SKIPPED is legitimate
    # (quick mode skips apply+make by design) and must not look like tampering.
    case "$line" in
      *FAIL*) inconsistent=1 ;;
    esac
  done

  [ -n "$missing" ] && flags="${flags}MISSING:${missing%,} "
  case "$missing" in
    *memstattest*|*fdinfotest*) flags="${flags}OLD_SUITE? " ;;
  esac

  if [ "$overall" = "PASS" ] && [ "$inconsistent" -eq 1 ]; then
    flags="${flags}INCONSISTENT "
  fi
  if [ "$overall" != "PASS" ]; then
    flags="${flags}OVERALL_FAIL "
  fi
  if [ -n "$mode" ] && [ "$mode" != "full" ]; then
    flags="${flags}MODE_QUICK "
  fi
  if [ -n "$EXPECT_COMMIT" ]; then
    case "$commit" in
      *"$EXPECT_COMMIT"*) : ;;
      *) flags="${flags}COMMIT_MISMATCH " ;;
    esac
  fi

  h="$(printf '%s' "$block" | sha256sum | awk '{print $1}')"
  prev="$(grep -m1 "^${h} " "$dupdb" | awk '{print $2}')"
  if [ -n "$prev" ]; then
    flags="${flags}DUP_OF:$(basename "$prev") "
  else
    echo "$h $f" >> "$dupdb"
  fi

  case "$flags" in
    *OVERALL_FAIL*|*INCONSISTENT*|*COMMIT_MISMATCH*|*DUP_OF:*) attention=$((attention + 1)) ;;
    *) [ "$overall" = "PASS" ] && pass=$((pass + 1)) ;;
  esac

  short_commit="$(printf '%s' "$commit" | awk '{print $1}' | cut -c1-9)"
  printf '%-44s %-8s %-10s %-6s %-8s %s\n' \
    "$(basename "$f" | cut -c1-44)" \
    "${user:--}" \
    "${short_commit:--}" \
    "${mode:--}" \
    "${overall:--}" \
    "${flags:-—}"
done <<EOF
$files
EOF

echo
echo "parsed: ${total}   clean PASS: ${pass}   needs attention: ${attention}"
echo "[NOTE] 这是辅助验收, 不是评分: 干净的 PASS 仍需按 docs/teacher_guide.md 抽查;"
echo "[NOTE] 被标记的文件请人工核对原文。最终成绩以 docs/grading_and_rubric.md 为准。"
if [ "$attention" -gt 0 ]; then
  echo "GRADE_SUMMARIES_RESULT: ATTENTION_NEEDED"
  exit 1
fi
echo "GRADE_SUMMARIES_RESULT: OK"
exit 0

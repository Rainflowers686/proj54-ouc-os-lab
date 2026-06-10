#!/usr/bin/env bash
# labctl — single entry point for the OUC xv6 Lab Kit course workflow.
#
# This is a thin dispatcher: every subcommand delegates to an existing,
# already-verified script. It adds exactly one piece of new knowledge —
# the lab -> (program, expected output) test matrix — so students can run
# "the tests for my current lab" without copying long commands from READMEs.
#
# It never modifies scripts/xv6 behavior and never fakes a result: every
# test line is a real scripts/xv6/run-xv6-command.sh invocation against QEMU.
set -u

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || {
  echo "[ERROR] not inside a Git repository"
  exit 1
}
cd "$REPO_ROOT" || exit 1

# ----------------------------------------------------------------------
# Lab -> test matrix. Source of truth for expected texts:
# scripts/xv6/teammate-verify.sh run_step lines and the lab READMEs.
# Format: lab|program|expected-output
# ----------------------------------------------------------------------
MATRIX="
lab1|hello|hello syscall returned 2026
lab1|add2test|add2(20, 6) returned 26
lab2|pstatetest|pstate(self) =
lab2|pcounttest|pcount(RUNNING) =
lab2|pcounttest|pcount(99) = -1
lab2|pchildtest|pstate(child) =
lab3|pgcounttest|pgcounttest done
lab3|memstattest|memstattest done
lab4|fcounttest|fcounttest done
lab4|fdcounttest|fdcounttest done
lab4|fdinfotest|fdinfotest done
"

usage() {
  cat <<'EOF'
labctl — OUC xv6 Lab Kit 课程命令入口（统一封装现有脚本）

用法:
  bash scripts/labctl.sh <command> [args]

环境/构建:
  doctor            只读环境体检                  -> scripts/xv6/doctor.sh
  setup --yes       清基线+应用 0001-0009+make    -> scripts/xv6/apply-integrated-labs.sh --make --yes
                    (会 reset/clean ignored 的 external/xv6-riscv/，必须显式 --yes)
  boot              启动 xv6 并抓 boot 证据       -> scripts/xv6/boot-xv6.sh
  clean             清理卡住的 QEMU/make 进程     -> scripts/xv6/cleanup-qemu.sh

按 lab 测试 (需要先 setup 构建成功):
  test lab1|lab2|lab3|lab4   只跑该 lab 的检查项
  test lab0                  等价于 boot
  test lab5 | test all       跑全部 10 项用户程序检查
  test <程序名>              只跑该程序的检查项 (如 test memstattest)
  list                       打印 lab -> 测试矩阵, 不运行任何东西

完整验证:
  verify            一键 full 验证 (clean apply+make+boot+全部测试)
                                                  -> scripts/xv6/teammate-verify.sh --full
  quick             make 已成功后的快速重测       -> scripts/xv6/teammate-verify.sh --quick
  precheck          队长录屏前预检                -> scripts/xv6/local-verify.sh --quick

助教/提交:
  grade [args]      批量解析学生 summary          -> scripts/grade-summaries.sh
  consistency       文档/脚本一致性检查           -> scripts/check-docs-consistency.sh
  hygiene           提交前仓库卫生检查            -> scripts/check-final-hygiene.sh
  evidence          外部证据 SHA256 核验          -> scripts/check-evidence-sha256.sh
  report            重新生成提交材料索引          -> scripts/collect-report.sh

说明:
  - 所有 make/QEMU 子命令都要求 WSL2 Ubuntu 或等价 Linux。
  - test 失败时先看 docs/troubleshooting.md；卡住先跑 labctl clean。
  - 本脚本只做转发与测试矩阵，不重复实现任何验证逻辑。
EOF
}

run_matrix_lines() {
  # $1 = newline-separated "lab|prog|expected" lines
  lines="$1"
  total=0
  failed=0
  while IFS='|' read -r lab prog expected; do
    [ -z "$prog" ] && continue
    total=$((total + 1))
    echo "[RUN]  ${lab} ${prog} -> expect: ${expected}"
    if bash scripts/xv6/run-xv6-command.sh "$prog" "$expected"; then
      echo "[OK]   ${lab} ${prog}"
    else
      echo "[FAIL] ${lab} ${prog} (expected: ${expected})"
      failed=$((failed + 1))
    fi
    echo
  done <<EOF
$lines
EOF
  echo "labctl test result: $((total - failed))/${total} passed"
  if [ "$failed" -gt 0 ]; then
    echo "[FAIL] ${failed} check(s) failed. See docs/troubleshooting.md; if QEMU is stuck run: bash scripts/labctl.sh clean"
    return 1
  fi
  echo "[OK]   all selected checks passed (timeout-captured evidence, not a stability test)"
  return 0
}

cmd="${1:-help}"
[ "$#" -gt 0 ] && shift

case "$cmd" in
  help|-h|--help)
    usage
    ;;
  doctor)
    exec bash scripts/xv6/doctor.sh "$@"
    ;;
  setup|build)
    if [ "${1:-}" != "--yes" ]; then
      echo "[ERROR] labctl setup 会 reset/clean ignored 的 external/xv6-riscv/ 并应用 integrated 0001-0009。"
      echo "[ERROR] 确认无未保存修改后，请显式运行: bash scripts/labctl.sh setup --yes"
      exit 1
    fi
    exec bash scripts/xv6/apply-integrated-labs.sh --make --yes
    ;;
  boot)
    exec bash scripts/xv6/boot-xv6.sh "$@"
    ;;
  clean)
    exec bash scripts/xv6/cleanup-qemu.sh "$@"
    ;;
  verify)
    exec bash scripts/xv6/teammate-verify.sh --full
    ;;
  quick)
    exec bash scripts/xv6/teammate-verify.sh --quick
    ;;
  precheck)
    exec bash scripts/xv6/local-verify.sh --quick
    ;;
  grade)
    exec bash scripts/grade-summaries.sh "$@"
    ;;
  consistency)
    exec bash scripts/check-docs-consistency.sh "$@"
    ;;
  hygiene)
    exec bash scripts/check-final-hygiene.sh "$@"
    ;;
  evidence)
    exec bash scripts/check-evidence-sha256.sh "$@"
    ;;
  report)
    exec bash scripts/collect-report.sh "$@"
    ;;
  list)
    echo "lab -> test matrix (every line is one run-xv6-command.sh check):"
    echo
    printf '%-6s %-13s %s\n' "LAB" "PROGRAM" "EXPECTED OUTPUT"
    while IFS='|' read -r lab prog expected; do
      [ -z "$prog" ] && continue
      printf '%-6s %-13s %s\n' "$lab" "$prog" "$expected"
    done <<EOF
$MATRIX
EOF
    echo
    echo "lab0 = boot evidence (scripts/xv6/boot-xv6.sh); lab5/all = 全部上述检查"
    ;;
  test)
    sel="${1:-}"
    if [ -z "$sel" ]; then
      echo "[ERROR] 用法: bash scripts/labctl.sh test <lab0|lab1|lab2|lab3|lab4|lab5|all|程序名>"
      exit 2
    fi
    case "$sel" in
      lab0)
        exec bash scripts/xv6/boot-xv6.sh
        ;;
      lab1|lab2|lab3|lab4)
        lines="$(printf '%s\n' "$MATRIX" | grep "^${sel}|" || true)"
        ;;
      lab5|all)
        lines="$MATRIX"
        ;;
      *)
        lines="$(printf '%s\n' "$MATRIX" | awk -F'|' -v p="$sel" '$2 == p')"
        if [ -z "$lines" ]; then
          echo "[ERROR] unknown lab or program: ${sel}"
          echo "[ERROR] 可用值见: bash scripts/labctl.sh list"
          exit 2
        fi
        ;;
    esac
    run_matrix_lines "$lines"
    exit "$?"
    ;;
  *)
    echo "[ERROR] unknown command: ${cmd}"
    echo
    usage
    exit 2
    ;;
esac

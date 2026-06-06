#!/usr/bin/env bash
set -u

PROJECT_NAME="proj54-ouc-os-lab"
TS="$(date +%Y%m%d-%H%M%S)"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

cd "$REPO_ROOT" || {
  echo "[ERROR] failed to enter repo root: ${REPO_ROOT}"
  exit 1
}

mkdir -p logs
SUMMARY_FILE="logs/teammate-verify-${TS}.summary.txt"

check_env_status="NOT_RUN"
baseline_status="NOT_RUN"
environment_status="NOT_RUN"
apply_make_status="NOT_RUN"
boot_status="NOT_RUN"
hello_status="NOT_RUN"
add2test_status="NOT_RUN"
pstatetest_status="NOT_RUN"
pcount_running_status="NOT_RUN"
pcount_invalid_status="NOT_RUN"
pchildtest_status="NOT_RUN"
fcounttest_status="NOT_RUN"
interrupted_status="NO"

set_status() {
  key="$1"
  value="$2"
  case "$key" in
    check_env) check_env_status="$value" ;;
    baseline) baseline_status="$value" ;;
    apply_make) apply_make_status="$value" ;;
    boot) boot_status="$value" ;;
    hello) hello_status="$value" ;;
    add2test) add2test_status="$value" ;;
    pstatetest) pstatetest_status="$value" ;;
    pcount_running) pcount_running_status="$value" ;;
    pcount_invalid) pcount_invalid_status="$value" ;;
    pchildtest) pchildtest_status="$value" ;;
    fcounttest) fcounttest_status="$value" ;;
    *) echo "[WARN] unknown status key: ${key}" ;;
  esac
}

aggregate_environment() {
  if [ "$check_env_status" = "PASS" ] && [ "$baseline_status" = "PASS" ]; then
    environment_status="PASS"
  elif [ "$check_env_status" = "NOT_RUN" ] && [ "$baseline_status" = "NOT_RUN" ]; then
    environment_status="NOT_RUN"
  else
    environment_status="FAIL"
  fi
}

aggregate_pcount() {
  if [ "$pcount_running_status" = "PASS" ] && [ "$pcount_invalid_status" = "PASS" ]; then
    echo "PASS"
  elif [ "$pcount_running_status" = "NOT_RUN" ] && [ "$pcount_invalid_status" = "NOT_RUN" ]; then
    echo "NOT_RUN"
  else
    echo "FAIL"
  fi
}

print_command() {
  printf '[CMD]'
  for arg in "$@"; do
    printf ' %q' "$arg"
  done
  printf '\n'
}

run_step() {
  label="$1"
  key="$2"
  shift 2

  echo
  echo "[STEP] ${label}"
  print_command "$@"

  "$@"
  code="$?"

  if [ "$code" -eq 0 ]; then
    set_status "$key" "PASS"
    echo "[PASS] ${label}"
  else
    set_status "$key" "FAIL"
    echo "[FAIL] ${label} (exit ${code})"
  fi

  return "$code"
}

write_summary() {
  aggregate_environment
  pcounttest_status="$(aggregate_pcount)"
  commit="$(git log --oneline -1 2>/dev/null || echo unknown)"

  {
    echo "teammate verification summary"
    echo "project       : ${PROJECT_NAME}"
    echo "time          : $(date -Iseconds 2>/dev/null || date)"
    echo "repo root     : ${REPO_ROOT}"
    echo "commit        : ${commit}"
    echo "user          : $(id -un 2>/dev/null || whoami 2>/dev/null || echo unknown)"
    echo "interrupted   : ${interrupted_status}"
    echo "summary file  : ${SUMMARY_FILE}"
    echo
    echo "| item | status |"
    echo "| --- | --- |"
    echo "| environment | ${environment_status} |"
    echo "| check-env | ${check_env_status} |"
    echo "| baseline | ${baseline_status} |"
    echo "| apply+make | ${apply_make_status} |"
    echo "| boot | ${boot_status} |"
    echo "| hello | ${hello_status} |"
    echo "| add2test | ${add2test_status} |"
    echo "| pstatetest | ${pstatetest_status} |"
    echo "| pcounttest | ${pcounttest_status} |"
    echo "| pcounttest: pcount(RUNNING) | ${pcount_running_status} |"
    echo "| pcounttest: pcount(99) | ${pcount_invalid_status} |"
    echo "| pchildtest | ${pchildtest_status} |"
    echo "| fcounttest | ${fcounttest_status} |"
    echo
    echo "timeout overrides:"
    echo "  XV6_BOOT_TIMEOUT_SECONDS=${XV6_BOOT_TIMEOUT_SECONDS:-default}"
    echo "  XV6_BOOT_RETRIES=${XV6_BOOT_RETRIES:-default}"
    echo "  XV6_COMMAND_TIMEOUT_SECONDS=${XV6_COMMAND_TIMEOUT_SECONDS:-default}"
    echo "  XV6_COMMAND_RETRIES=${XV6_COMMAND_RETRIES:-default}"
    echo "  XV6_MAKE_TIMEOUT_SECONDS=${XV6_MAKE_TIMEOUT_SECONDS:-default}"
    echo
    echo "If any item is FAIL or the script was interrupted, run:"
    echo "  bash scripts/xv6/cleanup-qemu.sh"
    echo
    echo "Do not commit external/xv6-riscv/ or logs/*.log."
    echo "Do not share passwords, tokens, cookies, or private screenshots."
  } | tee "$SUMMARY_FILE"
}

on_interrupt() {
  echo
  echo "[WARN] teammate verification interrupted. Cleaning QEMU and writing summary."
  interrupted_status="YES"
  bash scripts/xv6/cleanup-qemu.sh || true
  write_summary
  exit 130
}

trap on_interrupt INT TERM

echo "${PROJECT_NAME} teammate one-shot verification"
echo "time   : $(date -Iseconds 2>/dev/null || date)"
echo "cwd    : $(pwd)"
echo "uname  : $(uname -a 2>/dev/null || echo unknown)"
echo "commit : $(git log --oneline -1 2>/dev/null || echo unknown)"
echo "user   : $(id -un 2>/dev/null || whoami 2>/dev/null || echo unknown)"
echo "summary: ${SUMMARY_FILE}"
echo
echo "[INFO] Ctrl+C interrupts. Ctrl+Z suspends and is not an exit."
echo "[INFO] If QEMU gets stuck, run: bash scripts/xv6/cleanup-qemu.sh"

overall=0

if ! run_step "environment check" check_env bash scripts/check-env.sh; then
  overall=1
  echo "[STOP] check-env failed; stopping before apply/make and QEMU."
  write_summary
  exit "$overall"
fi

if ! run_step "xv6 baseline check" baseline bash scripts/xv6/check-xv6-baseline.sh; then
  overall=1
  echo "[STOP] baseline check failed; stopping before apply/make and QEMU."
  write_summary
  exit "$overall"
fi

if ! run_step "integrated apply + make" apply_make bash scripts/xv6/apply-integrated-labs.sh --make --yes; then
  overall=1
  echo "[STOP] apply+make failed; stopping before boot and command checks."
  write_summary
  exit "$overall"
fi

if ! run_step "boot evidence" boot bash scripts/xv6/boot-xv6.sh; then
  overall=1
  echo "[STOP] boot failed; stopping before user-program QEMU checks."
  write_summary
  exit "$overall"
fi

run_step "hello syscall output" hello bash scripts/xv6/run-xv6-command.sh hello "hello syscall returned 2026" || overall=1
run_step "add2test output" add2test bash scripts/xv6/run-xv6-command.sh add2test "add2(20, 6) returned 26" || overall=1
run_step "pstatetest output" pstatetest bash scripts/xv6/run-xv6-command.sh pstatetest "pstate(self) =" || overall=1
run_step "pcounttest RUNNING output" pcount_running bash scripts/xv6/run-xv6-command.sh pcounttest "pcount(RUNNING) =" || overall=1
run_step "pcounttest invalid-state output" pcount_invalid bash scripts/xv6/run-xv6-command.sh pcounttest "pcount(99) = -1" || overall=1
run_step "pchildtest output" pchildtest bash scripts/xv6/run-xv6-command.sh pchildtest "pstate(child) =" || overall=1
run_step "fcounttest output" fcounttest bash scripts/xv6/run-xv6-command.sh fcounttest "fcounttest done" || overall=1

echo
if [ "$overall" -eq 0 ]; then
  echo "[OK] teammate verification completed successfully."
else
  echo "[WARN] teammate verification completed with failures."
  echo "[INFO] Run cleanup if QEMU is still present: bash scripts/xv6/cleanup-qemu.sh"
fi

write_summary
exit "$overall"

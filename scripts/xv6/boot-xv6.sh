#!/usr/bin/env bash
set -u

TARGET_DIR="${XV6_TARGET_DIR:-external/xv6-riscv}"
TIMEOUT_SECONDS="${XV6_BOOT_TIMEOUT_SECONDS:-45}"
MAX_ATTEMPTS="${XV6_BOOT_RETRIES:-2}"
TARGET_ABS=""
current_attempt_pid=""
current_log=""

is_positive_int() {
  case "$1" in
    ''|*[!0-9]*) return 1 ;;
    *) [ "$1" -gt 0 ] ;;
  esac
}

log_msg() {
  echo "$1"
  if [ -n "${current_log:-}" ]; then
    echo "$1" >>"$current_log"
  fi
}

print_manual_cleanup_hint() {
  echo "[INFO] If QEMU or make is still stuck from an older Ctrl+Z session, run:"
  echo "       jobs -l"
  echo "       kill %1"
  echo "       pkill -f qemu-system-riscv64 || true"
  echo "       pkill -f \"make qemu\" || true"
}

process_matches_target() {
  pid="$1"
  cmd="$(tr '\0' ' ' <"/proc/${pid}/cmdline" 2>/dev/null || true)"
  cwd="$(readlink "/proc/${pid}/cwd" 2>/dev/null || true)"

  if [ -n "$TARGET_ABS" ]; then
    case "$cwd" in
      "$TARGET_ABS"|"$TARGET_ABS"/*) return 0 ;;
    esac
    case "$cmd" in
      *"$TARGET_ABS"*) return 0 ;;
    esac
  fi

  case "$cmd" in
    *"$TARGET_DIR"*) return 0 ;;
  esac

  return 1
}

cleanup_project_processes() {
  reason="$1"
  pids="$(pgrep -f 'qemu-system-riscv64|make.*qemu' 2>/dev/null || true)"
  killed=0

  for pid in $pids; do
    if [ "$pid" = "$$" ]; then
      continue
    fi

    if process_matches_target "$pid"; then
      cmd="$(tr '\0' ' ' <"/proc/${pid}/cmdline" 2>/dev/null || echo unknown)"
      log_msg "[INFO] cleanup (${reason}): terminating project process ${pid}: ${cmd}"
      kill -TERM "$pid" 2>/dev/null || true
      killed=1
    fi
  done

  if [ "$killed" -eq 1 ]; then
    sleep 1
    for pid in $pids; do
      if kill -0 "$pid" 2>/dev/null && process_matches_target "$pid"; then
        log_msg "[WARN] cleanup (${reason}): force killing project process ${pid}"
        kill -KILL "$pid" 2>/dev/null || true
      fi
    done
  fi
}

stop_current_attempt() {
  reason="$1"
  if [ -n "${current_attempt_pid:-}" ] && kill -0 "$current_attempt_pid" 2>/dev/null; then
    log_msg "[INFO] cleanup (${reason}): terminating current timeout wrapper pid ${current_attempt_pid}"
    kill -TERM "$current_attempt_pid" 2>/dev/null || true
    sleep 1
    if kill -0 "$current_attempt_pid" 2>/dev/null; then
      log_msg "[WARN] cleanup (${reason}): force killing current timeout wrapper pid ${current_attempt_pid}"
      kill -KILL "$current_attempt_pid" 2>/dev/null || true
    fi
  fi
  current_attempt_pid=""
  cleanup_project_processes "$reason"
}

cleanup() {
  status="$?"
  trap - EXIT INT TERM TSTP
  stop_current_attempt "script exit"
  if [ "$status" -ne 0 ]; then
    print_manual_cleanup_hint
  fi
  exit "$status"
}

on_int() {
  echo
  log_msg "[WARN] interrupted; cleaning up current xv6 QEMU attempt."
  exit 130
}

on_term() {
  echo
  log_msg "[WARN] terminated; cleaning up current xv6 QEMU attempt."
  exit 143
}

on_tstp() {
  echo
  log_msg "[WARN] Ctrl+Z/SIGTSTP received. Ctrl+Z suspends jobs instead of exiting, so this script aborts and cleans up."
  exit 148
}

if ! is_positive_int "$TIMEOUT_SECONDS"; then
  echo "[ERROR] XV6_BOOT_TIMEOUT_SECONDS must be a positive integer, got: ${TIMEOUT_SECONDS}"
  exit 2
fi

if ! is_positive_int "$MAX_ATTEMPTS"; then
  echo "[ERROR] XV6_BOOT_RETRIES must be a positive integer, got: ${MAX_ATTEMPTS}"
  exit 2
fi

default_hard_timeout=$((TIMEOUT_SECONDS + 15))
if [ "$default_hard_timeout" -lt 75 ]; then
  default_hard_timeout=75
fi
HARD_TIMEOUT_SECONDS="${XV6_BOOT_HARD_TIMEOUT_SECONDS:-$default_hard_timeout}"

if ! is_positive_int "$HARD_TIMEOUT_SECONDS"; then
  echo "[ERROR] XV6_BOOT_HARD_TIMEOUT_SECONDS must be a positive integer, got: ${HARD_TIMEOUT_SECONDS}"
  exit 2
fi

if ! command -v timeout >/dev/null 2>&1; then
  echo "[ERROR] missing required command: timeout"
  exit 2
fi

trap cleanup EXIT
trap on_int INT
trap on_term TERM
trap on_tstp TSTP

mkdir -p logs
ts="$(date +%Y%m%d-%H%M%S)"

echo "xv6-riscv boot evidence check"
echo "target  : ${TARGET_DIR}"
echo "timeout : ${TIMEOUT_SECONDS}s soft per attempt"
echo "hard cap: ${HARD_TIMEOUT_SECONDS}s per attempt"
echo "attempts: ${MAX_ATTEMPTS}"
echo

if [ ! -d "$TARGET_DIR" ]; then
  echo "[ERROR] missing baseline directory: ${TARGET_DIR}"
  exit 1
fi

if [ ! -f "$TARGET_DIR/Makefile" ]; then
  echo "[ERROR] missing Makefile: ${TARGET_DIR}/Makefile"
  exit 1
fi

TARGET_ABS="$(cd "$TARGET_DIR" && pwd -P)"

if [ "$HARD_TIMEOUT_SECONDS" -le "$TIMEOUT_SECONDS" ]; then
  echo "[WARN] hard timeout (${HARD_TIMEOUT_SECONDS}s) is not greater than soft timeout (${TIMEOUT_SECONDS}s)."
fi

attempt=1
while [ "$attempt" -le "$MAX_ATTEMPTS" ]; do
  log="logs/xv6-boot-${ts}-attempt${attempt}.log"
  current_log="$log"

  echo "[STEP] attempt ${attempt}/${MAX_ATTEMPTS}"
  echo "log     : ${log}"

  {
    echo "command: timeout --kill-after=5s ${HARD_TIMEOUT_SECONDS}s bash -c 'timeout ${TIMEOUT_SECONDS}s make -C ${TARGET_DIR} qemu'"
    echo "date: $(date -Iseconds)"
    echo "attempt: ${attempt}/${MAX_ATTEMPTS}"
    echo "soft timeout seconds: ${TIMEOUT_SECONDS}"
    echo "hard timeout seconds: ${HARD_TIMEOUT_SECONDS}"
    echo "note: timeout exit 124 can be expected because QEMU normally keeps running."
    echo "note: timeout exit 124 does not by itself prove permanent boot failure; check boot evidence text."
    echo "note: outer hard timeout prevents make/qemu from waiting forever."
    echo
  } >"$log"

  start_epoch="$(date +%s)"
  timeout --kill-after=5s "${HARD_TIMEOUT_SECONDS}s" \
    bash -c 'exec timeout "${1}s" make -C "$2" qemu' \
    boot-attempt "$TIMEOUT_SECONDS" "$TARGET_DIR" >>"$log" 2>&1 &
  current_attempt_pid="$!"
  wait "$current_attempt_pid"
  code="$?"
  current_attempt_pid=""
  elapsed=$(( $(date +%s) - start_epoch ))

  cleanup_project_processes "after attempt ${attempt}"

  kernel_found=0
  init_found=0

  if grep -qF "xv6 kernel is booting" "$log"; then
    kernel_found=1
  fi

  if grep -qF "init: starting sh" "$log"; then
    init_found=1
  fi

  timeout_hit=0
  if [ "$code" -eq 124 ]; then
    timeout_hit=1
  elif [ "$elapsed" -ge "$HARD_TIMEOUT_SECONDS" ]; then
    timeout_hit=1
  fi

  {
    echo
    echo "timeout/make exit code: ${code}"
    echo "elapsed seconds: ${elapsed}"
    if [ "$code" -eq 124 ]; then
      echo "note: timeout returned 124; this can mean QEMU was stopped after evidence, or make/qemu exceeded the soft/hard timeout."
    fi
    echo "kernel evidence found: ${kernel_found}"
    echo "init evidence found: ${init_found}"
  } >>"$log"

  if [ "$kernel_found" -eq 1 ] && [ "$init_found" -eq 1 ]; then
    echo "BOOT_EVIDENCE_FOUND" | tee -a "$log"
    echo "[OK] attempt ${attempt}: detected xv6 kernel is booting"
    echo "[OK] attempt ${attempt}: detected init: starting sh"
    if [ "$timeout_hit" -eq 1 ]; then
      echo "[INFO] attempt ${attempt}: timeout hit after ${elapsed}s, after boot evidence was captured."
    fi
    echo "[INFO] QEMU cleanup has been attempted; this is not a long-running stability or manual interaction test."
    echo "[INFO] Manual QEMU exit sequence, when used interactively: Ctrl-a then x."
    exit 0
  fi

  echo "BOOT_EVIDENCE_NOT_FOUND" >>"$log"
  if [ "$kernel_found" -eq 1 ]; then
    echo "[OK] attempt ${attempt}: detected xv6 kernel is booting"
  else
    echo "[WARN] attempt ${attempt}: missing xv6 kernel is booting"
  fi

  if [ "$init_found" -eq 1 ]; then
    echo "[OK] attempt ${attempt}: detected init: starting sh"
  else
    echo "[WARN] attempt ${attempt}: missing init: starting sh"
  fi

  if [ "$timeout_hit" -eq 1 ]; then
    echo "[WARN] attempt ${attempt}: timeout hit (exit ${code}, elapsed ${elapsed}s; soft ${TIMEOUT_SECONDS}s, hard ${HARD_TIMEOUT_SECONDS}s)."
  else
    echo "[WARN] attempt ${attempt}: make/qemu exited with code ${code} before complete boot evidence was found."
  fi
  echo "[WARN] attempt ${attempt} did not find complete boot evidence."
  echo "[WARN] log path: ${log}"

  attempt=$((attempt + 1))
  if [ "$attempt" -le "$MAX_ATTEMPTS" ]; then
    echo "[INFO] next attempt: ${attempt}/${MAX_ATTEMPTS}"
    echo
  fi
done

echo "BOOT_EVIDENCE_NOT_FOUND"
echo "[WARN] all ${MAX_ATTEMPTS} attempt(s) failed to find complete boot evidence."
echo "[WARN] Do not claim boot success without evidence."
print_manual_cleanup_hint
exit 1

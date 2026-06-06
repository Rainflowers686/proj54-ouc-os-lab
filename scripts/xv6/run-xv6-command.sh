#!/usr/bin/env bash
set -u

TARGET_DIR="${XV6_TARGET_DIR:-external/xv6-riscv}"
TIMEOUT_SECONDS="${XV6_COMMAND_TIMEOUT_SECONDS:-60}"
MAX_ATTEMPTS="${XV6_COMMAND_RETRIES:-2}"
COMMAND_TEXT="${1:-hello}"
EXPECTED_TEXT="${2:-hello syscall returned 2026}"
TARGET_ABS=""
current_attempt_pid=""
current_log=""

safe_name="$(printf '%s' "$COMMAND_TEXT" | tr -c 'A-Za-z0-9_' '_')"
ts="$(date +%Y%m%d-%H%M%S)"

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
  log_msg "[WARN] interrupted; cleaning up current xv6 command attempt."
  exit 130
}

on_term() {
  echo
  log_msg "[WARN] terminated; cleaning up current xv6 command attempt."
  exit 143
}

on_tstp() {
  echo
  log_msg "[WARN] Ctrl+Z/SIGTSTP received. Ctrl+Z suspends jobs instead of exiting, so this script aborts and cleans up."
  exit 148
}

if ! is_positive_int "$TIMEOUT_SECONDS"; then
  echo "[ERROR] XV6_COMMAND_TIMEOUT_SECONDS must be a positive integer, got: ${TIMEOUT_SECONDS}"
  exit 2
fi

if ! is_positive_int "$MAX_ATTEMPTS"; then
  echo "[ERROR] XV6_COMMAND_RETRIES must be a positive integer, got: ${MAX_ATTEMPTS}"
  exit 2
fi

default_hard_timeout=$((TIMEOUT_SECONDS + 15))
if [ "$default_hard_timeout" -lt 75 ]; then
  default_hard_timeout=75
fi
HARD_TIMEOUT_SECONDS="${XV6_COMMAND_HARD_TIMEOUT_SECONDS:-$default_hard_timeout}"

if ! is_positive_int "$HARD_TIMEOUT_SECONDS"; then
  echo "[ERROR] XV6_COMMAND_HARD_TIMEOUT_SECONDS must be a positive integer, got: ${HARD_TIMEOUT_SECONDS}"
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

echo "xv6-riscv command evidence check"
echo "target  : ${TARGET_DIR}"
echo "command : ${COMMAND_TEXT}"
echo "expect  : ${EXPECTED_TEXT}"
echo "timeout : ${TIMEOUT_SECONDS}s soft per attempt"
echo "hard cap: ${HARD_TIMEOUT_SECONDS}s per QEMU attempt"
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
  log="logs/xv6-command-${safe_name}-${ts}-attempt${attempt}.log"
  current_log="$log"

  echo "[STEP] attempt ${attempt}/${MAX_ATTEMPTS}"
  echo "log     : ${log}"

  {
    echo "command: send '${COMMAND_TEXT}' to xv6 via make qemu"
    echo "date: $(date -Iseconds)"
    echo "attempt: ${attempt}/${MAX_ATTEMPTS}"
    echo "soft timeout seconds: ${TIMEOUT_SECONDS}"
    echo "hard timeout seconds: ${HARD_TIMEOUT_SECONDS}"
    echo "note: timeout exit 124 can be expected because QEMU normally keeps running."
    echo "note: fs.img is built before starting QEMU so command input is not consumed by make."
    echo "note: outer hard timeout prevents make/qemu from waiting forever."
    echo
  } >"$log"

  echo "[INFO] attempt ${attempt}: ensuring fs.img is up to date before QEMU..."
  echo "[STEP] make -C ${TARGET_DIR} fs.img" >>"$log"
  timeout --kill-after=5s "${HARD_TIMEOUT_SECONDS}s" make -C "$TARGET_DIR" fs.img >>"$log" 2>&1 &
  current_attempt_pid="$!"
  wait "$current_attempt_pid"
  fs_code="$?"
  current_attempt_pid=""
  cleanup_project_processes "after fs.img attempt ${attempt}"

  if [ "$fs_code" -ne 0 ]; then
    echo "COMMAND_EVIDENCE_NOT_FOUND" | tee -a "$log"
    if [ "$fs_code" -eq 124 ]; then
      echo "[WARN] attempt ${attempt}: timeout hit while building fs.img (exit 124, hard ${HARD_TIMEOUT_SECONDS}s)."
    else
      echo "[WARN] attempt ${attempt}: failed to build fs.img before QEMU (exit ${fs_code})."
    fi
    echo "[WARN] log path: ${log}"
    attempt=$((attempt + 1))
    if [ "$attempt" -le "$MAX_ATTEMPTS" ]; then
      echo "[INFO] next attempt: ${attempt}/${MAX_ATTEMPTS}"
      echo
    fi
    continue
  fi

  start_epoch="$(date +%s)"
  timeout --kill-after=5s "${HARD_TIMEOUT_SECONDS}s" bash -c '
    set -u
    command_text="$1"
    timeout_seconds="$2"
    target_dir="$3"
    (
      i=0
      while [ "$i" -lt "$timeout_seconds" ]; do
        sleep 1
        printf "%s\n" "$command_text"
        i=$((i + 1))
      done
    ) | timeout "${timeout_seconds}s" make -C "$target_dir" qemu
  ' command-attempt "$COMMAND_TEXT" "$TIMEOUT_SECONDS" "$TARGET_DIR" >>"$log" 2>&1 &
  current_attempt_pid="$!"
  wait "$current_attempt_pid"
  code="$?"
  current_attempt_pid=""
  elapsed=$(( $(date +%s) - start_epoch ))

  cleanup_project_processes "after command attempt ${attempt}"

  {
    echo
    echo "timeout/make exit code: ${code}"
    echo "elapsed seconds: ${elapsed}"
  } >>"$log"

  if grep -qF -- "$EXPECTED_TEXT" "$log"; then
    echo "COMMAND_EVIDENCE_FOUND" | tee -a "$log"
    echo "[OK] attempt ${attempt}: detected expected output: ${EXPECTED_TEXT}"
    if [ "$code" -eq 124 ] || [ "$elapsed" -ge "$HARD_TIMEOUT_SECONDS" ]; then
      echo "[INFO] attempt ${attempt}: timeout hit after ${elapsed}s, after expected output was captured."
    fi
    echo "[INFO] QEMU cleanup has been attempted; this is not a long-running stability test."
    exit 0
  fi

  echo "COMMAND_EVIDENCE_NOT_FOUND" | tee -a "$log"
  if [ "$code" -eq 124 ] || [ "$elapsed" -ge "$HARD_TIMEOUT_SECONDS" ]; then
    echo "[WARN] attempt ${attempt}: timeout hit before expected output was captured (exit ${code}, elapsed ${elapsed}s; soft ${TIMEOUT_SECONDS}s, hard ${HARD_TIMEOUT_SECONDS}s)."
  else
    echo "[WARN] attempt ${attempt}: make/qemu exited with code ${code} before expected output was captured."
  fi
  echo "[WARN] expected output not found: ${EXPECTED_TEXT}"
  echo "[WARN] log path: ${log}"

  attempt=$((attempt + 1))
  if [ "$attempt" -le "$MAX_ATTEMPTS" ]; then
    echo "[INFO] next attempt: ${attempt}/${MAX_ATTEMPTS}"
    echo
  fi
done

echo "[WARN] all ${MAX_ATTEMPTS} attempt(s) failed to capture expected command output."
echo "[WARN] Do not claim command success without real log evidence."
print_manual_cleanup_hint
exit 1

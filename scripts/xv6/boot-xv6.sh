#!/usr/bin/env bash
set -u

TARGET_DIR="${XV6_TARGET_DIR:-external/xv6-riscv}"
TIMEOUT_SECONDS="${XV6_BOOT_TIMEOUT_SECONDS:-45}"
MAX_ATTEMPTS="${XV6_BOOT_RETRIES:-2}"

is_positive_int() {
  case "$1" in
    ''|*[!0-9]*) return 1 ;;
    *) [ "$1" -gt 0 ] ;;
  esac
}

if ! is_positive_int "$TIMEOUT_SECONDS"; then
  echo "[ERROR] XV6_BOOT_TIMEOUT_SECONDS must be a positive integer, got: ${TIMEOUT_SECONDS}"
  exit 2
fi

if ! is_positive_int "$MAX_ATTEMPTS"; then
  echo "[ERROR] XV6_BOOT_RETRIES must be a positive integer, got: ${MAX_ATTEMPTS}"
  exit 2
fi

mkdir -p logs
ts="$(date +%Y%m%d-%H%M%S)"

echo "xv6-riscv boot evidence check"
echo "target  : ${TARGET_DIR}"
echo "timeout : ${TIMEOUT_SECONDS}s per attempt"
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

attempt=1
while [ "$attempt" -le "$MAX_ATTEMPTS" ]; do
  log="logs/xv6-boot-${ts}-attempt${attempt}.log"

  echo "[STEP] attempt ${attempt}/${MAX_ATTEMPTS}"
  echo "log     : ${log}"

  {
    echo "command: timeout ${TIMEOUT_SECONDS}s make -C ${TARGET_DIR} qemu"
    echo "date: $(date -Iseconds)"
    echo "attempt: ${attempt}/${MAX_ATTEMPTS}"
    echo "note: timeout exit 124 can be expected because QEMU normally keeps running."
    echo "note: timeout exit 124 does not by itself prove permanent boot failure; check boot evidence text."
    echo
  } >"$log"

  timeout "${TIMEOUT_SECONDS}s" make -C "$TARGET_DIR" qemu >>"$log" 2>&1
  code="$?"

  kernel_found=0
  init_found=0

  if grep -q "xv6 kernel is booting" "$log"; then
    kernel_found=1
  fi

  if grep -q "init: starting sh" "$log"; then
    init_found=1
  fi

  {
    echo
    echo "timeout/make exit code: ${code}"
    if [ "$code" -eq 124 ]; then
      echo "note: timeout returned 124; this can mean QEMU was stopped after evidence, or make/qemu exceeded the timeout."
    fi
    echo "kernel evidence found: ${kernel_found}"
    echo "init evidence found: ${init_found}"
  } >>"$log"

  if [ "$kernel_found" -eq 1 ] && [ "$init_found" -eq 1 ]; then
    echo "BOOT_EVIDENCE_FOUND" | tee -a "$log"
    echo "[OK] attempt ${attempt}: detected xv6 kernel is booting"
    echo "[OK] attempt ${attempt}: detected init: starting sh"
    echo "[INFO] QEMU was stopped by timeout; this is not a long-running stability or manual interaction test."
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

  echo "[WARN] attempt ${attempt} did not find complete boot evidence. See log: ${log}"
  if [ "$code" -eq 124 ]; then
    echo "[WARN] timeout returned 124; this is not automatically a permanent boot failure."
  fi

  attempt=$((attempt + 1))
  if [ "$attempt" -le "$MAX_ATTEMPTS" ]; then
    echo "[INFO] retrying boot evidence capture..."
    echo
  fi
done

echo "BOOT_EVIDENCE_NOT_FOUND"
echo "[WARN] all ${MAX_ATTEMPTS} attempt(s) failed to find complete boot evidence."
echo "[WARN] Do not claim boot success without evidence."
exit 1

#!/usr/bin/env bash
set -u

TARGET_DIR="${XV6_TARGET_DIR:-external/xv6-riscv}"

check_file() {
  path="$1"
  label="$2"
  if [ -e "$path" ]; then
    echo "[OK]   ${label}: ${path}"
    return 0
  fi
  echo "[WARN] ${label} missing: ${path}"
  return 1
}

check_cmd() {
  cmd="$1"
  note="$2"
  if command -v "$cmd" >/dev/null 2>&1; then
    echo "[OK]   ${cmd} -> $(command -v "$cmd")"
    return 0
  fi
  echo "[WARN] ${cmd} not found in PATH - ${note}"
  return 1
}

run_make() {
  mkdir -p logs
  ts="$(date +%Y%m%d-%H%M%S)"
  log="logs/xv6-make-${ts}.log"

  echo "[INFO] running make in ${TARGET_DIR}"
  echo "[INFO] full output will be saved to ${log}"

  {
    echo "command: make -C ${TARGET_DIR}"
    echo "date: $(date -Iseconds)"
    echo
    make -C "$TARGET_DIR"
  } >"$log" 2>&1
  code="$?"

  if [ "$code" -eq 0 ]; then
    echo "[OK] make completed successfully. Log: ${log}"
  else
    echo "[WARN] make failed with exit code ${code}. Log: ${log}"
  fi

  echo "Record the real result in docs/04_test_report.md or labs/lab0-env-setup/README.md. Do not fake success."
  return "$code"
}

mode="${1:-check}"

case "$mode" in
  check)
    ;;
  --make)
    ;;
  -h|--help)
    cat <<EOF
Usage:
  bash scripts/xv6/check-xv6-baseline.sh          Check local baseline files and tools.
  bash scripts/xv6/check-xv6-baseline.sh --make   Run make and save output to logs/.

This script never claims build success unless make really exits 0.
EOF
    exit 0
    ;;
  *)
    echo "[ERROR] unknown argument: ${mode}"
    exit 2
    ;;
esac

echo "xv6-riscv baseline check"
echo "target: ${TARGET_DIR}"
echo

check_file "$TARGET_DIR" "baseline directory"
check_file "$TARGET_DIR/Makefile" "Makefile"
check_file "$TARGET_DIR/LICENSE" "LICENSE"

echo
echo "Toolchain checks:"
check_cmd qemu-system-riscv64 "needed to boot xv6 under QEMU"
check_cmd riscv64-unknown-elf-gcc "bare-metal RISC-V compiler; optional if Makefile supports linux-gnu prefix"
check_cmd riscv64-linux-gnu-gcc "Linux-target RISC-V compiler; current WSL2 environment uses this"

echo
if [ "$mode" = "--make" ]; then
  if [ ! -d "$TARGET_DIR" ]; then
    echo "[ERROR] cannot run make; missing baseline directory: ${TARGET_DIR}"
    exit 1
  fi
  if [ ! -f "$TARGET_DIR/Makefile" ]; then
    echo "[ERROR] cannot run make; missing Makefile: ${TARGET_DIR}/Makefile"
    exit 1
  fi
  run_make
else
  echo "No make command was run. Use --make only after team-lead confirmation."
fi

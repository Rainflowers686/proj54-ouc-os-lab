#!/usr/bin/env bash
# Apply the lab1 hello-syscall patch onto a clean xv6-riscv baseline.
#
# Safety model:
# - Default mode is PREVIEW only: it inspects state and prints what would happen,
#   and does NOT modify anything.
# - --run actually resets the IGNORED third-party tree to the baseline commit
#   (git reset --hard + git clean -fdx) and applies the patch.
# - --make additionally builds (only with --run). Build is never automatic.
# - This script never claims success it did not observe; make/apply exit codes
#   are reported as-is. It only operates inside the ignored baseline directory.
set -u

TARGET_DIR="${XV6_TARGET_DIR:-external/xv6-riscv}"
BASELINE_COMMIT="${XV6_BASELINE_COMMIT:-74f84181a3404d1d6a6ff98d342233979066ebb8}"
PATCH_REL="patches/lab1-system-call/0001-add-hello-syscall.patch"

usage() {
  cat <<EOF
Usage:
  bash scripts/xv6/apply-lab1-patch.sh            Preview only (no changes).
  bash scripts/xv6/apply-lab1-patch.sh --run      Reset clean baseline + apply patch.
  bash scripts/xv6/apply-lab1-patch.sh --run --make
                                                  Also run make after applying.

Notes:
  - Operates only inside the ignored third-party tree: ${TARGET_DIR}
  - --run runs 'git reset --hard ${BASELINE_COMMIT}' and 'git clean -fdx' in that
    tree, which DISCARDS local changes there. The tracked patch is the source of truth.
  - Override with env XV6_TARGET_DIR / XV6_BASELINE_COMMIT.
EOF
}

DO_RUN=0
DO_MAKE=0
for arg in "$@"; do
  case "$arg" in
    --run)  DO_RUN=1 ;;
    --make) DO_MAKE=1 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "[ERROR] unknown argument: ${arg}"; usage; exit 2 ;;
  esac
done
# --make implies --run (cannot build without applying first)
if [ "$DO_MAKE" -eq 1 ]; then
  DO_RUN=1
fi

if [ ! -d "$TARGET_DIR" ]; then
  echo "[WARN] baseline directory not found: ${TARGET_DIR}"
  echo "       Fetch it first (after authorization): bash scripts/xv6/fetch-xv6.sh --run"
  exit 1
fi
if [ ! -d "$TARGET_DIR/.git" ]; then
  echo "[WARN] ${TARGET_DIR} is not a git repository; cannot reset to baseline commit."
  exit 1
fi
if [ ! -f "$PATCH_REL" ]; then
  echo "[ERROR] patch not found: ${PATCH_REL}"
  exit 1
fi

PATCH_ABS="$(pwd)/${PATCH_REL}"
current_head="$(git -C "$TARGET_DIR" rev-parse HEAD 2>/dev/null)"

echo "xv6 lab1 patch apply helper"
echo "target dir      : ${TARGET_DIR} (ignored by .gitignore; not committed)"
echo "patch           : ${PATCH_REL}"
echo "baseline commit : ${BASELINE_COMMIT}"
echo "current HEAD    : ${current_head:-unknown}"
echo

if [ "$DO_RUN" -eq 0 ]; then
  echo "MODE: preview only (no changes made)."
  echo
  echo "What --run would do:"
  echo "  1. git -C ${TARGET_DIR} reset --hard ${BASELINE_COMMIT}"
  echo "  2. git -C ${TARGET_DIR} clean -fdx"
  echo "  3. git -C ${TARGET_DIR} apply --check ${PATCH_REL}"
  echo "  4. git -C ${TARGET_DIR} apply ${PATCH_REL}"
  echo "  (with --make) 5. make -C ${TARGET_DIR}"
  echo
  echo "Dry-run apply check against current tree state:"
  if git -C "$TARGET_DIR" apply --check "$PATCH_ABS" 2>/dev/null; then
    echo "  [OK] patch applies cleanly to the CURRENT tree state."
  else
    echo "  [INFO] patch does not apply cleanly to the CURRENT tree (it may already be applied,"
    echo "         or the tree is not at clean baseline). Use --run to reset to clean baseline first."
  fi
  echo
  echo "No changes were made. Re-run with --run to apply."
  exit 0
fi

# --- --run path: actually reset clean baseline and apply ---
echo "MODE: run (this will reset and clean the ignored baseline tree)."

if ! git -C "$TARGET_DIR" cat-file -e "${BASELINE_COMMIT}^{commit}" 2>/dev/null; then
  echo "[ERROR] baseline commit not found locally: ${BASELINE_COMMIT}"
  echo "        Fetch/update the baseline first."
  exit 1
fi

echo "[STEP] reset --hard ${BASELINE_COMMIT}"
git -C "$TARGET_DIR" reset --hard "$BASELINE_COMMIT" >/dev/null 2>&1 || {
  echo "[ERROR] git reset --hard failed."; exit 1; }

echo "[STEP] clean -fdx"
git -C "$TARGET_DIR" clean -fdx >/dev/null 2>&1 || {
  echo "[ERROR] git clean failed."; exit 1; }

if [ -n "$(git -C "$TARGET_DIR" status --porcelain)" ]; then
  echo "[ERROR] tree is not clean after reset/clean; aborting."
  exit 1
fi
echo "[OK] clean baseline at $(git -C "$TARGET_DIR" rev-parse HEAD)"

echo "[STEP] git apply --check"
if ! git -C "$TARGET_DIR" apply --check "$PATCH_ABS"; then
  echo "[ERROR] patch does not apply cleanly to clean baseline. Patch may need regeneration."
  exit 1
fi
echo "[OK] patch applies cleanly (--check passed)."

echo "[STEP] git apply"
if ! git -C "$TARGET_DIR" apply "$PATCH_ABS"; then
  echo "[ERROR] git apply failed unexpectedly after --check passed."
  exit 1
fi
echo "[OK] patch applied. Changed files:"
git -C "$TARGET_DIR" status --short

if [ "$DO_MAKE" -eq 0 ]; then
  echo
  echo "Build not run (no --make). To build and capture a log:"
  echo "  bash scripts/xv6/check-xv6-baseline.sh --make"
  exit 0
fi

echo
echo "[STEP] make -C ${TARGET_DIR}"
mkdir -p logs
ts="$(date +%Y%m%d-%H%M%S)"
log="logs/xv6-make-${ts}.log"
{
  echo "command: make -C ${TARGET_DIR} (after apply-lab1-patch.sh --run --make)"
  echo "date: $(date -Iseconds)"
  echo
  make -C "$TARGET_DIR"
} >"$log" 2>&1
code="$?"
if [ "$code" -eq 0 ]; then
  echo "[OK] make completed successfully. Log: ${log} (ignored by Git)"
else
  echo "[WARN] make failed with exit code ${code}. Log: ${log} (ignored by Git)"
fi
echo "Record the real result in docs/04_test_report.md. Do not fake success."
exit "$code"

#!/usr/bin/env bash
set -u

UPSTREAM_URL="${XV6_UPSTREAM_URL:-https://github.com/mit-pdos/xv6-riscv.git}"
TARGET_DIR="${XV6_TARGET_DIR:-external/xv6-riscv}"
RECORD_FILE="${XV6_RECORD_FILE:-external/xv6-baseline-record.md}"

usage() {
  cat <<EOF
Usage:
  bash scripts/xv6/fetch-xv6.sh          Preview the planned clone command.
  bash scripts/xv6/fetch-xv6.sh --run    Clone xv6-riscv if the target is absent.
  bash scripts/xv6/fetch-xv6.sh --status Show current local baseline status.

Defaults:
  upstream: ${UPSTREAM_URL}
  target  : ${TARGET_DIR}
  record  : ${RECORD_FILE}
EOF
}

is_git_repo() {
  [ -d "$TARGET_DIR/.git" ]
}

print_repo_status() {
  if ! is_git_repo; then
    echo "[WARN] xv6 baseline git repo not found: ${TARGET_DIR}"
    return 1
  fi

  branch="$(git -C "$TARGET_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "UNKNOWN")"
  commit="$(git -C "$TARGET_DIR" rev-parse HEAD 2>/dev/null || echo "UNKNOWN")"
  remote="$(git -C "$TARGET_DIR" remote get-url origin 2>/dev/null || echo "UNKNOWN")"

  echo "[OK] xv6 baseline exists: ${TARGET_DIR}"
  echo "branch : ${branch}"
  echo "commit : ${commit}"
  echo "remote : ${remote}"
}

write_record() {
  mkdir -p "$(dirname "$RECORD_FILE")"

  if is_git_repo; then
    branch="$(git -C "$TARGET_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "UNKNOWN")"
    commit="$(git -C "$TARGET_DIR" rev-parse HEAD 2>/dev/null || echo "UNKNOWN")"
    remote="$(git -C "$TARGET_DIR" remote get-url origin 2>/dev/null || echo "UNKNOWN")"
  else
    branch="TODO: baseline not fetched"
    commit="TODO: baseline not fetched"
    remote="TODO: baseline not fetched"
  fi

  if [ -f "$TARGET_DIR/LICENSE" ]; then
    license_status="yes"
  else
    license_status="no"
  fi

  generated_at="$(date -Iseconds)"

  cat > "$RECORD_FILE" <<EOF
# xv6-riscv Baseline Record

This file records metadata for the local xv6-riscv baseline used by proj54-ouc-os-lab.
It is safe to commit this metadata file. Do not commit the third-party source tree at \`${TARGET_DIR}/\`.

| Field | Value |
| --- | --- |
| Upstream URL | \`${UPSTREAM_URL}\` |
| Local path | \`${TARGET_DIR}\` |
| Current commit hash | \`${commit}\` |
| Current branch | \`${branch}\` |
| Remote URL | \`${remote}\` |
| LICENSE file exists | ${license_status} |
| Record generated at | ${generated_at} |
| Built | no, pending real \`make\` |

## Notes

- \`${TARGET_DIR}/\` is ignored by \`.gitignore\` and should not be committed as third-party source code.
- This record does not claim that xv6-riscv has been built or booted.
- Future build logs should be generated only from real commands and recorded under \`logs/\` or summarized in project docs.
EOF

  echo "[OK] baseline metadata written: ${RECORD_FILE}"
}

mode="${1:-preview}"

case "$mode" in
  preview)
    echo "Preview only. No network operation will be performed."
    echo "Planned command:"
    echo "  git clone ${UPSTREAM_URL} ${TARGET_DIR}"
    echo
    echo "Run with --run after team-lead authorization."
    ;;
  --run)
    if [ -e "$TARGET_DIR" ]; then
      echo "[WARN] target already exists; not overwriting: ${TARGET_DIR}"
      print_repo_status
      write_record
      exit 0
    fi

    mkdir -p "$(dirname "$TARGET_DIR")"
    echo "[INFO] cloning xv6-riscv baseline..."
    echo "upstream: ${UPSTREAM_URL}"
    echo "target  : ${TARGET_DIR}"

    if git clone "$UPSTREAM_URL" "$TARGET_DIR"; then
      echo "[OK] clone completed."
      print_repo_status
      write_record
      echo "[INFO] ${TARGET_DIR}/ is ignored by .gitignore and should not be committed."
    else
      code="$?"
      echo "[ERROR] clone failed with exit code ${code}."
      exit "$code"
    fi
    ;;
  --status)
    print_repo_status
    if is_git_repo; then
      write_record
    fi
    ;;
  -h|--help)
    usage
    ;;
  *)
    echo "[ERROR] unknown argument: ${mode}"
    usage
    exit 2
    ;;
esac

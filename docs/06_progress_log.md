# Progress Log

## Rules

- Record only real work.
- Use `TODO`, `pending`, or `not run` for unfinished or unverified items.
- Do not invent commit hashes, test output, build success, or QEMU screenshots.

## 2026-06-03: Scaffold and MVP v0.1

- Commit hash: TODO after commit
- Completed:
  - Project scaffold initialized.
  - Platform placeholder `main.py` removed; reason: `replace platform placeholder with project scaffold`.
  - README, docs, labs, scripts, tests, references, slides, videos, and submissions structure created.
  - MVP v0.1 docs and lightweight scripts prepared.
  - GitHub collaboration workflow configured.
- Verification:
  - `bash scripts/check-env.sh`
  - `bash scripts/run-lab.sh lab0`
  - `bash scripts/run-lab.sh lab1`
  - `bash scripts/collect-report.sh`
  - `git diff --check`

## 2026-06-03: stage1b fetch xv6 baseline and record metadata

- Commit hash: TODO after commit
- Completed:
  - Added `scripts/xv6/fetch-xv6.sh`.
  - Added `scripts/xv6/check-xv6-baseline.sh`.
  - Added `logs/README.md`.
  - Updated `.gitignore` to ignore `external/xv6-riscv/` and `logs/*.log` while keeping metadata docs tracked.
  - Updated baseline plan, external directory notes, lab0 environment docs, reference/license notes, AI usage record, and report index script.
  - Actual baseline fetch is authorized for this stage.
- Real environment status from WSL2 Ubuntu 24.04:
  - `git`: OK
  - `bash`: OK
  - `make`: OK
  - `qemu-system-riscv64`: OK
  - `riscv64-linux-gnu-gcc`: OK
  - `riscv64-unknown-elf-gcc`: WARN
- To be filled after stage1b command execution:
  - xv6 clone result: completed in `external/xv6-riscv/`
  - xv6 commit hash: `74f84181a3404d1d6a6ff98d342233979066ebb8`
  - xv6 branch: `riscv`
  - xv6 remote: `https://github.com/mit-pdos/xv6-riscv.git`
  - `external/xv6-baseline-record.md`: generated
  - baseline structure check: `external/xv6-riscv/`, `Makefile`, and `LICENSE` are present
  - toolchain check: `qemu-system-riscv64` OK, `riscv64-linux-gnu-gcc` OK, `riscv64-unknown-elf-gcc` WARN
- Explicitly not run:
  - `bash scripts/xv6/check-xv6-baseline.sh --make`
  - `make`
  - QEMU boot
- Next:
  - Run fetch/status/check scripts.
  - Confirm `external/xv6-riscv/` is ignored.
  - Do not run `make` until team lead authorizes it.

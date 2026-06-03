# Test Report

This document records real test and verification results for `proj54-ouc-os-lab`.

Rules:

- Record only commands that were actually run.
- Do not claim QEMU boot success unless `make qemu` or an equivalent boot command has really completed.
- Do not commit raw `logs/*.log` files by default.
- Summarize only key command, environment, result, and risk information.

## Test Records

### xv6-riscv baseline build test

| Field | Value |
| --- | --- |
| Test name | xv6-riscv baseline build test |
| Date/time | 2026-06-03 23:50:03 +08:00 |
| Command | `bash scripts/xv6/check-xv6-baseline.sh --make` |
| Baseline path | `external/xv6-riscv/` |
| Baseline commit | `74f84181a3404d1d6a6ff98d342233979066ebb8` |
| Result | make completed successfully |
| Log file | `logs/xv6-make-20260603-235003.log` |
| Raw log tracked by Git | no, ignored by `.gitignore` |
| QEMU boot status | TODO: not run |

#### Environment Summary

| Item | Status |
| --- | --- |
| baseline directory | OK |
| `Makefile` | OK |
| `LICENSE` | OK |
| `qemu-system-riscv64` | OK |
| `riscv64-linux-gnu-gcc` | OK |
| `riscv64-unknown-elf-gcc` | WARN: missing |

#### Build Evidence Summary

- The build used `riscv64-linux-gnu-gcc` and `riscv64-linux-gnu-ld`.
- Kernel-related build artifacts were generated during the build.
- The linker emitted a `LOAD segment with RWX permissions` warning.
- Despite the warning, `make` exited successfully.

#### Not Covered

- `make qemu` was not run.
- xv6 boot into shell was not verified.
- lab1 system call implementation was not started or verified.

#### Risks and Follow-Up

| Risk | Status / Follow-up |
| --- | --- |
| Repository path contains spaces | Build succeeded once in the current path, but WSL-native paths without spaces may still be safer for later work. |
| `riscv64-unknown-elf-gcc` missing | Current make succeeded with `riscv64-linux-gnu-gcc`; keep this recorded and re-check if Makefile behavior changes. |
| linker RWX warning | Build succeeds, but the warning should be understood before final reporting. |
| QEMU boot not verified | Run and record `make qemu` only after team lead confirmation. |

## Template for Future Records

| Field | Value |
| --- | --- |
| Test name | TODO |
| Date/time | TODO |
| Command | TODO |
| Environment | TODO |
| Result | TODO |
| Log or output location | TODO |
| Risks | TODO |
| Follow-up | TODO |

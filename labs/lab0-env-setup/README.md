# lab0: Environment Setup and Baseline Build

## Goal

lab0 helps students prepare the OS lab environment, inspect required tools, fetch the xv6-riscv baseline metadata, and record the first real baseline build result.

## Recommended Environment

Current target environment:

- Windows 11 + WSL2 Ubuntu 24.04
- Git
- bash
- make
- QEMU RISC-V
- RISC-V cross compiler

## Current Verified Tool Status

`bash scripts/check-env.sh` has been run in WSL2 Ubuntu 24.04.

Observed result:

| Tool | Status | Notes |
| --- | --- | --- |
| `git` | OK | Available in WSL2 |
| `bash` | OK | Available in WSL2 |
| `make` | OK | Available in WSL2 |
| `qemu-system-riscv64` | OK | Available in WSL2 |
| `riscv64-linux-gnu-gcc` | OK | Available in WSL2 |
| `riscv64-unknown-elf-gcc` | WARN | Missing, but `riscv64-linux-gnu-gcc` is available |

This means the local environment is ready for baseline structure checks and baseline build verification.

## Manual Check Commands

```bash
git --version
bash --version
make --version
qemu-system-riscv64 --version
riscv64-linux-gnu-gcc --version
riscv64-unknown-elf-gcc --version
```

## Baseline Fetch Steps

Preview the fetch command:

```bash
bash scripts/xv6/fetch-xv6.sh
```

Fetch the baseline after team-lead authorization:

```bash
bash scripts/xv6/fetch-xv6.sh --run
```

Show current local baseline metadata:

```bash
bash scripts/xv6/fetch-xv6.sh --status
```

The local source tree is stored at:

```text
external/xv6-riscv/
```

This path is ignored by Git and must not be committed.

The metadata file is stored at:

```text
external/xv6-baseline-record.md
```

This metadata file may be committed.

## Baseline Pre-Build Check

After fetching the baseline, check the expected files and tools:

```bash
bash scripts/xv6/check-xv6-baseline.sh
```

The check verifies:

- `external/xv6-riscv/`
- `external/xv6-riscv/Makefile`
- `external/xv6-riscv/LICENSE`
- `qemu-system-riscv64`
- `riscv64-unknown-elf-gcc`
- `riscv64-linux-gnu-gcc`

This command does not run `make`.

## Real Build Verification Record

The team lead has run:

```bash
bash scripts/xv6/check-xv6-baseline.sh --make
```

Real result:

| Item | Result |
| --- | --- |
| Date/time | 2026-06-03 23:50:03 +08:00 |
| Result | make completed successfully |
| Compiler used | `riscv64-linux-gnu-gcc` |
| Linker used | `riscv64-linux-gnu-ld` |
| QEMU tool | `qemu-system-riscv64` detected, but boot not run |
| Warning | linker `LOAD segment with RWX permissions` warning |
| Log file | `logs/xv6-make-20260603-235003.log` |
| Test report | `docs/04_test_report.md` |

This successful `make` only proves that the baseline build completed in this WSL2 environment. It does not prove that xv6 boots successfully.

## Current Status

- xv6-riscv baseline fetch: completed locally under `external/xv6-riscv/`.
- xv6-riscv `make`: completed successfully once.
- Raw make log: ignored by Git; do not commit `logs/*.log`.
- QEMU boot: TODO, not run.
- lab1 system call implementation: TODO, not started.

Do not write "xv6 booted successfully" until `make qemu` or an equivalent boot command has really been run and recorded.

## Common Issues

### Windows path contains spaces

The current repository path contains spaces. The baseline build succeeded once in this path, but WSL-native paths such as `~/workspace/proj54-ouc-os-lab` may still be safer for repeated build and boot work.

### `riscv64-unknown-elf-gcc` is missing

Current WSL2 has `riscv64-linux-gnu-gcc`, and the baseline make succeeded with it. Keep this recorded and re-check if the xv6 Makefile or toolchain setup changes.

### Linker RWX warning

The make log includes a linker `LOAD segment with RWX permissions` warning. The build still completed successfully, but the warning should be understood before final reporting.

### QEMU boot is not verified

`qemu-system-riscv64` is available, but `make qemu` has not been run. Boot success remains TODO.

### Shell script line endings

If a shell script fails with `$'\r': command not found`, check line endings. This repository uses `.gitattributes` and `.editorconfig` to prefer LF.

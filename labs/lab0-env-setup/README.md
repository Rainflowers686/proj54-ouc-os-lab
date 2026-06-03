# lab0: Environment Setup and Baseline Preparation

## Goal

lab0 helps students prepare the OS lab environment, inspect required tools, and fetch the xv6-riscv baseline metadata without claiming any unverified build or boot result.

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

This means the local environment is ready for baseline structure checks. It does not mean xv6 has been built or booted.

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

## Build Status

Current status:

- xv6-riscv baseline fetch: stage1b in progress.
- xv6-riscv `make`: TODO, not run in this stage.
- QEMU boot: TODO, not run in this stage.

Do not write “xv6 built successfully” or “xv6 booted successfully” until the real command has been run and recorded.

## Common Issues

### Windows path contains spaces

The current repository path contains spaces. For actual xv6 work, WSL-native paths such as `~/workspace/proj54-ouc-os-lab` are usually safer than `/mnt/d/...`, especially for build and shell quoting behavior. This is a recommendation, not a verified requirement.

### `riscv64-unknown-elf-gcc` is missing

Current WSL2 has `riscv64-linux-gnu-gcc`, which may be enough depending on the xv6 Makefile prefix detection. This must be confirmed by a real future build.

### QEMU is missing

If `qemu-system-riscv64` is missing, install the proper QEMU package in WSL2 after team-lead authorization. Do not record QEMU boot success without running it.

### Shell script line endings

If a shell script fails with `$'\r': command not found`, check line endings. This repository uses `.gitattributes` and `.editorconfig` to prefer LF.

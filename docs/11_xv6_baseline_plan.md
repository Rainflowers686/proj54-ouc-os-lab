# xv6-riscv Baseline Plan

## Purpose

This document records the plan and current status for fetching the xv6-riscv baseline used by `proj54-ouc-os-lab`.

Current stage: `stage1b: fetch xv6 baseline and record metadata`.

This stage is authorized to clone the upstream xv6-riscv repository into `external/xv6-riscv/`, but it is not authorized to run `make` yet. Build and QEMU boot verification remain TODO until the team lead explicitly confirms the next step.

## Baseline Source

| Item | Value |
| --- | --- |
| Upstream | `https://github.com/mit-pdos/xv6-riscv.git` |
| Local source path | `external/xv6-riscv/` |
| Metadata record | `external/xv6-baseline-record.md` |
| Source submission policy | Do not commit `external/xv6-riscv/` |
| Build status | Not built; pending real `make` |

## Scripts

### `scripts/xv6/fetch-xv6.sh`

Purpose: preview, fetch, inspect, and record xv6 baseline metadata.

```bash
bash scripts/xv6/fetch-xv6.sh
bash scripts/xv6/fetch-xv6.sh --run
bash scripts/xv6/fetch-xv6.sh --status
```

Behavior:

- Default target: `external/xv6-riscv`
- Default upstream: `https://github.com/mit-pdos/xv6-riscv.git`
- Default metadata record: `external/xv6-baseline-record.md`
- Preview mode does not download anything.
- `--run` clones only if the target directory does not already exist.
- Existing targets are never overwritten.
- After clone or status inspection, the script records upstream URL, local path, commit hash, branch, remote URL, LICENSE presence, generation time, and build status.

### `scripts/xv6/check-xv6-baseline.sh`

Purpose: inspect local baseline structure and required tools.

```bash
bash scripts/xv6/check-xv6-baseline.sh
```

Checks:

- `external/xv6-riscv/`
- `external/xv6-riscv/Makefile`
- `external/xv6-riscv/LICENSE`
- `qemu-system-riscv64`
- `riscv64-unknown-elf-gcc`
- `riscv64-linux-gnu-gcc`

The script does not run `make` by default.

Future build command, not authorized in this stage:

```bash
bash scripts/xv6/check-xv6-baseline.sh --make
```

If `--make` is used later, output must be saved to `logs/xv6-make-YYYYMMDD-HHMMSS.log`. Success and failure must both be recorded truthfully.

## Git Policy

- `external/xv6-riscv/` is ignored by `.gitignore` and must not be committed as third-party source code.
- `external/README.md` is tracked.
- `external/xv6-baseline-record.md` is tracked and may be committed as metadata.
- Raw logs under `logs/*.log` are ignored by default.
- `logs/README.md` is tracked.

## Current Real Environment

The WSL2 Ubuntu 24.04 environment has been checked with `bash scripts/check-env.sh`.

Observed status:

- `git`: OK
- `bash`: OK
- `make`: OK
- `qemu-system-riscv64`: OK
- `riscv64-linux-gnu-gcc`: OK
- `riscv64-unknown-elf-gcc`: WARN

At least one RISC-V compiler is available through `riscv64-linux-gnu-gcc`. This is enough to proceed to baseline structure checks, but not enough to claim xv6 has built or booted.

## Acceptance Criteria for Stage1b

Stage1b is complete only when:

- `scripts/xv6/fetch-xv6.sh --run` has either cloned xv6 or reported an existing local clone without overwriting it.
- `external/xv6-baseline-record.md` exists and records the real current commit hash.
- `scripts/xv6/check-xv6-baseline.sh` has checked baseline structure and toolchain presence without running `make`.
- `git status --ignored --short external` confirms `external/xv6-riscv/` is ignored.
- No third-party xv6 source files are staged for commit.

## Explicit Non-Goals

- Do not run `make` in this stage.
- Do not run QEMU in this stage.
- Do not claim build success.
- Do not commit `external/xv6-riscv/`.
- Do not copy large external materials or LICENSE text into project docs; record references and metadata instead.

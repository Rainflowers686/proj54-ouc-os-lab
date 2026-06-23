# external

This directory is reserved for third-party baselines and related metadata.

## Policy

- Third-party source trees under `external/` are not committed as plain source.
- `external/xv6-riscv/` is a local clone target and is ignored by `.gitignore`.
- `external/README.md` and `external/xv6-baseline-record.md` are tracked project metadata.
- Do not place registration materials, private account data, screenshots, tokens, or large binaries here.

## xv6-riscv Baseline

Default upstream:

```text
https://github.com/mit-pdos/xv6-riscv.git
```

Default local path:

```text
external/xv6-riscv
```

Metadata record:

```text
external/xv6-baseline-record.md
```

The metadata record stores the upstream URL, current commit hash, current branch, remote URL, LICENSE presence, generation time, and build status. It does not claim that xv6 has been built or booted.

## Script Usage

Preview only:

```bash
bash scripts/xv6/fetch-xv6.sh
```

Clone after team-lead authorization:

```bash
bash scripts/xv6/fetch-xv6.sh --run
```

Show current local baseline status:

```bash
bash scripts/xv6/fetch-xv6.sh --status
```

Check baseline files and tools without running make:

```bash
bash scripts/xv6/check-xv6-baseline.sh
```

Future build check, not used in stage1b:

```bash
bash scripts/xv6/check-xv6-baseline.sh --make
```

If `--make` is used later, the script writes a real local log under `logs/`. Do not fabricate success or failure results.

## Current Status

- stage1b is authorized to fetch the local xv6 baseline.
- `make` and QEMU boot verification are not authorized in this stage.
- Baseline metadata should be committed; third-party source code should not.

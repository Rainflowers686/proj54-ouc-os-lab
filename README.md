<div align="center">

# **OUC xv6 Lab Kit**

Six xv6-riscv labs for operating-systems coursework at Ocean University of China.

Follow a kernel change from its patch to a QEMU check, with lab instructions, tests and reproduction records alongside the code.

![xv6-riscv](https://img.shields.io/badge/xv6-RISC--V-5A4FCF)
![C](https://img.shields.io/badge/Language-C-A8B9CC?logo=c&logoColor=white)
![Course learning kit](https://img.shields.io/badge/Type-Course%20learning%20kit-687078)

[English](README.md) · [简体中文](README.zh-CN.md)

[Start here](#where-to-start) · [Environment](#environment-and-reproduction) · [Labs](#lab-guide) · [Documentation](#documentation) · [Contributing](CONTRIBUTING.md)

</div>

## Project status

This learning kit covers environment setup, kernel exercises and integrated reproduction. Follow the pinned lab instructions and references: results can vary across environments and upstream revisions. The repository's recorded test outcomes apply to the commits and patch sequences named in those records.

## Where to start

Begin with [Lab 0](labs/lab0-env-setup/README.md) and the [environment guide](docs/final/01_environment_setup.md), then follow the instructions for your lab. The main folders are:

- [labs/](labs/): lab material
- [tests/](tests/): checks used by the project
- [reproducibility/](reproducibility/): reproduction notes and supporting files
- [submissions/](submissions/) and [slides/](slides/): course deliverables

## Environment and reproduction

Use WSL2 Ubuntu 24.04 or a suitable Linux environment with Git, Bash, Make, `qemu-system-riscv64` and `riscv64-linux-gnu-gcc`. PowerShell, Git Bash and MINGW64 are not the recorded environment for Make/QEMU validation.

Start with the read-only environment check from the repository root:

```bash
bash scripts/xv6/doctor.sh
```

The [environment guide](docs/final/01_environment_setup.md) explains how to fetch the pinned xv6 baseline, commit `74f84181a3404d1d6a6ff98d342233979066ebb8`. Once that environment is ready, the [reproduction guide](docs/final/07_teammate_reproduction_guide.md) uses:

```bash
bash scripts/xv6/teammate-verify.sh --full
```

The full run rebuilds the ignored `external/xv6-riscv/` workspace and applies the integrated patches. Preserve any local edits as patches before running it. Record the actual summary; runtime-dependent process counts and states are not fixed expected numbers. QEMU output captured before a timeout does not establish long-term stability.

## Lab guide

| Lab | Focus |
| --- | --- |
| [0: environment](labs/lab0-env-setup/README.md) | Toolchain, baseline build and boot evidence |
| [1: system calls](labs/lab1-system-call/README.md) | `hello`, `add2` and syscall arguments |
| [2: processes](labs/lab2-process-and-scheduling/README.md) | Process state and count observation |
| [3: page tables](labs/lab3-memory-and-pagetable/README.md) | Page-table and address-space observation |
| [4: file tables](labs/lab4-file-system/README.md) | File-table and file-descriptor observation |
| [5: integration](labs/lab5-final-integration/README.md) | Reproduce the combined patch sequence and report the results |

Labs 3 and 4 teach observation of memory and file structures; they are not complete memory-management or filesystem implementations. Lab 5 adds an integrated reproduction exercise, not a new kernel mechanism. See the [known limits](docs/final/11_known_limits_and_future_work.md).

## Documentation

- [Document index](docs/README.md)
- [Teammate reproduction guide](docs/final/07_teammate_reproduction_guide.md)
- [Reference and license statement](docs/final/10_reference_and_license_statement.md)
- [Contribution guide](CONTRIBUTING.md)

Raw logs, summary files, third-party xv6 source and video files remain outside the tracked source. The repository records their status and, where applicable, evidence metadata.

## Rights and sources

The pinned xv6-riscv baseline is MIT-licensed; its source remains in the ignored external workspace. That upstream license is separate from the rights in this project's course documents and incremental work. Preserve the baseline attribution and read [RIGHTS.md](RIGHTS.md) before reuse.

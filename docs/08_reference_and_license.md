# Reference and License Record

## Principles

- Do not copy large blocks of external documentation, source code, papers, slides, or tutorials into this repository.
- Record the name, URL, license, usage location, and modification notes for every external reference.
- Keep third-party source code separate from team-owned docs, scripts, and lab materials.
- Do not claim ownership of upstream xv6-riscv code.
- If third-party source is fetched locally, commit only metadata and project notes unless the team explicitly chooses a compliant tracked import strategy.

## Current Third-Party Baseline

| Name | URL | License | Local path | Metadata record | Current status |
| --- | --- | --- | --- | --- | --- |
| xv6-riscv | `https://github.com/mit-pdos/xv6-riscv.git` | TODO: confirm from upstream `LICENSE` | `external/xv6-riscv/` | `external/xv6-baseline-record.md` | metadata generated; source tree ignored |

`external/xv6-baseline-record.md` is the canonical project record for the local baseline commit, branch, remote URL, LICENSE presence, generation time, and build status. Current recorded commit: `74f84181a3404d1d6a6ff98d342233979066ebb8`.

Do not copy the full upstream LICENSE text into this document. Keep the upstream LICENSE file in the local ignored source tree and record its presence in the metadata file.

## Planned References

| Name | URL | License | Planned usage | Notes |
| --- | --- | --- | --- | --- |
| xv6-riscv book | TODO | TODO | Background reading for xv6 code paths | Do not copy large sections |
| rCore Tutorial | TODO | TODO | Course organization reference | Reference structure only |
| uCore Tutorial | TODO | TODO | Course organization reference | Reference structure only |
| Prior OS contest works | TODO | TODO | Step-by-step process and teaching design reference | Record all adaptation details |

## License Checklist for xv6-riscv

- TODO: confirm the exact upstream repository URL in a browser or through Git metadata.
- TODO: record the fetched commit hash in `external/xv6-baseline-record.md`.
- TODO: confirm the upstream LICENSE type.
- TODO: preserve upstream copyright notices in the local ignored source tree.
- TODO: document any future modifications separately from pristine baseline metadata.
- TODO: ensure `external/xv6-riscv/` is not staged or committed.

## Current Repository Status

The project currently tracks only project-owned docs/scripts and baseline metadata. The xv6-riscv source tree, when fetched under `external/xv6-riscv/`, is ignored and should not be submitted as part of this repository.

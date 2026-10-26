# Contributing to OUC xv6 Lab Kit

Keep each lab's learning objective, patch and verification steps consistent. Read the [document index](docs/README.md) and the lab you are changing before editing.

## Checks and evidence

Use the environment and pinned baseline in [the setup guide](docs/final/01_environment_setup.md). Run `bash scripts/xv6/doctor.sh` first. For a kernel or patch change, follow the [reproduction guide](docs/final/07_teammate_reproduction_guide.md) and record the commit, patch sequence, command and actual result. The full verification rebuilds the ignored xv6 workspace; preserve local changes before running it.

State whether a result came from a local run or an independent teammate. Do not transfer a PASS to a different commit or patch sequence. For documentation-only changes, check paths, commands and both README versions without inventing new execution evidence.

## Materials and attribution

Keep third-party xv6 source in the ignored external directory. Do not commit raw logs, summary files, videos, personal registration materials or credentials. Use the evidence records described by the project and preserve upstream attribution. See [RIGHTS.md](RIGHTS.md).

## 中文说明

每次改动都应让学习目标、补丁和验证方法对应起来。涉及代码时按固定基线复现，写明提交、补丁序列和真实结果；不要把旧提交的 PASS 挪到新提交，也不要把本机测试写成队友独立验证。文档改动核对链接和命令即可，不补造运行记录。原始日志、第三方源码、视频和私人材料按现有规则保留在仓库外。

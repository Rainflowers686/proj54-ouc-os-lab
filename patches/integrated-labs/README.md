# integrated lab patch sequence

## 目的

本目录保存面向最终综合演示的统一 patch sequence，用于在同一个 xv6-riscv 构建中同时演示：

- lab1 minimal syscall：`hello()`
- lab1 advanced syscall：`add2(int a, int b)`
- lab2 process state observation：`pstate(int pid)`
- lab2 process table counting：`pcount(int state)`
- lab3 page-table observation：`pgcount()`
- lab4 file table observation：`fcount()`
- lab4 fd table observation：`fdcount()`
- lab3 advanced 地址空间观察（argaddr + copyout + struct ABI）：`memstat(struct memstat *)`
- lab4 advanced fd 元数据观察（argint + argaddr + copyout + struct ABI）：`fdinfo(int, struct fdinfo *)`

原有 independent patch 仍保留，用于单 lab 教学和单独复现；本目录只作为综合演示路线使用。stage11b 起，current integrated suite 为 `0001-0009`。

## 与独立 patch 的关系

| patch 组 | 用途 | 是否替代原 patch |
| --- | --- | --- |
| `patches/lab1-system-call/` | lab1 单独教学与复现 | 否 |
| `patches/lab2-process-observation/` | lab2 pstate 单独教学与复现 | 否 |
| `patches/lab3-memory-and-pagetable/` | lab3 pgcount 单独教学与复现 | 否 |
| `patches/lab4-file-table-observation/` | lab4 fcount 单独教学与复现 | 否 |
| `patches/integrated-labs/` | lab1 + lab2 + lab3 + lab4 同一 xv6 构建综合演示 | 否，仅新增综合路线 |

不要把 lab2 或 lab4 independent patch 直接叠加到 lab1 patch 之上。综合演示请使用本目录的顺序 patch。

## baseline

| 字段 | 内容 |
| --- | --- |
| baseline repo | `https://github.com/mit-pdos/xv6-riscv.git` |
| baseline commit | `74f84181a3404d1d6a6ff98d342233979066ebb8` |
| 本地源码路径 | `external/xv6-riscv/` |

## patch sequence

| 顺序 | patch | 新增内容 | syscall number | 用户程序 |
| --- | --- | --- | --- | --- |
| 0001 | `0001-add-hello-syscall.patch` | `hello()` | `SYS_hello = 22` | `hello` |
| 0002 | `0002-add-argint-add2-syscall.patch` | `add2(int, int)` | `SYS_add2 = 23` | `add2test` |
| 0003 | `0003-add-pstate-syscall.patch` | `pstate(int pid)` | `SYS_pstate = 24` | `pstatetest` |
| 0004 | `0004-extend-process-observation.patch` | `pcount(int state)`、子进程状态观察 | `SYS_pcount = 25` | `pcounttest`、`pchildtest` |
| 0005 | `0005-add-file-table-observation.patch` | `fcount()` 文件表观察 | `SYS_fcount = 26` | `fcounttest` |
| 0006 | `0006-add-pgcount-page-table-observation.patch` | `pgcount()` 页表映射数量观察 | `SYS_pgcount = 27` | `pgcounttest` |
| 0007 | `0007-add-fdcount-observation.patch` | `fdcount()` 当前进程 fd 表观察 | `SYS_fdcount = 28` | `fdcounttest` |
| 0008 | `0008-add-memstat-copyout-observation.patch` | `memstat(struct memstat *)` 地址空间观察，argaddr + copyout + struct ABI，复用 `0006` 的 `uvmpagecount()` | `SYS_memstat = 29` | `memstattest` |
| 0009 | `0009-add-fdinfo-copyout-observation.patch` | `fdinfo(int, struct fdinfo *)` fd 元数据观察，argint + argaddr + copyout + struct ABI，只查自己的 `ofile[fd]` | `SYS_fdinfo = 30` | `fdinfotest` |

## 推荐 helper

最终综合 Demo 和队友/评委复现建议优先使用：

```bash
bash scripts/xv6/apply-integrated-labs.sh
bash scripts/xv6/apply-integrated-labs.sh --make --yes
```

说明：

- 不带参数时是预览模式，只读，不 reset、不 apply、不 make。
- `--run` / `--make` 始终需要 `--yes`。
- `--make --yes` 会 reset/clean ignored 的 `external/xv6-riscv/`，按顺序应用 integrated `0001-0009` 并运行 `make`。
- `make` 输出保存到 ignored 的 `logs/integrated-make-YYYYMMDD-HHMMSS.log`，不提交。
- helper 不会修改主仓库 tracked 文件，不提交第三方源码。

## 手动应用顺序

从 clean baseline 开始：

```bash
cd external/xv6-riscv
git reset --hard 74f84181a3404d1d6a6ff98d342233979066ebb8
git clean -fdx
git apply ../../patches/integrated-labs/0001-add-hello-syscall.patch
git apply ../../patches/integrated-labs/0002-add-argint-add2-syscall.patch
git apply ../../patches/integrated-labs/0003-add-pstate-syscall.patch
git apply ../../patches/integrated-labs/0004-extend-process-observation.patch
git apply ../../patches/integrated-labs/0005-add-file-table-observation.patch
git apply ../../patches/integrated-labs/0006-add-pgcount-page-table-observation.patch
git apply ../../patches/integrated-labs/0007-add-fdcount-observation.patch
git apply ../../patches/integrated-labs/0008-add-memstat-copyout-observation.patch
git apply ../../patches/integrated-labs/0009-add-fdinfo-copyout-observation.patch
make
```

## 自动验证方式

从仓库根目录运行：

```bash
bash scripts/xv6/apply-integrated-labs.sh --make --yes
bash scripts/xv6/boot-xv6.sh
bash scripts/xv6/run-xv6-command.sh hello "hello syscall returned 2026"
bash scripts/xv6/run-xv6-command.sh add2test "add2(20, 6) returned 26"
bash scripts/xv6/run-xv6-command.sh pstatetest "pstate(self) ="
bash scripts/xv6/run-xv6-command.sh pcounttest "pcount(RUNNING) ="
bash scripts/xv6/run-xv6-command.sh pcounttest "pcount(99) = -1"
bash scripts/xv6/run-xv6-command.sh pchildtest "pstate(child) ="
bash scripts/xv6/run-xv6-command.sh fcounttest "fcount(before) ="
bash scripts/xv6/run-xv6-command.sh fcounttest "fcount(after_open) ="
bash scripts/xv6/run-xv6-command.sh fcounttest "fcount(after_close) ="
bash scripts/xv6/run-xv6-command.sh fcounttest "fcounttest done"
bash scripts/xv6/run-xv6-command.sh pgcounttest "pgcounttest done"
bash scripts/xv6/run-xv6-command.sh fdcounttest "fdcounttest done"
bash scripts/xv6/run-xv6-command.sh memstattest "memstattest done"
bash scripts/xv6/run-xv6-command.sh fdinfotest "fdinfotest done"
```

## 当前真实验证结果

| 检查项 | 状态 |
| --- | --- |
| clean baseline + integrated `0001-0009` apply（stage11b） | PASS |
| `make` | PASS |
| boot evidence | PASS，检测到 `xv6 kernel is booting` 和 `init: starting sh` |
| `hello` 输出捕获 | PASS，检测到 `hello syscall returned 2026` |
| `add2test` 输出捕获 | PASS，检测到 `add2(20, 6) returned 26` |
| `pstatetest` 输出捕获 | PASS，检测到 `pstate(self) =` |
| `pcounttest` 输出捕获 | PASS，检测到 `pcount(RUNNING) =` 和 `pcount(99) = -1` |
| `pchildtest` 输出捕获 | PASS，检测到 `pstate(child) =` |
| `fcounttest` 输出捕获 | PASS，检测到 `fcount(before) =`、`fcount(after_open) =`、`fcount(after_close) =` 和 `fcounttest done` |
| `pgcounttest` 输出捕获 | PASS，检测到 `pgcount eager delta = 2`、lazy delta 输出和 `pgcounttest done` |
| `fdcounttest` 输出捕获 | PASS，检测到 fd delta 输出和 `fdcounttest done` |
| `memstattest` 输出捕获（integrated `0008`） | PASS，检测到 `memstat page_size = 4096`、mapped/size delta 输出和 `memstattest done`（队长本机） |
| `fdinfotest` 输出捕获（integrated `0009`） | PASS，检测到 open/dup ok、closed fd `-1`、bad fd `-1` 和 `fdinfotest done`（队长本机） |
| 长期稳定性测试 | TODO |
| 覆盖 `0001-0009` 的人工交互录屏 | 已录制：`20260611_final_integrated_0001_0009_demo.mp4`，SHA256 已登记（旧 `0001-0007` 视频为 historical stable checkpoint） |
| 队友复现（`0001-0009`） | 已完成：rain/root/z2996 在 current final commit `db85947` 上 `teammate-verify.sh --full` 全 PASS（stage14 登记） |

## 边界

- timeout 自动捕获不等于长期稳定性测试。
- 当前没有声称人工录屏完成。
- 证据分三层：current final 为 `db85947 / 0001-0009` 三方 full PASS（stage14 已登记，见 `submissions/evidence_manifest.md`）；`e8e2fb9 / 0001-0007` 三方 PASS 为 historical stable checkpoint；两份 `1ba9db6` full PASS 只证明 earlier `0001-0005`。旧证据不冒充新证据。
- `pcount(RUNNING)`、`pstate(child)` 和 `fcount(...)` 的具体数字/状态可能随调度和环境变化，验证只依赖稳定前缀。
- `pgcount()` 是页表映射数量观察，不是完整内存管理实验。
- `fcount()` / `fdcount()` 是 file table / fd table 观察，不是完整文件系统实验。
- `memstat()`（`0008`）是地址空间观察，不是完整内存管理；`fdinfo()`（`0009`）是 fd 元数据观察，不是完整文件系统；二者都不返回物理地址、路径、inode 号或文件内容。
- `external/xv6-riscv/` 和 `logs/*.log` 不提交。

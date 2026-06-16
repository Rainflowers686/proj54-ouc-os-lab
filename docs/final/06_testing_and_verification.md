# 06 Testing and Verification

## 目标

本文定义项目测试和证据口径，说明哪些命令支撑 current final，哪些结果只能作为历史或局部证据。

## 适用对象

适用于评审、队友复现人员、助教和项目维护者。

## 覆盖范围

current final `db85947 / 0001-0009` 的 full verification 覆盖 doctor、baseline、apply+make、boot、十个用户程序检查和 overall。十个用户程序为 `hello`、`add2test`、`pstatetest`、`pcounttest`、`pchildtest`、`fcounttest`、`pgcounttest`、`fdcounttest`、`memstattest`、`fdinfotest`。

## 推荐命令

```bash
bash scripts/xv6/teammate-verify.sh --full
bash scripts/labctl.sh verify
```

已完成构建后的快速重测：

```bash
bash scripts/xv6/teammate-verify.sh --quick
```

## 证据状态

rain、root、z2996 三方 full verification 已登记为 PASS，`grade-summaries` 解析为 3 clean PASS。最终视频 `20260611_final_integrated_0001_0009_demo.mp4` 与 SHA256 已登记。historical `e8e2fb9 / 0001-0007` 不覆盖 `memstat` 和 `fdinfo`。

## 质量标准

验证文档必须写清 commit、suite、命令、匹配文本和证据位置。易变输出只匹配稳定前缀。raw logs、summary 原件、截图和视频不进入 Git。

## 边界条件

timeout evidence 不是长期稳定性测试。队长本机验证不等于队友复现。PPT 引用证据不等于证据本体。

## 内容范围

本文内容限定在当前标题所对应的项目记录、教学说明、复现步骤或审查结论内。涉及 current final、historical checkpoint、验证命令和证据材料时，应以 `submissions/evidence_manifest.md`、`patches/integrated-labs/README.md` 和相关脚本为准。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 current final。

## 语言风格

使用中文技术写作风格，命令、文件名、commit、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

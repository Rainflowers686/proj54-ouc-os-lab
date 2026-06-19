# 测试报告

## 目标

本文汇总 OUC xv6 Lab Kit 的验证范围、测试命令、当前证据状态和不可夸大的边界。正式证据索引以 `submissions/evidence_manifest.md` 为准，本文用于解释测试体系如何覆盖项目目标。

## 适用对象

适合评审、队友复现人员、助教和项目维护者。学生完成作业时可参考命令，但最终仍按各 lab 任务书提交。

## 测试范围

当前正式版本采用 integrated suite `0001-0009`。full verification 覆盖 doctor、baseline、apply+make、boot、`hello`、`add2test`、`pstatetest`、`pcounttest`、`pchildtest`、`fcounttest`、`pgcounttest`、`fdcounttest`、`memstattest`、`fdinfotest` 和 overall。

## 核心命令

```bash
bash scripts/xv6/doctor.sh
bash scripts/xv6/apply-integrated-labs.sh --make --yes
bash scripts/xv6/boot-xv6.sh
bash scripts/xv6/teammate-verify.sh --full
bash scripts/labctl.sh verify
```

## 当前结果

rain、root、z2996 三方在 当前正式验证范围 上 full verification 均已登记为 PASS，`grade-summaries` 解析为 3 clean PASS。最终演示视频 `20260611_final_integrated_0001_0009_demo.mp4` 的大小、时长、分辨率、帧率和 SHA256 已记录在 evidence manifest。`historical integrated 0001-0007` 只作为 历史证据，不覆盖 `memstat` 和 `fdinfo`。

## 质量标准

测试记录必须同时说明命令、匹配文本、suite 和证据位置。对易变输出只匹配稳定前缀或由测试程序内部计算 delta，不把一次观察值写成必然值。summary 和 raw logs 默认不入 Git。

## 边界条件

timeout 捕获不是长期稳定性测试。QEMU fast exit 只说明脚本已匹配预期文本。队长本机 PASS、队友 PASS、视频证据和 历史证据 必须分层记录，不能互相替代。

## 内容范围

本文内容限定在当前标题所对应的项目记录、教学说明、复现步骤或审查结论内。涉及 当前正式验证范围、历史证据、验证命令和证据材料时，应以 `submissions/evidence_manifest.md`、`patches/integrated-labs/README.md` 和相关脚本为准。

## 结构规范

文档应按“背景或问题、过程或设计、证据或命令、风险和后续动作”的顺序组织。历史文档可保留阶段性记录，但必须避免覆盖 当前正式验证范围。

## 语言风格

使用中文技术写作风格，命令、文件名、syscall 名和 SHA256 保持原样。结论应有证据支撑，不使用宣传性、绝对化或无法验证的表述。

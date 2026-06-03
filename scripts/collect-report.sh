#!/usr/bin/env bash
set -uo pipefail

out="submissions/draft-report-index.md"

status_line() {
  path="$1"
  label="$2"
  content="$3"
  if [ -e "$path" ]; then
    echo "| ${label} | \`${path}\` | exists | ${content} |"
  else
    echo "| ${label} | \`${path}\` | missing | ${content} |"
  fi
}

baseline_record_status() {
  path="external/xv6-baseline-record.md"
  if [ -e "$path" ]; then
    echo "| xv6 baseline metadata | \`${path}\` | exists | generated metadata draft; does not claim build success |"
  else
    echo "| xv6 baseline metadata | \`${path}\` | missing | TODO: run \`bash scripts/xv6/fetch-xv6.sh --run\` after authorization |"
  fi
}

mkdir -p submissions

{
  echo "# Initial Submission Material Index Draft"
  echo
  echo "Generated time: TODO: fill manually before final submission"
  echo
  echo "This file is generated or updated by \`scripts/collect-report.sh\`."
  echo "It is not the final technical report, does not generate PDF, and does not include registration materials, private data, or fabricated results."
  echo
  echo "## Material Index"
  echo
  echo "| Material | Path | File | Content status |"
  echo "| --- | --- | --- | --- |"
  status_line "README.md" "Project homepage" "MVP draft"
  status_line "docs/00_project_plan.md" "Project plan" "MVP draft"
  status_line "docs/01_requirement_analysis.md" "Requirement and scoring analysis" "MVP draft"
  status_line "docs/02_lab_design.md" "Lab system design" "MVP draft"
  status_line "docs/03_step_by_step_guide.md" "Step-by-step guide outline" "outline draft"
  status_line "docs/04_test_report.md" "Test report template" "template; real results pending"
  status_line "docs/05_ai_usage_record.md" "AI usage record" "active record"
  status_line "docs/06_progress_log.md" "Progress log" "active record"
  status_line "docs/07_faq_and_issues.md" "FAQ and issue record" "template"
  status_line "docs/08_reference_and_license.md" "Reference and license record" "active record"
  status_line "docs/09_github_workflow.md" "GitHub workflow" "workflow draft"
  status_line "docs/10_red_team_review.md" "Internal red-team review" "draft"
  status_line "docs/11_xv6_baseline_plan.md" "xv6 baseline plan" "stage1b plan"
  status_line "labs/lab0-env-setup/README.md" "lab0 environment guide" "updated with WSL2 status and baseline steps"
  status_line "labs/lab1-system-call/README.md" "lab1 syscall design" "design draft"
  status_line "labs/lab2-process-and-scheduling/README.md" "lab2 process and scheduling" "planned"
  status_line "labs/lab3-memory-and-pagetable/README.md" "lab3 memory and pagetable" "planned"
  status_line "labs/lab4-file-system/README.md" "lab4 file system" "planned"
  status_line "labs/lab5-final-integration/README.md" "lab5 final integration" "planned"
  status_line "tests/lab1/README.md" "lab1 test plan" "draft; real tests pending"
  status_line "tests/lab2/README.md" "lab2 test plan" "draft"
  status_line "tests/lab3/README.md" "lab3 test plan" "draft"
  status_line "tests/lab4/README.md" "lab4 test plan" "draft"
  status_line "scripts/xv6/fetch-xv6.sh" "xv6 fetch script" "stage1b tooling"
  status_line "scripts/xv6/check-xv6-baseline.sh" "xv6 baseline check script" "stage1b tooling; make not run by default"
  status_line "external/README.md" "external directory guide" "baseline management notes"
  baseline_record_status
  status_line "logs/README.md" "logs directory guide" "raw logs ignored by default"
  status_line "references/README.md" "reference directory guide" "placeholder"
  status_line "slides/README.md" "PPT notes" "TODO"
  status_line "videos/README.md" "Demo video notes" "TODO"
  echo "| Final submission | \`submissions/\` | - | TODO: organize against official requirements |"
  echo
  echo "## Notes"
  echo
  echo "- File existence is checked by this script; content quality still needs human review."
  echo "- \`external/xv6-riscv/\` is intentionally not listed as a tracked submission artifact."
  echo "- xv6 build and QEMU boot remain TODO until real commands are run and recorded."
} > "$out"

echo "[OK] report index updated: ${out}"
echo "No PDF or final report was generated."

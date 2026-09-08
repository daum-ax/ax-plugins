#!/usr/bin/env bash
# 배포 전 검사 — 로컬과 CI가 같은 스크립트를 쓴다.
#   1) 플러그인·스킬·marketplace 구조 검증 (claude plugin validate --strict)
#   2) 공개 저장소에 들어가면 안 되는 문자열 검사 (개인 경로·옛 이름·자리표시자·옛 예시)
# 이 저장소는 marketplace 로 등록되면 통째로 사용자 컴퓨터에 clone 되므로 2)를 통과하지 못하면 배포하지 않는다.
set -euo pipefail
cd "$(dirname "$0")/.."

PLUGIN=ax-skills

if command -v claude >/dev/null 2>&1; then
  echo "→ validate"
  claude plugin validate "plugins/$PLUGIN" --strict
  claude plugin validate "plugins/$PLUGIN/skills" --strict
  claude plugin validate .claude-plugin/marketplace.json --strict
else
  echo "warn: claude CLI 없음 — validate 건너뜀 (로컬에서는 반드시 실행할 것)" >&2
fi

echo "→ 금지 문자열 (1) 유출 — 저장소 전체"
LEAK='jay\.axz|axzcorp|kakaocorp|IdeaProjects|hr-claude-templates|dev-review|/Users/|jay에게'
if grep -rniE "$LEAK" . --exclude-dir=.git --exclude=check.sh; then
  echo "error: 위 문자열은 공개 저장소에 들어가면 안 됩니다." >&2
  exit 1
fi

echo "→ 금지 문자열 (2) 옛 이름·자리표시자·옛 예시 — 배포 payload"
# CONTRIBUTING.md·CHANGELOG.md·docs/decisions/ 는 자매 플러그인 이름을 적는 자리라 여기서 뺀다.
STALE='jay-skills|jay-plugins|__MARKETPLACE_|공지사항|notice-list|HR 패키지'
if grep -rniE "$STALE" plugins .claude-plugin README.md .github; then
  echo "error: 이름 바꾸기나 예시 교체가 덜 끝났습니다." >&2
  exit 1
fi

echo "→ 리포트 독트린 SSOT/mirror 본문 일치"
diff <(tail -n +13 "plugins/$PLUGIN/rules/reporting.md") <(tail -n +11 "plugins/$PLUGIN/output-styles/progressive-report.md")

echo "OK"

# 기여 안내

이 저장소는 플러그인 `ax-skills`·`ax-deploy` 의 **개발처이자 배포처(marketplace)** 입니다. 여기 있는 모든
파일은 `/plugin marketplace add` 한 사용자의 컴퓨터에 그대로 clone 됩니다 — 그래서
공개돼도 되는 내용만 둡니다. 개인 이름·이메일·절대경로·다른 내부 저장소 이름은 넣지 않고,
문의처는 "저장소 관리자"처럼 역할로 적습니다.

## 고치기 전에 알아둘 것

- **에이전트 0개, 훅 0개.** 사용자에게 묻는 일은 전부 AskUserQuestion 으로 하고(서브에이전트는
  질문을 못 합니다), 자동 차단 장치가 없으니 각 스킬의 "절대 하지 않는 것" 목록이 안전 상한입니다.
- **리포트 방식은 두 파일이 한 쌍.** `plugins/ax-skills/rules/reporting.md` 가 원본(SSOT),
  `plugins/ax-skills/output-styles/progressive-report.md` 는 같은 본문의 output-style 형태(mirror).
  **한 커밋에서 함께** 고칩니다. `scripts/check.sh` 가 본문 일치를 확인합니다.
- **혼자 작업하는 사람이 기본입니다.** `push` 는 지금 브랜치에 그대로 올리고, PR·pull·충돌
  정리는 후속 협업 팩으로 떼어 두었습니다. "개발자에게 물어보세요"라고 쓰지 않습니다 —
  `plugins/ax-skills/references/git-collab.md` §0 참고. 배경은 `docs/decisions/0003-solo-core.md`.
- 스킬 본문은 그 스킬이 실행될 때 통째로 읽히는 지시문입니다. 내력·날짜·"왜 그렇게 정했나"
  에세이는 본문에 넣지 말고 `docs/decisions/` 에 짧게 남깁니다.

## 로컬 검사

```bash
scripts/check.sh                                   # 플러그인마다 validate + 금지 문자열 + mirror 일치
claude --plugin-dir plugins/ax-skills              # 설치 없이 이 세션에서만 로드해 보기
/plugin marketplace add /절대/경로/ax-plugins       # 로컬 폴더를 marketplace 로 등록해 설치 흐름 확인
```

## 릴리즈

1. 변경 내용을 `CHANGELOG.md` 에 적습니다. 새 스킬·rule·output-style 파일이 생겼으면 MINOR,
   기존 파일 편집만이면 PATCH.
2. `plugins/<plugin>/.claude-plugin/plugin.json` 의 `version` 을 올립니다. **태그 버전과 같아야
   합니다** — 다르면 사용자 쪽 `/plugin update` 가 "이미 최신"이라며 조용히 아무것도 하지 않습니다.
3. `scripts/check.sh` 통과 확인 후 커밋, annotated 태그 `<plugin>/vX.Y.Z` 를 push 합니다.
4. (ax-skills 만) GitHub 이 막힌 환경을 위한 zip 은 GitHub Release 에 첨부합니다. **zip 안의 최상위 폴더가
   `ax-skills/` 여야** `~/.claude/skills/` 에 그대로 풀어 쓰는 설치 방법이 동작합니다:
   ```bash
   rsync -a --exclude='.DS_Store' plugins/ax-skills/ /tmp/stage/ax-skills/
   (cd /tmp/stage && zip -rq ax-skills-vX.Y.Z.zip ax-skills)
   ```
5. 사용자에게는 `INSTALL.md` 의 업데이트 두 줄을 안내합니다.

## 자매 플러그인과의 관계

이 플러그인은 특정 팀용으로 먼저 만들어진 `jay-skills` 에서 갈라져 나왔고, 두 줄기는
**따로** 유지됩니다.

- **범용 개선은 여기 먼저.** 특정 팀 고유가 아닌 개선은 이 저장소에 먼저 넣고, 자매
  플러그인에는 사람이 **문장을 옮겨 적는 방식**으로 반영합니다. 커밋을 그대로 가져오지
  않습니다 — 경로와 `/ax-skills:` 접두어가 다릅니다.
- **CHANGELOG 의 "자매 반영" 열이 유일한 장부입니다.** 버전마다 `vX.Y.Z`(반영됨) /
  `해당 없음` / `미반영` 중 하나를 적습니다.
- **하지 않는 것**: 두 저장소를 자동 비교하는 도구, submodule/subtree, 두 번째 remote.
  갈라짐은 의도된 것이고 장부만 맞춥니다.

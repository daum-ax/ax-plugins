# 변경 이력

형식: 버전 · 날짜 · 바뀐 것 · 자매 플러그인(jay-skills) 반영 여부.

## 0.2.0 — 2026-09-26

**행동이 바뀌는 릴리즈입니다.** 혼자 바이브코딩하고 혼자 배포하는 사람을 기본 사용자로 삼아
스킬을 14개에서 6개로 줄였습니다. 배경은 `docs/decisions/0003-solo-core.md`.

- **새 스킬 `release`** — 지금 커밋에 `v1`, `v2` … annotated 태그를 붙여 그 태그 하나만 push.
  번호는 도구가, 설명 한 줄은 사용자가 정합니다. 같은 커밋에서 다시 부르면 "이미 `vN`"으로
  멈추고, "버전 목록 보여줘"는 읽기만 합니다. 모노레포는 1차 범위 밖(README 에 한계로 기재).
- **제거한 스킬** (9개)
  - 협업 팩으로 떼어 둠 — `pr` · `review-pr` · `pull` · `fix-conflict`. 후속 플러그인
    `ax-collab` 에서 0.1.0 커밋 기준으로 되살립니다.
  - 제거 — `undo`(파일은 Claude Code `/rewind`, 배포는 포털 롤백), `explain` · `handoff` ·
    `record`(Claude 기본 능력으로 충분), `dev-up` 과 `references/node-volta.md`.
- **push 를 혼자 작업 모드로 재설계.** 작업 브랜치를 만들지 않고 지금 브랜치(보통 main)에
  그대로 push합니다. 저장소가 없으면 `gh repo create --private` 로 새로 만들어 연결합니다
  (이름만 확인, 소유자는 `gh` 로그인 계정 — 확인 질문에 그 계정 이름을 보여줌). `GH006` 과 `! [rejected]` 는 자동으로 브랜치를
  만들거나 pull 하지 않고 멈춥니다. `--force` 금지·이미 올린 이력 고치기 금지는 그대로.
- **welcome 범위 축소.** 동료가 준 주소로 clone 하는 분기와 dev-up 제안을 뺐고, 저장소 주소가
  없어도 github.com 로그인까지 확인합니다. 마지막 안내는 "커밋해줘 → 올려줘 → 버전 남겨줘".
- commit: 큰 변경 시 `record` 노트를 남기던 단계 제거, 마무리 안내에 `release` 추가.
- status: 안내 대상을 남은 스킬로 줄이고, 충돌·merge 중·PR 이 필요한 상태는 "협업 기능이
  필요한 상태예요"로 멈춥니다.
- github-login: 사라진 clone 흐름으로 넘기던 안내와 `GH006` 안내를 새 push 에 맞춤.
  저장소 주소가 없으면 github.com 로그인으로 진행.
- `references/git-collab.md`: § 번호는 그대로 두고 협업 전용 항목에 "협업 팩 전용 — 현재
  플러그인에서는 쓰지 않음" 표시. 에러 번역표의 담당 스킬을 남은 스킬로 갱신.

자매 반영: `해당 없음` — 구성 축소는 ax-skills 사용자 기준의 결정. `release` 는 필요하면 옮겨 적을 후보.

## 0.1.0 — 2026-09-08

첫 릴리즈. `jay-skills` v0.4.2 에서 갈라져 나와 범용화했습니다.

- 이름을 `ax-skills` 로, marketplace 를 `ax-plugins` 로. 스킬 14개 구성은 그대로.
- 특정 팀·회사 고유 문구 제거, 예시 도메인을 "회의실 예약"으로 통일, 문의처를 "저장소 관리자"로.
- **dev-up 을 스택 무관으로 재설계.** README 가 적어 둔 명령만 실행하고, Node·Volta·nvm·
  launch.json 절차는 `references/node-volta.md` 레시피로 옮겨 `package.json` 이 보일 때만 읽습니다.
  포트 점유 시 정체를 보여주고 동의받는 흐름·접속 확인은 그대로입니다.
- welcome 이 dev-up 을 제안하는 조건에 `.claude/launch.json` 존재를 추가.
- fix-conflict 의 잠금 파일 목록에 `poetry.lock`·`Pipfile.lock` 추가.
- INSTALL.md: 도구 표에 dev-up 누락 보완, User/Project 두 범위 동시 설치 시 가림 현상 안내 추가.

자매 반영: `해당 없음` (분기 자체)

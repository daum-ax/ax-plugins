# 변경 이력

형식: 버전 · 날짜 · 바뀐 것 · 자매 플러그인(jay-skills) 반영 여부.

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

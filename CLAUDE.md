# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 이 저장소의 성격

실행되는 애플리케이션 코드가 없다. 산출물은 **Claude Code 플러그인 `ax-skills`** 이고,
내용물은 전부 Markdown 지시문이다. 빌드·테스트 프레임워크가 없고, "단일 테스트 실행"에
해당하는 개념도 없다 — 검증은 `scripts/check.sh` 하나다.

**개발처 = 배포처(marketplace)다.** 사용자가 `/plugin marketplace add` 하면 이 저장소가
통째로 그 사람 컴퓨터에 clone 된다. 여기 추가하는 모든 파일(이 CLAUDE.md 포함)이 남의
컴퓨터로 간다는 전제로 작업한다. 배경은 `docs/decisions/0001-fork-and-scope.md`.

## 검사·실행

```bash
scripts/check.sh                              # 유일한 게이트. CI(.github/workflows/validate.yml)도 같은 스크립트를 돌린다
claude --plugin-dir plugins/ax-skills         # 설치 없이 현재 세션에만 로드
/plugin marketplace add /절대/경로/ax-plugins  # 로컬 폴더를 marketplace 로 등록해 설치 흐름 확인
```

`scripts/check.sh` 가 하는 일은 네 가지다.

1. `claude plugin validate --strict` 3회 (plugin / skills / marketplace.json)
2. **유출 문자열 검사 — 저장소 전체.** 개인 계정·회사 도메인·홈 디렉터리 절대경로·내부
   저장소 이름. 루트에 새로 추가하는 문서도 이 검사를 받는다. 예시 경로를 쓸 일이 있으면
   `/절대/경로/ax-plugins` 처럼 자리표시자로 적는다.
3. **옛 이름·자리표시자 검사 — 배포 payload 한정** (`plugins`, `.claude-plugin`,
   `README.md`, `.github`). `CONTRIBUTING.md`·`CHANGELOG.md`·`docs/decisions/`·`CLAUDE.md`
   는 자매 플러그인 이름(`jay-skills`)을 적어도 되는 자리라 이 검사에서 빠져 있다.
4. 리포트 독트린 SSOT/mirror 본문 일치 diff (아래 참고).

**`claude` CLI 가 PATH 에 없으면 1번을 건너뛰고도 `OK` 를 찍는다.** `warn: claude CLI 없음`
줄이 보이는 초록불은 문자열 검사와 mirror diff 만 돈 것이다 — `→ validate` 줄이 실제로
나왔는지 확인한다.

## 구조

2단 구성이다. 저장소 루트가 marketplace, `plugins/ax-skills/` 가 플러그인이다.

```
.claude-plugin/marketplace.json          # marketplace 정의 — plugins[] 가 ./plugins/ax-skills 를 가리킨다
plugins/ax-skills/
  .claude-plugin/plugin.json             # 플러그인 메타 + version (릴리즈 태그와 반드시 일치)
  skills/<name>/SKILL.md                 # 스킬 6개. 이것이 제품 본체
  references/git-collab.md               # git 스킬 공용 참조 (번호 붙은 §)
  rules/reporting.md                     # 리포트 독트린 SSOT (항상 로드)
  output-styles/progressive-report.md    # 같은 독트린의 output-style mirror
docs/decisions/                          # 왜 그렇게 정했는지 (배포되지만 사용자용은 아님)
```

### 스킬 본문 = 실행 시 통째로 읽히는 지시문

SKILL.md 본문은 그 스킬이 실행될 때 전부 컨텍스트에 들어간다. 그래서 내력·날짜·"왜 이렇게
정했나" 에세이는 본문에 넣지 않고 `docs/decisions/` 에 짧게 남긴다.

frontmatter 의 `description` 은 설명문이 아니라 **트리거 표면**이다. 사용자가 실제로 칠
법한 한국어 문장("버전 남겨줘", "GitHub이 비밀번호를 안 받아줘요")과 에러 원문
(`Authentication failed`)을 그대로 담는다. 여기서 빠진 표현은 스킬이 안 걸린다.

### `references/git-collab.md` 의 § 번호는 공개 계약이다

git 계열 스킬(`welcome`, `github-login`, `push`, `release`, `status`)은 첫 단계에서
`${CLAUDE_PLUGIN_ROOT}/references/git-collab.md` 를 읽고 **§ 번호로** 특정 절을 지목한다
(§0 가정하는 사용자, §1 어휘표, §2 마무리 카드, §3 에러 번역표, §3.5 이름 겹침, §3.6 원격
명령, §4 `gh` 확인 순서, §5 안전 기준선, §6/§7 누가 무엇을 정하는가).

**절을 추가·삭제해 번호가 밀리면 여러 스킬의 참조가 조용히 어긋난다.** 번호는 유지하고,
끼워 넣을 때는 `§3.5` 처럼 소수점 번호를 쓴다 (기존 관례). 협업 팩으로 떼어 낸 흐름에만
쓰이는 항목도 지우지 않고 "협업 팩 전용 — 현재 플러그인에서는 쓰지 않음"으로 표시해 둔다.

### 혼자 작업하는 사람이 기본, 협업 기능은 떼어 둠

v0.2.0 부터 기본 사용자는 혼자 바이브코딩하고 혼자 배포하는 사람이다. `push` 는 지금
브랜치(보통 main)에 그대로 올리고, 저장소가 없으면 `gh repo create --private` 로 만든다.
PR·pull·충돌 정리(`pr` `review-pr` `pull` `fix-conflict`)는 후속 플러그인 `ax-collab` 으로
떼어 두었고 0.1.0 커밋에서 되살린다. 그런 상태를 만나면 스킬은 멈추고 누구에게 물을지
안내한다. 배경은 `docs/decisions/0003-solo-core.md`.

### 리포트 독트린은 SSOT/mirror 한 쌍

같은 본문이 두 파일에 있다. `rules/reporting.md` 가 원본이고(항상 로드되는 rule — 사용자가
다른 output style 을 고르면 style 은 꺼지므로 이쪽이 백스톱),
`output-styles/progressive-report.md` 는 output-style 형태의 사본이다. **한 커밋에서 함께
고친다.**

check.sh 는 `rules/reporting.md` 의 13번째 줄부터, `output-styles/progressive-report.md`
의 11번째 줄부터를 diff 한다. 즉 **두 파일의 frontmatter·머리말 줄 수가 바뀌면 본문이
byte 단위로 같아도 검사가 깨진다** — 그리고 "머리말 길이가 달라졌다"가 아니라 본문
내용이 어긋난 것처럼 보이는 diff 로 나온다. `description:` 한 줄을 두 줄로 늘리는 편집이
여기 걸린다.

## 지켜야 할 것

- **에이전트 0개, 훅 0개.** 사용자에게 묻는 일은 전부 `AskUserQuestion` 으로 한다
  (서브에이전트는 질문을 못 한다). 자동 차단 장치가 없으므로 각 스킬의 "절대 하지 않는 것"
  목록이 실질 안전 상한이다.
- **강제 덮어쓰기 금지.** `push --force`, `reset --hard`, 이미 push 한 이력 고치기는 어떤
  스킬에서도 쓰지 않는다.
- **기술 선택은 도구가, 내용 선택은 사람이.** 버전 번호·저장소 공개 여부는 도구가 정하고,
  저장소 이름·버전 설명은 반드시 사용자가 확인한다 (git-collab §6/§7).
- **개발자가 곁에 없다고 가정한다.** "개발자에게 물어보세요"라고 쓰지 않는다 — 지금 상태를
  그대로 두고 누구에게 물으면 되는지를 알려준다 (§0).
- 스킬 상호 참조는 `/ax-skills:` 접두어를 붙인다. 자매 플러그인에서 문장을 옮겨 올 때 이
  접두어와 경로가 가장 자주 틀린다.
- 사용자 대상 문서는 한국어, 비개발자 독자 기준. 영어 기술 용어는 원형을 쓰되 첫 등장에서
  한 줄로 푼다 (§1).

## 여러 파일을 함께 고쳐야 하는 변경

- **스킬 추가** → `skills/<name>/SKILL.md` + `INSTALL.md` 의 도구 표 +
  `plugins/ax-skills/README.md` 의 분류 목록 + `CHANGELOG.md`(MINOR) + `plugin.json` 버전.
  (v0.1.0 에서 INSTALL.md 표에 dev-up 이 빠졌던 전례가 있다.)
- **스킬 제거** → 위 목록 전부 + 남는 스킬·`references/git-collab.md` 에서 그 스킬을
  가리키는 안내 정리. `grep -rhoE "ax-skills:[a-z-]+" plugins | sort -u` 가 남은 스킬 이름만
  내야 한다. 접두어 없이 이름만 적은 곳(에러 번역표의 담당 열 등)은 이 grep 에 안 걸린다.
- **리포트 독트린 수정** → `rules/reporting.md` + `output-styles/progressive-report.md`,
  같은 커밋.

## 릴리즈

절차 전체는 `CONTRIBUTING.md`. 조용히 실패하는 두 가지만 여기 적는다.

- `plugin.json` 의 `version` 이 태그(`ax-skills/vX.Y.Z`)와 **다르면** 사용자 쪽
  `/plugin update` 가 "이미 최신"이라며 아무것도 하지 않는다.
- GitHub Release 에 붙이는 zip 은 **최상위 폴더가 `ax-skills/`** 여야 `~/.claude/skills/`
  에 그대로 풀어 쓰는 수동 설치가 동작한다.

버전 규칙: 새 스킬·rule·output-style **파일**이 생기면 MINOR, 기존 파일 편집만이면 PATCH.

## 자매 플러그인 `jay-skills`

특정 팀용으로 먼저 만들어진 `jay-skills` 에서 갈라져 나왔고 두 줄기는 **따로** 유지된다.
범용 개선은 이 저장소에 먼저 넣고, 자매 쪽에는 사람이 문장을 옮겨 적는다 — 커밋을 그대로
가져오지 않는다. 장부는 `CHANGELOG.md` 의 "자매 반영" 열 하나이고, 자동 비교 도구·
submodule/subtree·두 번째 remote 는 두지 않는다.

**개발 머신에는 두 플러그인이 동시에 설치돼 있을 수 있다.** 그러면
`claude --plugin-dir plugins/ax-skills` 로 시험할 때 이름이 겹쳐 자매 쪽 사본이 잡힐 수
있으니, 스킬을 부를 때 `/ax-skills:` 접두어를 붙여 어느 쪽이 실행됐는지 확인한다. 이름
겹침 자체의 처리 원칙은 git-collab §3.5 에 있다.

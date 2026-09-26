---
name: push
description: 내 컴퓨터에 커밋(/ax-skills:commit)해 둔 작업을 GitHub 저장소에 push해서 다른 컴퓨터·배포에서도 쓸 수 있게 합니다. 지금 브랜치(보통 main)에 그대로 올리고, 아직 GitHub 저장소가 없으면 비공개 저장소를 새로 만들어 연결해요. "push 해줘" / "올려줘" / "GitHub에 올려줘" / "저장소 만들어줘" / "팀에 공유해줘" 할 때 사용. push 전 커밋 안 된 변경이 있으면 먼저 /ax-skills:commit을 권합니다.
---

# GitHub에 push하기 (push)

비개발자를 위한 공유 흐름. 안전 축은 하나다 — **내 컴퓨터 ↔ 팀 저장소**.

push(내 커밋을 팀 저장소로 올려 동료가 볼 수 있게 하는 것)는 **커밋된 것만** 보낸다.
혼자 작업하는 경우가 기본이다 — 작업 브랜치를 따로 만들지 않고 **지금 브랜치에 그대로**
올린다.

먼저 `${CLAUDE_PLUGIN_ROOT}/references/git-collab.md`를 읽는다 — 어휘(§1), 마무리
카드(§2), 에러 번역표(§3), 원격 명령(§3.6), `gh` 확인 순서(§4), 안전 기준선(§5),
묻지 않고 정하는 것(§6).

## Process

### Step 1: 조용히 확인

```bash
git rev-parse --git-dir 2>&1
git status --porcelain 2>&1
git rev-parse --abbrev-ref HEAD 2>&1
git rev-parse --verify HEAD 2>&1
git remote get-url origin 2>&1
```

- git 저장소가 아니면 `/ax-skills:status`의 안내로 넘긴다.
- 커밋이 하나도 없으면(`rev-parse --verify HEAD` 실패) 올릴 것이 없다 → Step 2의 질문 대신
  "아직 커밋이 하나도 없어요. 먼저 `/ax-skills:commit`으로 커밋해 주세요." 로 끝낸다.
- 지금 브랜치가 `HEAD`(기록 열람 모드)면 `/ax-skills:status`로 넘긴다.
- **팀 저장소 주소(origin)가 없으면** 아래 fetch를 건너뛰고 Step 2 → Step 3으로 간다.

origin이 있으면 팀 저장소를 건드리는 `fetch`를 `git-collab.md` §3.6대로 **미리 알리고
시간 제한을 걸어** 실행한다:

```bash
git -c http.lowSpeedLimit=1000 -c http.lowSpeedTime=15 fetch 2>&1
git rev-parse --abbrev-ref '@{u}' 2>&1
git log --oneline @{u}..HEAD 2>/dev/null
```

**`fetch`가 실패하면 `git-collab.md` §3 번역표로 먼저 분류한다** — 맨 윗줄부터 본다.

- **네트워크(연결 실패)** → 그 자리에서 VPN 안내 후 **정지**. `github-login`으로 보내지
  않는다. 사내 저장소인데 회사망에 연결돼 있지 않으면 로그인을 몇 번 다시 해도 안 된다.
- **인증** → `/ax-skills:github-login` → 끝나면 push 재시도.
- 그 밖 → §3 표에서 맞는 행을 따른다.

### Step 2: 커밋 안 된 변경이 있으면 먼저 묻는다

AskUserQuestion:

> "커밋 안 된 변경이 {n}개 있어요. push는 *커밋된 것*만 보냅니다.
> ① 먼저 커밋하고 같이 push하기 (권장) ② 커밋된 것까지만 push하기 ③ 그만두기"

① → `/ax-skills:commit`을 먼저 돌린다. **자동으로 커밋하지 않는다.**

### Step 3: 팀 저장소 주소가 없으면 — 새 저장소 만들기

바이브코딩은 보통 GitHub 저장소 없이 시작한다. origin이 없으면 AskUserQuestion:

> "아직 이 작업을 올릴 GitHub 저장소가 없어요.
> ① 새 저장소 만들어서 올리기 (권장 — 나만 볼 수 있는 비공개 저장소예요)
> ② 이미 만든 저장소 주소를 알고 있어요 (입력할게요)
> ③ 그만두기"

**② 기존 저장소 연결** → 받은 주소로 `git remote add origin "{URL}"` 한 뒤 Step 4로.
**주소 검증은 하지 않는다** — 비공개 저장소는 확인 명령이 실패해서 멀쩡한 주소를
틀렸다고 오해하게 만든다.

**③** → "지금까지 작업은 내 컴퓨터에 전부 안전하게 기록돼 있어요." 로 종료.

**① 새 저장소 만들기**

1. **`gh` 확인** — `git-collab.md` §4 순서대로. origin이 없으므로 목표 서버는 `github.com`
   이다.

   ```bash
   command -v gh
   gh auth status --hostname github.com 2>&1
   ```

   설치돼 있지 않거나 로그인돼 있지 않으면 §4의 문장으로 `/ax-skills:github-login`에
   넘기고, 끝나면 이 단계로 돌아온다.

   로그인돼 있으면 저장소가 만들어질 계정 이름을 알아 둔다 — 다음 질문에 보여준다:

   ```bash
   gh api user --jq .login 2>&1
   ```

2. **이름 제안** — 지금 폴더 이름을 **영문 소문자와 하이픈만** 쓰는 형태로 바꿔 제안한다
   (`git-collab.md` §6 — 저장소 이름은 주소에 그대로 들어간다). 폴더 이름이 한국어면 그
   뜻을 영문으로 옮겨 짓는다. AskUserQuestion으로 **이름만** 확인한다:

   > "GitHub의 `{계정}` 계정 아래에 `{제안 이름}` 이라는 비공개 저장소를 만들어서
   > 올릴게요. (저장소 이름은 주소에 들어가서 영문으로 지어요.)
   > ① 이 이름으로 진행 ② 이름 바꿀래요 ③ 그만두기"

   공개 여부는 묻지 않는다 — 항상 비공개다(기술 결정). 저장소를 만들 위치(개인 계정인지
   조직인지)도 묻거나 정하지 않는다 — `gh`에 로그인한 계정 아래에 만든다. 다만 **어느
   계정 아래인지는 질문에 반드시 보여준다** — 사용자가 다른 곳을 생각하고 있었다면 ③으로
   멈출 수 있어야 한다.

3. **만들고 올리기** — §3.6대로 미리 알린다("GitHub에 저장소를 만들고 올릴게요 — 몇 초
   걸릴 수 있어요").

   ```bash
   gh repo create {이름} --private --source . --remote origin --push 2>&1
   ```

   저장소 생성·origin 연결·push·upstream(내 브랜치와 팀 저장소 브랜치의 짝) 연결이 이
   명령 하나로 끝난다. 성공하면 Step 4를 건너뛰고 Step 5로 간다.

   - `Name already exists` → 같은 이름의 저장소가 이미 있다. 다른 이름을 제안해 2번부터
     다시 묻는다. **기존 저장소에 연결하지 않는다** — 다른 작업일 수 있다.
   - 그 밖의 실패 → §3 번역표 (맨 윗줄부터).

### Step 4: push하기

```bash
git -c http.lowSpeedLimit=1000 -c http.lowSpeedTime=15 push -u origin {현재 브랜치} 2>&1
```

`-u`는 항상 붙인다(기술 결정). 처음 한 번만 설명한다: "다음부터는 그냥 '올려줘'만
하시면 되도록 upstream을 걸어뒀어요."

**실패하면 원문을 해석해서 경로를 고른다** (`git-collab.md` §3 — 맨 윗줄부터):

| 실패 | 대응 |
|---|---|
| **연결 실패** (`Couldn't connect` · `Failed to connect` · `port 443` · `Connection timed out` · `Connection refused` · `i/o timeout` · `dial tcp` · `could not resolve host`) | **인증 문제가 아니다.** "`{호스트}` 서버에 연결 자체가 안 되고 있어요. 사내 저장소라면 회사 VPN을 켜신 뒤 다시 해주세요." → **여기서 정지.** github-login으로 보내지 않는다 |
| 인증 실패 / 401 / 비밀번호 거부 | `/ax-skills:github-login` → 끝나면 push 재시도 |
| 403 (권한 없음) | `/ax-skills:github-login`의 403 진단으로 |
| `GH006` / protected branch | "이 저장소는 팀 규칙으로 `{브랜치}`가 잠겨 있어요 — 여럿이 함께 쓰는 저장소라는 뜻이에요. 저장소를 만든 사람에게 어떻게 올리면 되는지 물어보세요. 작업은 내 컴퓨터에 그대로 있어요." → **여기서 정지.** 브랜치를 자동으로 만들지 않는다 |
| `! [rejected]` / `fetch first` / `non-fast-forward` | "다른 컴퓨터(또는 다른 사람)가 먼저 올린 작업이 팀 저장소에 있어요. 그대로 올리면 그 작업을 덮어쓰게 돼서 멈췄어요. 작업은 내 컴퓨터에 그대로 있고, 지금 상태로 두면 아무것도 망가지지 않아요. 누가 올린 것인지 모르겠으면 저장소를 만든 사람에게 물어보세요." → **여기서 정지.** 받아오기를 자동으로 이어 하지 않는다. **`--force`는 어떤 경우에도 제안하지 않는다.** |
| `Repository not found` | 현재 주소를 보여주고 내가 알고 있는 저장소 주소와 대조하도록 안내 |

### Step 5: 마무리

`git-collab.md` §2 카드. 예:

```
### 지금 상태
- `main` 이 팀 저장소(github.com/{계정}/room-booking)에 올라갔어요. 내 컴퓨터와 같은 내용입니다.
- 커밋 안 된 변경: 없음

### 다음에 할 수 있는 것
- 배포할 만한 상태면: "버전 남겨줘" (`/ax-skills:release`)
- 계속 작업하고 또 올리려면: 작업 → `/ax-skills:commit` → `/ax-skills:push`
- 잘 모르겠으면: 여기서 멈추고 물어보기 — 지금 상태 그대로 두면 아무것도 망가지지 않아요
```

저장소를 새로 만들었으면 첫 줄에 그 사실과 주소를 함께 적는다.

## 절대 하지 않는 것

- `--force` / `--force-with-lease` — 거부당했을 때도, 사용자가 요청해도. 요청받으면
  다른 곳에 있는 작업이 사라진다는 이유를 설명하고 멈춘다.
- 거부당했을 때 브랜치를 자동으로 만들거나 받아오기(pull)를 자동으로 이어 하기.
- 공개(public) 저장소 만들기, 이름이 겹치는 기존 저장소에 말없이 연결하기.
- 사용자 확인 없이 커밋하기 (`git-collab.md` §5).
- 팀 저장소의 브랜치 삭제, 이미 push한 이력 고치기(amend·rebase).
- raw git 출력 그대로 보여주기.

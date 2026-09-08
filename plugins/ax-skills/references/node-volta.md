# dev-up 레시피 — Node 프로젝트 (Volta)

`/ax-skills:dev-up`이 프로젝트에서 `package.json`을 봤을 때만 읽는다. 아래 R-단계를 dev-up
본문의 Step 번호에 끼워 넣는다 (R1·R2 → Step 2, R3 → Step 3, R4·R5 → Step 5). 본문의
Rules는 그대로 적용되고, 이 파일은 명령과 분기만 더한다.

## R0. 이 레시피의 모든 명령 앞에 붙이는 줄

```bash
export PATH="$HOME/.volta/bin:$PATH"
```

Volta(폴더마다 알맞은 Node 버전을 자동으로 골라주는 도구)를 방금 깔았으면 새 터미널을
열기 전까진 경로가 안 잡히는데, 이 줄이 **같은 대화에서 그대로 이어가게** 해준다. Volta가
없어도 무해하다. nvm(다른 버전 관리 도구)이 먼저 잡히는 컴퓨터에서도 이 줄이 있으면 이
대화 안에서는 맞는 버전이 잡힌다.

## R0.5. 선언 읽기 보강 (Step 1에 더해서)

```bash
cat package.json 2>/dev/null
cat .nvmrc 2>/dev/null
```

- **서버 명령** — README·launch.json이 정하지 않았으면 `scripts.dev`, 없으면 `scripts.start`
- **Node 버전** — `package.json`의 `volta.node` → `engines.node` → `.nvmrc`
- **준비 스크립트** — `scripts.setup`

Step 1의 정리 안내는 이렇게 채운다: "이 프로젝트는 Node {버전}이 필요하고, `npm install` →
`npm run setup` → `npm run dev`(포트 {P}) 순서로 준비돼요."

**Windows**라면 Step 1의 안내에 한 줄 보탠다: "① `winget install Volta.Volta` 후 터미널
새로 열기 ② 저장소 폴더에서 `npm install` → `npm run setup` → `npm run dev`".

## R1. Node 준비 (Step 2)

```bash
export PATH="$HOME/.volta/bin:$PATH"
node --version 2>&1
command -v volta >/dev/null && volta --version || echo volta-missing
```

**버전이 맞으면** 한 줄 확인하고 넘어간다.

**안 맞거나 Node가 없을 때** — Volta가 있고 `package.json`에 `volta` 항목이 있으면,
프로젝트 폴더에서 `node --version`을 한 번 더 부르는 것만으로 Volta가 알맞은 버전을
자동으로 내려받는다(시간이 걸릴 수 있다고 미리 알린다). `volta` 항목이 없으면
`volta install node@{필요한 버전}`.

**Volta 자체가 없으면 AskUserQuestion으로 반드시 묻는다:**

> "이 프로젝트는 Node {버전}이 필요한데 지금 컴퓨터의 것과 달라요. Volta(폴더마다 알맞은
> Node 버전을 자동으로 골라주는 도구)를 설치해서 맞춰 드릴까요?
> ① 설치하고 계속하기 ② 방법만 알려주세요"

① 이면 brew를 찾는다. **비대화형 실행에서는 brew가 경로에 없을 수 있어 절대경로도 본다:**

```bash
BREW=$(command -v brew || echo /opt/homebrew/bin/brew)
[ -x "$BREW" ] || BREW=/usr/local/bin/brew
[ -x "$BREW" ] && "$BREW" install volta && volta setup
```

brew가 없으면 **한 번 더 묻는다** — 인터넷에서 받은 설치 스크립트 실행은 별도 동의가
필요하다: "brew(Mac 프로그램 설치 도구)가 없네요. Volta 공식 설치 스크립트를 받아 실행할
까요? ① 진행 ② 방법만". `volta setup` 뒤에는 알린다: "**새로 여는 터미널부터** 자동으로
잡히고, 지금 이 대화에서는 제가 경로를 직접 지정해 그대로 이어갈게요."

### R1.5. nvm이 Volta를 가리고 있을 때 (해당될 때만)

예전에 nvm을 깔았던 컴퓨터는 nvm이 먼저 잡혀 방금 맞춘 버전이 안 보일 수 있다. **파일을
읽어서만 판단한다** — 대화형 셸을 새로 띄우지 않는다(설정에 따라 멈춰 있을 수 있다):

```bash
[ -d "$HOME/.nvm" ] && grep -n 'NVM_DIR\|nvm.sh' "$HOME/.zshrc" 2>/dev/null
grep -n 'VOLTA_HOME\|\.volta/bin' "$HOME/.zshrc" 2>/dev/null
```

nvm 줄이 있고 **그보다 뒤에** Volta 줄이 없으면 AskUserQuestion:

> "터미널이 Node를 찾을 때 예전에 깔린 nvm이 먼저 잡혀서, 직접 `npm run dev` 하실 때 옛
> 버전이 쓰일 수 있어요. `~/.zshrc` **맨 끝에** 두 줄을 더하면 정리됩니다. 기존 내용은
> 하나도 건드리지 않아요. ① 추가해 주세요 ② 아니요 (이 대화에서는 제가 알아서 처리해요)"

① 이면 **끝에 덧붙이기만 한다.** 위치가 핵심이다 — nvm 줄보다 뒤여야 효력이 있다:

```bash
printf '\n# Volta — nvm 로드보다 뒤에 있어야 한다\nexport VOLTA_HOME="$HOME/.volta"\nexport PATH="$VOLTA_HOME/bin:$PATH"\n' >> "$HOME/.zshrc"
```

②를 골라도 흐름은 그대로 간다 — 이 레시피의 명령은 이미 경로를 직접 지정한다.

## R2. 라이브러리 설치 (Step 2)

오래 걸릴 수 있다고 **먼저 알리고** 실행한다.

```bash
export PATH="$HOME/.volta/bin:$PATH"
npm install 2>&1 | tail -30
```

`npm warn`(노란 줄)은 실패가 아니다. 멈추는 것은 `npm error` 다. 설치가
`package-lock.json`을 바꿨으면 **그 사실을 알린다** — 나중에 `/ax-skills:status`에서 보고
놀라지 않도록: "잠금 파일(어떤 버전을 썼는지 적어두는 파일)이 바뀌었어요. 저장하려면
`/ax-skills:commit` 하시면 됩니다."

## R3. 준비 스크립트 (Step 3)

`scripts.setup`이 있을 때만. 본문 Step 3의 "먼저 말하고, 안전 표시 없으면 한 번 묻고" 규칙
그대로.

```bash
export PATH="$HOME/.volta/bin:$PATH"
npm run setup 2>&1 | tail -20
```

## R4. 서버 명령 (Step 5)

launch.json·README가 정하지 않았을 때의 기본값. nohup 줄은 이렇게 된다:

```bash
export PATH="$HOME/.volta/bin:$PATH"
LOG="${TMPDIR:-/tmp}/dev-up-$(basename "$PWD").log"
nohup npm run dev >> "$LOG" 2>&1 &
echo "$! $LOG"
```

## R5. launch.json은 버전 관리 도구를 경유하게 (Step 5 생성 제안)

앱이 서버를 띄울 때의 PATH가 터미널과 다를 수 있어서, `runtimeExecutable`에 명령 이름만
적으면 **엉뚱한 버전이 잡혀 서버가 죽는다** (실측: 같은 조건에서 `npm`은 옛 버전, 경유하면
프로젝트가 지정한 버전). Volta를 쓰는 프로젝트면 이런 모양:

```json
{ "runtimeExecutable": "volta",
  "runtimeArgs": ["run", "npm", "run", "dev"],
  "port": {P}, "autoPort": true }
```

## 번역표 (Node) — 본문 표보다 먼저 본다

| 화면에 나온 말 | 실제 의미 | 어떻게 |
|---|---|---|
| `EBADENGINE` / `Unsupported engine` / `Required: {"node":...}` | 지금 이 창에서 잡히는 Node가 프로젝트와 다르다 | 같은 명령 안에서 `node --version`으로 확인시키고 **R1로** |
| `Cannot find module` / `MODULE_NOT_FOUND` | 라이브러리 설치가 안 됐거나 끊겼다 | **R2** 다시 |
| `npm warn ...` (노란 줄) | 실패가 아니라 안내다 | 그대로 진행 |

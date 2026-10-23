# ax-deploy (베타)

작업 폴더를 사내 배포 포털에 올리고 링크를 받는 연결 플러그인이에요. 설치할 때 넣을 토큰은
없어요 — 처음 한 번 브라우저 로그인(회사 Google)하면, 그 뒤엔 Claude 에게
"사내 포털에 배포해줘"라고 말하는 게 전부예요.

배포 절차는 포털이 정합니다 — 이 플러그인에는 절차가 없어요. 포털이 알려주는 순서(커밋 확인 →
버전 태그 → 배포 → 결과 확인)를 Claude 가 그대로 따릅니다.

## 설치

1. Claude Code 채팅창에 한 줄씩 입력해요. 설치 창은 뜨지 않아요.
   ```
   /plugin marketplace add daum-ax/ax-plugins
   /plugin install ax-deploy@ax-plugins
   ```
   커밋·push·버전 남기기 도우미 `ax-skills` 도 함께 설치돼요.
2. Claude Code 를 완전히 껐다가 다시 켜요.
3. `/mcp` 를 입력하고 **ax-deploy** 를 고른 뒤 **Authenticate** 를 눌러요. 브라우저가 열리면
   회사 Google 계정으로 로그인하고 **허락**을 누르면 Claude Code 로 돌아와 연결이 끝나요.
   **Claude 데스크톱 앱**이라면: Code 세션을 연 채로 오른쪽 세션 레일 → **커넥터** → **Ax deploy** →
   「MCP 서버」 창의 **인증** → 승인 창 **OK** → 브라우저 포털에서 **허락** → 앱으로 돌아와 **완료**.
   터미널에서 `claude mcp list` 를 실행했을 때 ax-deploy 가 들어간 줄이 `✔ Connected` 면 준비 끝이에요.

이미 터미널 명령(`claude mcp add … ax-deploy …`)으로 연결해 둔 적이 있으면 먼저
`claude mcp remove ax-deploy -s user` 로 지우세요 — 둘 다 두면 예전 연결이 플러그인 연결을 가려요.

## 쓰기

작업 폴더(git 저장소)에서 Claude 에게 말하면 돼요.

- "사내 포털에 배포해줘" / "사내에 올려줘" / "링크로 공유하고 싶어"
- "배포 상태 봐줘" / "배포가 실패했어"

**어디에 배포할지 말해 주세요.** Vercel 처럼 회사 밖으로 배포하는 도구도 연결돼 있으면, 그냥
"배포해줘"라고 했을 때 Claude 가 그쪽을 고를 수 있어요 — 회사 코드가 회사 밖으로 나가요. 그래서
Claude 가 "사내 배포 포털(AX Deploy)에 올릴까요?"라고 먼저 묻게 해 두었지만, 처음부터 "사내 포털에"
라고 말하는 게 가장 확실해요. 헷갈리지 않게 부르려면 `/ax-deploy:deploy` 를 입력해도 돼요.

처음 배포하는 폴더라면 **서비스 이름**(링크 주소에 들어가요)과 **용도 한 문장**을 물어봐요.

## 안 될 때

- **연결이 안 돼요 (503, "Web Page Blocked", HTML 응답)** → VPN 이 켜져 있으면 끄고 `/mcp` 에서
  ax-deploy 를 다시 연결해 주세요.
- **브라우저가 안 열려요** → 터미널에 찍힌 주소를 복사해 브라우저에서 직접 열어요.
- **인증 오류(401)가 나요** → `/mcp` 에서 ax-deploy 를 골라 **Authenticate** 를 다시 해요(데스크톱 앱은
  세션 레일 → 커넥터 → Ax deploy → **재인증**). 90일 동안
  안 쓰면 다시 로그인해야 하고, 포털 시작하기 화면에서 그 기기 연결을 끊었을 때도 마찬가지예요.

## 0.2.x 에서 올라왔다면

0.3.0 부터 플러그인은 **운영(prod) 포털**에 연결해요. 0.2.x 는 개발(dev) 포털에 연결돼 있었어요.

1. `/plugin update ax-deploy@ax-plugins`
2. Claude Code 를 다시 켜고 `/mcp` 에서 ax-deploy → **Authenticate** 한 번(주소가 바뀌어 다시 로그인해요).

dev 포털에 올렸던 서비스는 운영 포털로 옮겨지지 않아요. 계속 쓰려면 같은 폴더에서 "사내 포털에 배포해줘"로
운영 포털에 새로 올려요.

## 포털 관리자: 개발(dev) 포털에 연결하기

일반 사용자는 이 절이 필요 없어요. 플러그인은 운영 포털 하나에만 연결하고, 포털을 고치고 시험하는
관리자만 dev 포털을 **다른 이름**으로 직접 추가해요.

```
claude mcp add --transport http --scope user ax-deploy-dev https://portal.ax.dev.ondaum.net/api/mcp
```

Claude Code 를 다시 켜고 `/mcp` 에서 **ax-deploy-dev** → **Authenticate**. 두 연결이 함께 보이니,
dev 에 올릴 때는 "dev 에 배포해줘"처럼 어느 쪽인지 말해요. 이름을 `ax-deploy` 로 짓지 마세요 —
플러그인 연결을 가려요(위 「설치」 마지막 줄).

## 0.1.x 에서 올라왔다면

1. `/plugin update ax-deploy@ax-plugins` (또는 지웠다가 다시 설치)
2. Claude Code 를 다시 켜고 `/mcp` 에서 ax-deploy → **Authenticate** 한 번.

예전에 넣은 토큰은 이제 쓰이지 않아요. 포털에서 따로 할 일은 없어요(그 토큰은 다른 도구용으로
그대로 유효).

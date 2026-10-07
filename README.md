# ax-plugins

비개발자를 위한 Claude Code 플러그인 배포처입니다. 플러그인 두 개가 들어 있어요.

| 플러그인 | 하는 일 | 설치 줄 |
|---|---|---|
| `ax-skills` | git 도우미 — 처음 준비, 커밋·push·버전 남기기 | `/plugin install ax-skills@ax-plugins` |
| `ax-deploy` (베타) | 사내 배포 포털 연결 — 설치 때 토큰 한 번, 그 뒤 "배포해줘" (`ax-skills` 를 함께 설치) | `/plugin install ax-deploy@ax-plugins` |

## 설치

Claude Code 에서 첫 줄을 입력한 뒤, 위 표에서 필요한 설치 줄을 입력합니다:

```
/plugin marketplace add daum-ax/ax-plugins
/plugin install ax-skills@ax-plugins
```

그다음 Claude Code 를 완전히 껐다가 다시 켭니다.

- `ax-skills` — 자세한 절차, 업데이트 방법, GitHub 이 막힌 환경에서 zip 으로 설치하는 방법은
  [`plugins/ax-skills/INSTALL.md`](plugins/ax-skills/INSTALL.md) 에 있어요.
- `ax-deploy` — 토큰 발급부터 연결 확인까지 [`plugins/ax-deploy/README.md`](plugins/ax-deploy/README.md) 에 있어요.

## 무엇이 들어 있나요

[`plugins/ax-skills/README.md`](plugins/ax-skills/README.md) 를 봐주세요 — 도구 목록과 설계 원칙.
배포 연결은 [`plugins/ax-deploy/README.md`](plugins/ax-deploy/README.md).

## 고치거나 보태고 싶다면

이 저장소가 개발처이기도 합니다. [`CONTRIBUTING.md`](CONTRIBUTING.md) 에 검사 방법·릴리즈
절차·지켜야 할 원칙을 적어 두었어요. 변경 이력은 [`CHANGELOG.md`](CHANGELOG.md).

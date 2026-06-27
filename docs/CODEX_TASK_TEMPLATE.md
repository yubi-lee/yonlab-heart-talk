# HeartTalk Codex Task Template

Use this template when asking Codex to work in the local repository.

```text
작업명:
[HT-XXX] - [short task name]

목표:
[Describe the goal in one or two sentences.]

현재 경로:
D:\Views\heart_talk

관련 기준 문서:
- AGENTS.md
- README.md
- docs/GOAL.md
- docs/PRODUCT_SPEC.md
- docs/ARCHITECTURE.md
- docs/ACCEPTANCE_CRITERIA.md
- specs/[feature]/spec.md
- specs/[feature]/plan.md
- specs/[feature]/tasks.md

goal:
- [Concrete outcome.]

allowed files:
- [path]
- [path]

forbidden files:
- lib/ unless explicitly allowed
- test/ unless explicitly allowed
- android/
- ios/
- web/
- macos/
- windows/
- linux/
- pubspec.yaml
- pubspec.lock
- .git/
- .env
- signing keys, keystores, jks, p12, pem, private keys
- real PPG, real voice, PII, health-sensitive logs, API keys, tokens

implementation constraints:
- Use Windows PowerShell Native commands.
- Use `D:\Views\heart_talk` as the project root in command examples.
- Preserve existing specs, docs, source, and tests unless explicitly allowed.
- Follow feature-first layered architecture.
- Keep MVP synthetic/demo-data only.
- Do not add dependencies without explicit approval.
- Do not add permissions, network, database, analytics, sync, cloud AI, or signing changes without explicit approval.
- Do not make medical diagnosis, treatment, disease prediction, risk scoring, or mental-health classification claims.
- Codex가 수행한 내용을 최종 보고서에서 한국어로 설명해야 한다.

acceptance criteria:
1. [Criterion with observable result.]
2. [Criterion with observable result.]
3. [Criterion with observable result.]

verification commands:
```powershell
cd D:\Views\heart_talk
git status -sb
powershell -ExecutionPolicy Bypass -File .\scripts\format.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\lint.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\test.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1
git status -sb
```

required final report format:
1. 작업 전 상태
- branch:
- initial git status:
- 확인한 핵심 파일:

2. 변경 파일
- 파일별 변경 요약

3. 생성 파일
- 파일별 생성 목적

4. 실행한 명령과 결과
- 명령:
- 결과:
- 실패/경고 여부:

5. 검증 결과
- format:
- analyze:
- test:
- verify:
- git status:

6. 보안/개인정보 점검
- 실제 PPG/음성 포함 여부:
- 개인정보 포함 여부:
- API key/token/signing key 포함 여부:
- 권한/네트워크/DB 변경 여부:

7. 남은 리스크
- 남은 리스크 또는 없음

8. 다음 권장 작업
- 다음 Codex 작업 후보 1~3개

9. 커밋 권장 여부
- commit 가능 / 보류
- 권장 commit message
```

Completion rule: do not accept "AI says done" as evidence. Record observed command output.

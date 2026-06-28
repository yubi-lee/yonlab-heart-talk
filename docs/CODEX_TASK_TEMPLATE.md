# HeartTalk Codex Task Template

Use this template when asking Codex to work in the local repository:

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
powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1
git diff --check
git status -sb
```

required final report format:
1. 작업 전 상태
- branch:
- initial git status:
- 확인한 핵심 파일:

2. 변경 파일
- 파일별 변경 요약

3. 구현/수정 내용
- 구현 또는 수정한 내용:
- 유지한 운영 원칙:

4. 실행한 명령
- 명령:
- 결과:
- 실패/경고 여부:

5. 검증 결과
- format:
- analyze:
- test:
- diff check:
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
- 권장 commit message:
```

Completion rule: do not accept "AI says done" as evidence. Record observed command output.

## /goal Usage Example

Use `/goal` when the task should persist across turns and must be verified against explicit completion criteria.

```text
/goal
작업명:
HT-DOC-XXX - [HeartTalk documentation task]

목표:
D:\Views\heart_talk 저장소에서 [specific document/workflow alignment goal]을 수행한다.

현재 경로:
D:\Views\heart_talk

허용 파일:
- docs/[allowed file].md
- specs/[allowed feature]/[allowed file].md

수정 금지:
- lib/
- test/
- android/
- ios/
- web/
- macos/
- windows/
- linux/
- pubspec.yaml
- pubspec.lock
- scripts/
- .env
- signing key, keystore, jks, p12 관련 파일

구현/수정 제약:
- Windows PowerShell Native 기준으로 작성한다.
- HeartTalk privacy-first 원칙을 유지한다.
- MVP는 synthetic/demo data only로 유지한다.
- 실제 PPG, 실제 음성, 개인정보, health-sensitive logs, API key/token/signing key를 추가하지 않는다.
- 새 기능 구현이 아니라 문서/운영 체계 정리로 범위를 제한한다.
- Codex 최종 보고는 한국어로 작성한다.

검증 명령:
cd D:\Views\heart_talk
powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1
git diff --check
git status -sb

완료 기준:
- 허용 파일만 변경되어 있다.
- 문서가 AGENTS.md의 운영 원칙과 일치한다.
- verify.ps1이 통과한다.
- git diff --check가 통과한다.
- git status -sb 결과가 보고되어 있다.
```

## HeartTalk Reporting Standard

Codex final reports for HeartTalk must be written in Korean and include the same minimum items as `AGENTS.md`:

1. 작업 전 상태
2. 변경 파일
3. 구현/수정 내용
4. 실행한 명령
5. 검증 결과
6. 보안/개인정보 점검
7. 남은 리스크
8. 다음 권장 작업
9. 커밋 권장 여부

# HeartTalk Acceptance Criteria

## Completion Standard

A HeartTalk task is complete only when the requested scope is implemented and verified with command output evidence. An AI statement such as "completed" is not sufficient.

## Default Quality Gate

Run from the project root:

```powershell
cd D:\Views\heart_talk
powershell -ExecutionPolicy Bypass -File .\scripts\format.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\lint.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\test.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1
git status -sb
```

`scripts/verify.ps1` runs the core gate in this order:

1. Print location.
2. `git status -sb`.
3. `dart format --output=none --set-exit-if-changed .`.
4. `flutter analyze`.
5. `flutter test`.

Android debug build is optional/manual unless the task affects Android build configuration:

```powershell
cd D:\Views\heart_talk
flutter build apk --debug
```

## MVP Acceptance Criteria

- The app remains privacy-first and local-only.
- MVP inputs remain synthetic/demo data or user-entered short text only.
- No real PPG, real voice, PII, health-sensitive logs, API keys, tokens, or signing keys are added.
- No sensitive permissions are added.
- No cloud AI, analytics, sync, or external API dependency is added.
- Product copy remains non-diagnostic.
- Feature-first layered architecture is preserved.
- Existing source and tests are not deleted.
- Verification command output is recorded in `docs/EVIDENCE_LOG.md` or task-specific evidence docs when appropriate.

## Failure Criteria

A task must not be reported as complete if:

- Format, analyze, or test fails and the failure is in scope.
- Verification commands were not run and no clear skip reason is documented.
- App code outside the allowed file list was changed.
- Real sensitive data, credentials, signing material, or health-sensitive logs were introduced.
- A doc contradicts `specs/001-daily-reflection-companion-demo/spec.md` without explicitly marking the spec as authoritative.

## Required Final Report

Codex final reports for HeartTalk must be written in Korean and include:

1. 작업 전 상태
2. 변경 파일
3. 생성 파일
4. 실행한 명령과 결과
5. 검증 결과
6. 보안/개인정보 점검
7. 남은 리스크
8. 다음 권장 작업
9. 커밋 권장 여부

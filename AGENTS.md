# AGENTS.md - HeartTalk

## Project

HeartTalk is a privacy-first Flutter mobile application. The current MVP is the `Daily Reflection Companion Demo`: a small local-only vertical slice that lets a user choose safe demo events or manually enter short text, then generates deterministic friend-style reflection cards and morning briefing cards.

The long-term product direction includes on-device multimodal signal analysis, but the MVP must remain synthetic/demo-data only. Real PPG capture, real voice capture, personal data, health-sensitive logs, cloud AI, analytics, API keys, and signing keys are out of scope unless a future spec and explicit approval authorize them.

## Standard Environment

| Item | Standard |
|---|---|
| OS | Windows 11 |
| Shell | Windows PowerShell Native |
| Project root | `D:\Views\heart_talk` |
| Tool root | `C:\Utils` |
| Flutter SDK | `C:\Utils\flutter` |
| Spec Kit CLI | `C:\Utils\uv-data\tool-bin\specify.exe` |

Always write command examples for this repository from `D:\Views\heart_talk`.

## Required First Steps

Before editing, an agent must:

1. Read `AGENTS.md`.
2. Read `README.md`.
3. Read relevant files under `specs/` and `docs/`.
4. Inspect `pubspec.yaml`, `lib/`, and `test/` structure without modifying forbidden files.
5. Run `git status -sb`.
6. Summarize the current structure, branch/status, and risks before making changes.

## Operating Rules

- Preserve the current Flutter app structure and behavior unless the task explicitly allows app code edits.
- Work in small vertical slices tied to a spec, plan, task, or documented acceptance criteria.
- Treat `specs/` as the source of truth when it conflicts with summary docs.
- Do not delete existing specs, docs, source, tests, or generated evidence unless explicitly approved.
- Do not add dependencies without explicit approval.
- Do not change Android/iOS/native permissions without explicit approval.
- Do not change signing, release, keystore, CI secret, or `.env` configuration.
- Do not use network, database, cloud AI, analytics, or sync unless a future approved spec requires it.
- Completion is evidence-gated: command output proves completion, not an AI statement.

## Allowed Data for Current MVP

- Synthetic/demo conversation events
- Short user-entered text processed locally in the current app session
- Generated reflection card data
- Generated morning briefing card data
- Deterministic test fixtures that contain no personal or sensitive data

## Forbidden Data and Artifacts

Never add, paste, generate, log, or expose:

- Real PPG data
- Real voice recordings or transcripts
- Personally identifiable information
- Health-sensitive logs or user health records
- API keys, access tokens, refresh tokens, credentials, or production secrets
- `.env` contents
- Signing keys, keystores, `.jks`, `.p12`, `.pem`, or private keys
- Production database dumps

## Forbidden MVP Permissions

The MVP must not request camera, microphone, contacts, call log, SMS, location, Health Connect, notification access, background sensor, analytics, or sync permissions.

## Architecture Rules

Use feature-first layered architecture:

```text
lib/
  app/
  core/
  features/
    <feature_name>/
      presentation/
      application/
      domain/
      data/
      infrastructure/
  shared/
```

Current implemented feature:

```text
lib/features/daily_reflection/
  application/
  data/
  domain/
  presentation/
```

Rules:

- Keep UI, application orchestration, domain models/rules, data sources, and infrastructure/adapters separate.
- Domain entities must not depend on Flutter widgets.
- Repository contracts should allow demo data to be replaced by approved real adapters later.
- Future PPG, voice, or model work must be hidden behind explicit adapter boundaries such as `PpgCaptureAdapter`, `VoiceCaptureAdapter`, and `InferenceAdapter`.
- Avoid global mutable state unless the spec explicitly justifies it.

## Quality Gates

Default completion gate:

```powershell
cd D:\Views\heart_talk
powershell -ExecutionPolicy Bypass -File .\scripts\format.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\lint.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\test.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1
git status -sb
```

The underlying commands are:

```powershell
cd D:\Views\heart_talk
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
git status -sb
```

If a task affects Android build configuration, run this manually and record the output:

```powershell
cd D:\Views\heart_talk
flutter build apk --debug
```

## Completion Report Requirements

Final reports must be in Korean and include:

1. 작업 전 상태
2. 변경 파일
3. 생성 파일
4. 실행한 명령과 결과
5. 검증 결과
6. 보안/개인정보 점검
7. 남은 리스크
8. 다음 권장 작업
9. 커밋 권장 여부

Every command result must be based on observed command output. If a command was skipped, explain why.

## Medical and Emotional Safety

Do not add medical diagnosis, treatment, disease prediction, mental-health classification, risk scoring, or emergency advice. Use non-diagnostic reflection language only.

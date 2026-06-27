# HeartTalk

HeartTalk is a privacy-first Flutter mobile app. The current MVP is the `Daily Reflection Companion Demo`, a local-only demo experience that uses safe synthetic/demo inputs and short user-entered text to generate deterministic daily reflection and morning briefing cards.

## Current MVP

- Feature: `Daily Reflection Companion Demo`
- Authoritative spec: `specs/001-daily-reflection-companion-demo/spec.md`
- Implementation surface: `lib/features/daily_reflection`
- Test surface: `test/features/daily_reflection`
- Data policy: synthetic/demo data only
- Processing policy: local-only, deterministic, no cloud AI

Out of scope for the MVP:

- Real PPG capture or raw PPG files
- Real voice recording, transcription, or import
- Phone, SMS, messenger, contact, location, notification, or health-data access
- API keys, tokens, analytics, sync, signing keys, or production secrets
- Medical diagnosis, treatment advice, disease prediction, or risk scoring

## Architecture

HeartTalk uses feature-first layered architecture:

```text
lib/
  features/
    daily_reflection/
      application/
      data/
      domain/
      presentation/
```

See `docs/ARCHITECTURE.md` for the operating architecture rules.

## Development Workflow

HeartTalk is spec-first and evidence-gated:

```text
spec -> plan -> small scoped task -> implementation -> command evidence -> review -> commit
```

Completion is based on command output, not on an AI saying the task is complete.

## Run Locally

```powershell
cd D:\Views\heart_talk
flutter pub get
flutter run
```

## Verify

```powershell
cd D:\Views\heart_talk
powershell -ExecutionPolicy Bypass -File .\scripts\format.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\lint.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\test.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1
git status -sb
```

For Android build sanity checks, run manually when needed:

```powershell
cd D:\Views\heart_talk
flutter build apk --debug
```

## Key Documents

- `AGENTS.md` - agent operating rules
- `docs/GOAL.md` - project goal and MVP scope
- `docs/PRODUCT_SPEC.md` - product direction summary
- `docs/ARCHITECTURE.md` - architecture rules
- `docs/ACCEPTANCE_CRITERIA.md` - quality gates and completion standards
- `docs/CODEX_TASK_TEMPLATE.md` - HeartTalk-specific Codex task template
- `docs/RUNBOOK.md` - Windows PowerShell execution and troubleshooting
- `docs/EVIDENCE_LOG.md` - verification evidence template
- `specs/001-daily-reflection-companion-demo/spec.md` - source-of-truth feature spec

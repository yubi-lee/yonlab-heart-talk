# HeartTalk

HeartTalk은 나를 기억하는 하루 친구를 목표로 하는 privacy-first Flutter 모바일 앱입니다. 현재 MVP는 사용자가 동의한 기억을 기기 안에 저장하고, 역할에 따라 다른 말투로 인사이트와 오늘 시작하기를 보여주며, 저장된 기억을 언제든지 지울 수 있는 local-only companion flow입니다.

## Current MVP

- Feature surface: HeartTalk local memory companion MVP
- Current slices:
  - first-run onboarding
  - local memory consent
  - role selection and role-aware companion tone
  - today record
  - local memory management
  - local insight
  - morning brief
  - 100-day synthetic growth simulation
  - session flow polish
- Implementation surface: `lib/features/daily_reflection`
- Test surface: `test/features/daily_reflection`
- Data policy: approved local memory and synthetic demo data only
- Processing policy: local-only, deterministic, no Cloud AI, no network transfer

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
- `docs/RUNBOOK.md` - Windows PowerShell execution and troubleshooting
- `docs/EVIDENCE_LOG.md` - verification evidence template
- `docs/releases/HT-MVP-RC1.md` - release candidate readiness review
- `docs/releases/HT-MVP-RC1-HANDOFF.md` - rc1 handoff summary
- `specs/001-daily-reflection-companion-demo/spec.md` - original feature baseline
- `specs/002-role-based-local-memory-companion/spec.md` - local memory companion
- `specs/003-local-insight-prediction-engine/spec.md` - local insight engine
- `specs/004-morning-brief-today-start-guide/spec.md` - morning brief
- `specs/005-local-memory-management/spec.md` - memory management
- `specs/006-role-ux-polish/spec.md` - role UX polish
- `specs/007-session-flow-polish/spec.md` - session flow polish
- `specs/007-session-flow-polish/HT-100DAY-SIM-001-spec.md` - 100-day synthetic simulation
- `specs/009-first-run-onboarding/spec.md` - first-run onboarding
# AGENTS.md — HeartTalk

## Project

HeartTalk is a privacy-first Flutter mobile application for on-device multimodal signal analysis. The first MVP uses synthetic PPG-derived heart-rate data only. Real PPG capture, real voice capture, and on-device inference are future features and must not be implemented unless explicitly requested.

## Environment

- OS: Windows 11
- Shell: PowerShell Native
- Tool root: `C:\Utils`
- Project root: `D:\Views\heart_talk`
- Flutter SDK: `C:\Utils\flutter`
- uv: `C:\Utils\uv`
- Spec Kit CLI: `C:\Utils\uv-data\tool-bin\specify.exe`

## Agent Operating Rules

- Work in small, scoped changes.
- Read the relevant spec and task files before editing.
- Propose a plan before making broad changes.
- Do not modify unrelated files.
- Do not add dependencies without explicit approval.
- Do not delete files without explicit approval.
- Do not change database migrations without explicit approval.
- Do not change Android/iOS permissions without explicit approval.
- Do not change signing, release, or CI secrets without explicit approval.

## Architecture Rules

Use feature-first layered architecture.

Recommended structure:

```text
lib/
├─ app/
├─ core/
├─ features/
│  └─ <feature_name>/
│     ├─ presentation/
│     ├─ application/
│     ├─ domain/
│     ├─ data/
│     └─ infrastructure/
└─ shared/
```

Rules:

- Keep UI, domain, data, and infrastructure concerns separate.
- Domain entities must not depend on Flutter widgets.
- Repository contracts must allow synthetic data to be replaced by real adapters later.
- On-device inference must be hidden behind an `InferenceAdapter`.
- Avoid global mutable state unless explicitly justified.

## Privacy and Security Rules

Never include the following in code, fixtures, tests, logs, or prompts:

- Real PPG data
- Real voice recordings
- Personally identifiable information
- Health-sensitive user logs
- API keys
- Access tokens
- `.env`
- signing keys
- keystore files
- production database dumps

MVP 001 must not request:

- camera permission
- microphone permission
- location permission
- contacts permission
- health data permission
- network permission for analytics/sync

## Quality Gates

Run before reporting completion:

```powershell
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
git status -sb
```

If the task affects Android build configuration, also run:

```powershell
flutter build apk --debug
```

## Completion Report Format

Every completion report must include:

```text
1. Changed files
2. Summary of implementation
3. Commands run
4. Command results
5. Remaining risks
6. Follow-up recommendations
7. git status -sb result
```

## Test Policy

- Add or update tests for changed domain, data, and application logic.
- Widget changes require widget tests when practical.
- Do not mark a task complete without test or explicit explanation why a test was not applicable.
- Prefer deterministic tests with synthetic data.

## Medical Claims

Do not add medical diagnosis, treatment, disease prediction, or risk-scoring claims. Use non-diagnostic language only.

# Threat Model - HeartTalk

## 1. Current Scope

This threat model covers the current `Daily Reflection Companion Demo` MVP.
The MVP is a local-only Flutter demo that uses safe demo events or short
non-sensitive manual text to generate deterministic reflection and morning
briefing cards.

The current MVP does not include real PPG, real voice, health data, platform
sensor permissions, network APIs, cloud AI, analytics, crash reporting, local
database storage, account systems, or release signing changes.

## 2. Assets

| Asset | Sensitivity | Current control |
|---|---|---|
| Safe demo events | Low | Synthetic fixtures only |
| Manual text typed by user | Potentially sensitive | User warning and session-only memory |
| Reflection and briefing cards | Potentially sensitive | Session-only memory |
| Source code and docs | Internal | Git review and allowed-file scope |
| Test fixtures | Low | Synthetic data only |
| QA screenshots/XML/text dumps | Potentially sensitive | Review before storing or summarizing |
| API keys/tokens/signing keys | Secret | Forbidden in MVP |
| Real PPG/voice/health data | Sensitive | Forbidden in MVP |

## 3. MVP Security Posture

Current expected controls:

- no sensitive Android/iOS/native permissions
- no network client path, cloud AI call, analytics, sync, or telemetry
- no durable local database or raw manual-input history
- no secrets, API keys, tokens, signing keys, keystores, or release credentials
- deterministic local rule/template generation
- non-diagnostic reflection copy only
- evidence-gated completion based on observed command output

## 4. Threats and Controls

| Threat | Impact | Current control |
|---|---|---|
| Manual text contains personal data | Medium | UI/docs warn to enter only short non-sensitive text; no cloud/network; session-only state |
| Accidental real biometric/voice fixture added | High | Real PPG/voice data is forbidden; docs/specs require synthetic/demo data only |
| Secret leakage through prompts, logs, or commits | High | Secrets and signing material are forbidden artifacts |
| Unapproved permission creep | High | Permission changes require explicit future spec and review |
| Network/cloud AI introduced without review | High | MVP forbids network, cloud AI, analytics, sync, and telemetry |
| Durable storage added too early | Medium | Session-only in-memory policy; storage requires review |
| QA artifact exposes personal-device data | Medium | Screenshots/XML must be inspected; prefer safe emulator evidence or text summaries |
| Medical or mental-health claim appears in UI | High | Non-diagnostic copy rule and test coverage for forbidden wording |
| Over-broad AI edits touch app/platform files | Medium | Allowed-file scopes and evidence-gated review |

## 5. QA Evidence Handling

Evidence may include command output and safe UI observations. Screenshots or
UIAutomator XML dumps must not be committed when they contain personal
notifications, contacts, health data, real messages, credentials, or identifying
manual text.

For physical devices, prefer text evidence that confirms the expected UI state
without capturing personal-device surfaces. If a screenshot/XML dump must be
retained, it needs a separate artifact-retention decision and a masking/review
step before it is added to the repository.

## 6. Required Review Triggers

Security/privacy review is required before any of the following:

- adding network calls, external APIs, cloud AI, analytics, telemetry, or crash SDKs
- adding camera, microphone, contacts, call log, SMS, location, Health Connect,
  notification, or background sensor permissions
- adding real PPG capture, real voice capture, transcript import, or biometric
  signal processing
- adding durable local storage, encrypted storage, export/import, account sync,
  or remote DB usage
- adding model files, inference runtimes, or adapters that process personal,
  biometric, voice, or health-sensitive data
- touching signing keys, keystores, release credentials, `.env`, tokens, or
  production secrets
- adding native platform code that changes permissions, storage, network, or
  background behavior

## 7. Security Review Checklist

```text
[ ] No real PPG data included
[ ] No real voice data included
[ ] No calls, SMS, messenger history, contacts, location, or health data included
[ ] No personal or health-sensitive QA evidence included
[ ] No API keys, tokens, signing keys, keystores, or private keys included
[ ] No new permission added without approval
[ ] No network/cloud AI/analytics/sync/telemetry path added
[ ] No durable local database or raw manual-input history added
[ ] Tests use synthetic/demo data only
[ ] UI copy remains non-diagnostic and non-medical
```

## HT-COMPANION-001 Threat Model Update

New local asset: `LocalMemorySnapshot` stored through `shared_preferences` when explicit consent is enabled. It may contain user-entered profile, relationship, todo, generated reflection entry, role preference, and deterministic keyword-count data.

Additional controls:

- Local memory defaults off.
- Consent category sanitizer removes disallowed categories before persistence.
- Stored information is visible in `내 기억`.
- `Clear all local memory` removes the stored snapshot.
- No raw personal text is printed with `print` or `debugPrint`.
- No network/cloud AI/analytics/sync/account path is added.
- No Android/iOS sensitive permission is added.

Residual risk: `shared_preferences` is not encrypted secure storage. Do not store credentials, secrets, medical records, raw private conversations, or high-sensitivity data in this feature.

## HT-DESIGN-ALIGN-001 Security Alignment

Design alignment tasks are documentation/spec tasks only and must not introduce new runtime surfaces. `Design.md` does not authorize network, cloud AI, analytics, sync, account, native permission, sensor, or platform storage changes.

Role-based companion UX has an additional safety constraint: romantic or parental tone must never become dependency-inducing, obsessive, sexual, controlling, shaming, or blaming. The role is a presentation/tone preference, not a real relationship substitute or clinical support role.

## HT-INSIGHT-001 Threat Model Update

New local behavior: `LocalInsightService` derives a transient insight from `LocalMemorySnapshot`, `CompanionPreference`, and `CompanionGrowthState`.

Additional controls:

- Insight generation is deterministic and local-only.
- Consent OFF returns fallback insight instead of personalized memory-based insight.
- Relationship memory is reflected at category level and should not expose raw relationship notes in insight questions.
- No raw personal input is printed, debug-printed, logged, or sent over a network.
- Insight copy must avoid diagnosis, treatment, risk scoring, certainty claims, shame, blame, dependency, or real relationship replacement.

Residual risk: the insight UI may summarize sensitive information if the user stores sensitive memory. Keep the non-sensitive input guidance and `shared_preferences` non-encrypted storage warning visible in docs and QA.

## HT-MORNING-001 Threat Model Update

New local behavior: `MorningBriefService` derives a transient morning brief from `LocalMemorySnapshot`, `LocalInsightSummary`, `CompanionPreference`, and `CompanionGrowthState`.

Additional controls:

- Morning brief generation is deterministic and local-only.
- Consent OFF returns fallback morning copy instead of personalized memory-based copy.
- The card must not claim certainty, prediction accuracy, diagnosis, treatment, or emergency support.
- Role-aware morning copy must keep lover and parent tones free from obsession, dependency pressure, sexual language, control, blame, or shame.
- No raw personal input is printed, debug-printed, logged, or sent over a network.
- Existing session-only `Keep for morning -> 내일 시작 메모` flow remains separate from the persistent local-memory-based morning brief.

Residual risk: the morning brief may still summarize sensitive meaning if the user stores sensitive information in local memory. Keep the non-sensitive input guidance and the `shared_preferences` non-encrypted storage warning visible in docs and QA.

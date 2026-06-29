# Data Flow and Retention - HeartTalk

## 1. Current MVP Privacy Boundary

The current MVP is the `Daily Reflection Companion Demo`. It uses only:

- safe synthetic/demo conversation events bundled with the app
- short non-sensitive manual text typed directly by the user
- generated daily reflection card data
- generated morning briefing card data
- current-session UI state

The MVP does not read or collect real PPG, voice, calls, SMS, messenger history,
notifications, contacts, location, Health Connect data, camera input, microphone
input, account data, analytics, telemetry, crash reports, cloud AI prompts, or
production database records.

## 2. MVP Data Flow

```text
Demo event or short manual text
-> visible privacy boundary and local validation
-> deterministic rule/template reflection engine
-> daily reflection card
-> user confirmation
-> session-only in-memory kept state
-> in-app morning briefing card
-> reset/delete clears current session output
```

No current MVP data flow requires network access, a database, background sync,
cloud AI, native sensor access, or sensitive platform permissions.

## 3. Allowed Data

| Data | Allowed in MVP | Retention |
|---|---|---|
| Safe demo conversation event | Yes | Bundled fixture/source code only |
| Manual text typed by the user | Yes, with non-sensitive warning | Current app session only |
| Reflection preview/card | Yes | Current app session only |
| Morning briefing card | Yes | Current app session only |
| Unit/widget test fixtures | Yes, if synthetic | Repository test files |
| QA screenshot/XML evidence | Yes, only if no personal/sensitive data is visible | Prefer outside-repo storage unless explicitly approved |

Manual text is treated as user-controlled session input. The UI and docs must
warn users not to enter personal, health-sensitive, credential, or private
conversation content into the MVP.

## 4. Forbidden Data

Never add, paste, generate, log, or preserve the following in the MVP:

- real PPG samples, raw sensor files, or biometric traces
- real voice recordings, transcripts, or audio features
- calls, SMS, messenger logs, notifications, contacts, or location data
- Health Connect data, medical records, health-sensitive logs, or diagnoses
- API keys, access tokens, refresh tokens, credentials, signing keys, keystores,
  `.jks`, `.p12`, `.pem`, private keys, or production database dumps
- analytics, telemetry, crash-report payloads, or cloud AI prompts containing
  user data

References to these items are allowed only as forbidden/out-of-scope examples.

## 5. Retention Policy

| Item | MVP policy | Future policy trigger |
|---|---|---|
| Demo event fixture | May remain in source when synthetic and safe | Review if fixture resembles real personal data |
| Manual text | Session-only in memory | Any durable storage requires privacy/security review |
| Generated reflection card | Session-only in memory | Durable history requires approved storage design |
| Morning briefing card | Session-only in memory | Notifications/history require separate spec |
| Logs | No sensitive or raw user content | Structured logging requires review |
| QA evidence | Only safe screenshots/XML/text summaries | Evidence repository policy required for persistent artifacts |

The current `Keep for morning` behavior is session-only. App restart, reset, or
delete must not rely on durable local storage to preserve prior reflection state.

## 6. QA Evidence Handling

QA screenshots, UIAutomator XML dumps, and manual notes must be reviewed before
they are added to the repository or evidence log.

Allowed evidence:

- command output from format/analyze/test/build commands
- screenshots or XML from emulator sessions that show only safe demo data
- physical-device UI text evidence when it avoids personal-device screenshots
- text summaries that do not include personal or sensitive user content

Do not store QA artifacts if they expose personal notifications, contacts,
device identifiers beyond test device names, health data, real messages, or
manual text that could identify a person.

## 7. Future Privacy Review Triggers

A separate approved spec and privacy/security review are required before adding:

- real PPG capture or PPG file import
- real voice recording, transcript import, or audio analysis
- phone, SMS, messenger, notification, contact, location, camera, microphone, or
  Health Connect permission use
- durable local storage, encrypted storage, export/import, or account sync
- network APIs, cloud AI, analytics, telemetry, crash reporting, or remote DBs
- on-device inference adapters that process biometric, voice, or personal data
- release signing, production secrets, or deployment credential handling

Until such a review is complete, the Daily Reflection MVP remains local-only,
deterministic, demo/manual-input based, and session-only.

## HT-COMPANION-001 Local Memory Data Flow

Approved local memory flow:

```text
User enables local memory consent
-> user selects role and enters approved profile/person/todo memory
-> app sanitizes LocalMemorySnapshot by consent category
-> app stores one JSON snapshot through shared_preferences
-> app restart restores the snapshot
-> growth level is calculated deterministically in memory
-> `내 기억` displays stored categories and clear-all control
```

Stored categories when consent permits them:

| Category | Example | Retention |
|---|---|---|
| Profile | display name and simple preference context | Until clear-all or consent off |
| Reflection entries | generated summary/card metadata kept by user | Until clear-all or consent off |
| People | user-entered relationship note | Until clear-all or consent off |
| Todos | user-entered next action | Until clear-all or consent off |
| Recurring keywords | deterministic tag counts, not raw OS data | Until clear-all or consent off |

HT-COMPANION-001 still does not read calls, SMS, messenger history, notifications, voice, PPG, contacts, location, health data, camera, microphone, account data, analytics, telemetry, crash reports, cloud AI prompts, or remote records.

## HT-DESIGN-ALIGN-001 Privacy/Security Alignment

Design alignment does not change the privacy/security posture:

- No server transfer.
- No Cloud AI or LLM API.
- No analytics, telemetry, sync, or account system.
- No Android/iOS sensitive permission changes.
- No automatic access to voice, phone, SMS, messenger, contacts, calendar, location, or health data.
- `shared_preferences` remains non-encrypted local key-value storage and must not be used for credentials, secrets, medical records, raw private conversations, or other high-sensitivity data.
- Growth level remains deterministic local logic and must not be framed as psychological diagnosis, treatment judgment, risk score, or clinical prediction.

## HT-INSIGHT-001 Local Insight Data Flow

Local insight flow:

```text
Consent-filtered LocalMemorySnapshot
-> deterministic LocalInsightService
-> in-memory LocalInsightSummary
-> `오늘의 인사이트` UI display
```

The insight summary is derived at render time and is not stored as a new durable record. It uses approved local memory categories only when local memory consent is enabled. If consent is off, the engine returns fallback copy and does not personalize from stored profile, reflection, relationship, todo, or keyword data.

The feature adds no network call, Cloud AI, analytics, sync, account, notification, OS data access, native permission, or new dependency.

## HT-MORNING-001 Morning Brief Data Flow

Morning brief flow:

```text
Consent-filtered LocalMemorySnapshot
-> deterministic LocalInsightService
-> deterministic MorningBriefService
-> in-memory `오늘 시작하기` UI card
```

The morning brief is derived at render time and is not stored as a separate durable record. It uses approved local memory only when local memory consent is enabled. If consent is off, storage is empty, or the user clears all local memory, the app returns a fallback morning brief and does not personalize from profile, reflection, people, todo, or recurring-keyword data.

The feature adds no network call, Cloud AI, notification permission, background scheduler, analytics, sync, account, OS data access, native permission, or new dependency.

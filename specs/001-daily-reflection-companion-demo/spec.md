# Feature Specification: Daily Reflection Companion Demo

**Feature Branch**: `001-daily-reflection-companion-demo`
**Feature Directory**: `specs/001-daily-reflection-companion-demo`
**Created**: 2026-06-22
**Status**: Draft
**Source**: Restored readable version of HeartTalk MVP 001 spec

## Feature Name

Daily Reflection Companion Demo

## Summary

HeartTalk MVP 001 is a privacy-first Flutter demo that helps a user close the day with a gentle reflection and start the next morning with a short briefing card.

The MVP uses only safe demo conversation events or short non-sensitive text typed directly by the user. It does not read phone calls, SMS, messenger history, notifications, voice, PPG, contacts, location, health data, or any external account data. Reflection output is generated locally with deterministic rule/template logic so the feature remains testable and does not require cloud AI.

## User Value

The user can experience the HeartTalk product direction without sharing private conversation history, biometric signals, voice recordings, or health-sensitive logs. The app provides a lightweight companion-style reflection, not a diagnosis, therapy session, risk score, or automated surveillance feature.

The user value is:

- Close the day with a short, friendly summary.
- Notice carry-over items for tomorrow without pressure.
- See a simple morning briefing based on a confirmed reflection.
- Stay in control of what is entered, kept, reset, or deleted.
- Understand the privacy boundary before using the feature.

## MVP Scope

In scope for MVP 001:

- Show a privacy notice before or near user input.
- Provide at least five safe demo conversation events.
- Allow short manual text input from the user.
- Treat manual input as non-sensitive demo text and process it locally.
- Generate a deterministic reflection preview.
- Generate a daily reflection card.
- Let the user keep, discard, reset, or delete current session output.
- Generate a morning briefing card from confirmed reflection state.
- Use feature-first layered architecture under `lib/features/daily_reflection`.
- Verify behavior with deterministic unit and widget tests.

## Out of Scope

Out of scope for MVP 001:

- Real PPG capture, raw PPG files, or biometric signal processing.
- Real voice recording, transcript import, or audio analysis.
- Phone call, SMS, messenger, notification, contact, location, or health-data access.
- Camera, microphone, contacts, call log, SMS, location, notification access, Health Connect, or background sensor permissions.
- Cloud AI, external APIs, analytics, sync, account systems, or remote storage.
- Local database or durable storage of raw manual input.
- Medical diagnosis, treatment advice, disease prediction, mental-health classification, emergency guidance, or risk scoring.
- A full chatbot interface, persona marketplace, romantic persona, or complex AI persona system.
- Android/iOS release signing or production secret handling.

Future PPG, voice, inference, storage, or account features must be specified separately as non-MVP work and require explicit privacy/security review before implementation.

## Primary Flow

```text
Open app
-> read privacy boundary
-> choose demo event or enter short non-sensitive text
-> generate local deterministic reflection preview
-> show daily reflection card
-> user confirms, discards, edits, resets, or deletes current output
-> show morning briefing card when a confirmed reflection exists
```

## User Stories

### US-001: Generate Reflection from Demo Event

**As a** privacy-conscious user,
**I want** to choose a safe demo event and see a reflection result,
**So that** I can understand the HeartTalk experience without entering personal data.

Acceptance scenarios:

```gherkin
Scenario: Generate reflection from demo event
  Given the app shows at least five demo conversation events
  When the user selects one demo event
  Then the app generates a short friendly reflection response
  And the app shows a daily reflection card
  And the app identifies the source as demo data
  And no phone, message, voice, PPG, contact, location, health, or sensor permission is requested
```

### US-002: Generate Reflection from Manual Text

**As a** user who wants to end the day lightly,
**I want** to enter a short note myself,
**So that** the app can help organize my day without automatically collecting private data.

Acceptance scenarios:

```gherkin
Scenario: Generate reflection from manual text
  Given the input screen shows a privacy notice
  When the user enters one or more non-sensitive sentences
  And the user requests a reflection preview
  Then the app generates a deterministic local reflection
  And the input is not sent to an external server
  And the user can decide whether to keep, discard, edit, reset, or delete the result
```

### US-003: Understand the Privacy Boundary

**As a** user concerned about privacy,
**I want** clear language about what the app does and does not collect,
**So that** I can use the MVP without worrying about hidden phone, message, voice, PPG, or cloud AI processing.

Acceptance scenarios:

```gherkin
Scenario: Show privacy boundary before input
  Given the user opens the reflection screen
  Then the app states that it does not automatically read calls, SMS, messengers, notifications, voice, PPG, contacts, location, or health data
  And the app states that MVP processing is local-only
  And the app does not request sensitive permissions
```

### US-004: View Morning Briefing

**As a** returning user,
**I want** to see a simple morning card based on what I kept,
**So that** I can start the day with one gentle next step.

Acceptance scenarios:

```gherkin
Scenario: Show morning briefing from confirmed reflection
  Given a daily reflection card was confirmed by the user
  When the user opens or returns to the morning briefing area
  Then the app shows a start line, first thing, and tone hint
  And the app does not use push notifications in MVP 001
```

### US-005: Reset or Delete Current Output

**As a** privacy-conscious user,
**I want** to clear the current reflection state,
**So that** I control what remains visible in the session.

Acceptance scenarios:

```gherkin
Scenario: Reset current reflection
  Given a reflection preview or card is displayed
  When the user chooses reset or delete
  Then the app clears current session data
  And the app returns to a safe empty state
```

### US-006: Handle Empty or Unsupported Input Safely

**As a** user,
**I want** the app to respond safely to empty or unclear input,
**So that** it does not produce confusing, judgmental, or diagnostic output.

Acceptance scenarios:

```gherkin
Scenario: Empty manual input
  Given the manual input field is empty
  When the user requests reflection
  Then the app does not generate a reflection
  And the app shows a short validation message
```

## Functional Requirements

### FR-001: Demo Event Selection

The app must provide safe demo events that can be used without personal data.

Acceptance criteria:

- At least five demo events are available.
- Demo events contain no real personal data, phone numbers, emails, addresses, real PPG, real voice, or health-sensitive logs.
- Demo events are clearly treated as synthetic/demo data.
- Demo event categories may include `work_coordination`, `family_conversation`, `gratitude`, `tomorrow_task`, and `unresolved_talk`.

### FR-002: Manual Text Input

The app must allow the user to type short non-sensitive text for local reflection.

Acceptance criteria:

- The user can enter at least one sentence.
- Empty input is rejected with a short validation message.
- Manual input generates a reflection preview only after the user requests it.
- Manual input is not sent to an external server.
- Manual input is handled as current-session state unless a future approved spec introduces storage.

### FR-003: Privacy Notice

The app must show a clear privacy boundary.

Required notice content:

- The MVP does not automatically read calls, SMS, messenger history, notifications, voice, PPG, contacts, location, or health data.
- The MVP uses only demo events or text the user enters directly.
- The MVP does not use cloud AI.
- The MVP processing is local-only and deterministic.

Acceptance criteria:

- The notice appears before or near the input flow.
- The notice uses simple user-facing language.
- No sensitive permission request appears in the MVP flow.

### FR-004: Local Rule-Based Reflection Engine

The app must use deterministic local rule/template logic for MVP reflection generation.

Pipeline:

```text
Demo event or manual input
-> lightweight privacy/safety check
-> event parser
-> tone/context signal scorer
-> reflection planner
-> template response generator
-> user confirmation
-> daily reflection card
```

Acceptance criteria:

- The engine does not call a cloud API.
- The same input produces testable deterministic output.
- Output is reflection-oriented, not diagnostic.
- The implementation keeps future on-device inference replaceable behind an adapter boundary.

### FR-005: Event Parser

The app should classify input into lightweight reflection categories used internally by the reflection engine.

Supported categories:

- `task`
- `emotionCue`
- `conversation`
- `promise`
- `conflict`
- `gratitude`
- `idea`
- `unresolved`
- `followUp`

Acceptance criteria:

- At least five categories are supported.
- Categories are used to shape output and tests.
- Category labels are not presented as medical, mental-health, or risk classifications.

### FR-006: Tone and Context Signals

The app should infer simple internal context signals using rules.

Supported signals:

- `tired`
- `coordination`
- `gratitude`
- `unresolved`
- `needsOrganization`
- `tomorrowTask`
- `gentleClosure`

Acceptance criteria:

- Signals are internal helpers for response shaping.
- Signals are not shown as quantified emotional states or health metrics.
- The app does not label the user as depressed, anxious, at risk, or medically unwell.

### FR-007: Reflection Response Generation

The app must generate short, supportive, non-diagnostic response text.

Acceptance criteria:

- Default response length is 2 to 4 short sentences.
- The response avoids judgment, pressure, diagnosis, and therapy-like claims.
- The response does not repeat the user's entire input verbatim.
- The response may summarize, gently organize, and suggest one light next step.
- The response never claims medical, mental-health, or safety conclusions.

### FR-008: Daily Reflection Card

The app must create a daily reflection card.

Required fields:

```text
dayFlow
feelingCue
carryOver
tomorrowLine
```

Acceptance criteria:

- Each field is understandable to a general user.
- `feelingCue` is reflective language, not a diagnosis.
- `carryOver` and `tomorrowLine` are gentle and optional, not prescriptive.
- The card is generated from demo/manual input and current-session state.

### FR-009: Morning Briefing Card

The app must create a morning briefing card when confirmed reflection state exists.

Required fields:

```text
startLine
firstThing
toneHint
```

Acceptance criteria:

- Push notifications are excluded from MVP 001.
- The card is visible in-app only.
- If no confirmed reflection exists, the app shows a demo/empty state rather than pretending to have memory.

### FR-010: User Confirmation

The app must let the user decide what to keep.

Supported actions:

- Keep current reflection.
- Edit or generate a new preview when supported by the current UI.
- Discard current preview.
- Reset/delete current session output.

Acceptance criteria:

- The app does not silently commit raw input as durable memory.
- The user makes the final keep/discard/reset choice.
- MVP prioritizes structured reflection card state over raw text storage.

### FR-011: Reset and Delete UX

The app must let the user clear current session output.

Acceptance criteria:

- The user can clear a generated reflection preview or card.
- Clearing returns the UI to a safe empty state.
- Clearing does not require network access, account login, or external service calls.

## Non-Functional Requirements

### NFR-001: Privacy-First by Default

- No sensitive permission requests.
- No network transfer.
- No cloud AI.
- No real phone, message, voice, PPG, health, contact, or location data.
- Minimal current-session state only.
- User confirmation before keeping reflection output.

### NFR-002: Local-Only Processing

- No external API calls.
- Deterministic outputs suitable for tests.
- Template/rule-based MVP response generation.
- Any future masking, storage, model, or cloud feature requires a separate approved spec.

### NFR-003: Testability

The following behavior must be testable:

- demo event loading
- empty input validation
- event parsing
- tone/context scoring
- reflection planning
- template response generation
- daily card generation
- morning card generation
- reset/delete flow
- forbidden diagnostic copy avoidance

### NFR-004: Maintainability

The implementation follows feature-first layered architecture.

Expected structure:

```text
lib/
  features/
    daily_reflection/
      domain/
      data/
      application/
      presentation/
```

Responsibilities:

- `domain`: models, enums, contracts, rule result objects
- `data`: safe demo data and in-memory repositories
- `application`: parser, scorer, planner, reflection engine, orchestration
- `presentation`: screens, cards, input, confirmation, reset/delete UI

### NFR-005: No Overbuild

The MVP focuses on one small product validation slice.

MVP must not add:

- complex AI persona systems
- full chatbot UI
- database schema
- account system
- notification system
- microphone or file import
- charting, sensor, or inference dependencies
- production analytics or sync

## Privacy and Security Constraints

### Allowed Data

- safe demo conversation events
- short non-sensitive manual text entered by the user
- generated reflection card
- generated morning briefing card
- current-session state

### Forbidden Data

- real PPG raw data
- real voice recording
- real call recording or transcript
- SMS or messenger history
- call logs
- contacts
- location
- personal profiles
- health logs
- API keys
- access tokens
- signing keys
- production database content

### Forbidden Permissions

```text
Camera
Microphone
Contacts
Call Log
SMS
Location
Health Connect
Background sensor access
Notification access
```

### Forbidden Copy

The app must not say or imply:

```text
You are depressed.
You are anxious.
You are at risk.
You need treatment.
You have a mental-health problem.
Your health condition is poor.
Your stress level is high.
There is a medical problem.
This predicts your illness or safety risk.
```

### Allowed Copy Style

The app may use gentle, non-diagnostic reflection language such as:

```text
Today's note shows a lot of coordination.
It looks like there is one thing to carry into tomorrow.
You can stop here for today.
Tomorrow can start with one small step.
This reflection is based only on what you selected or typed.
```

## UX Acceptance Criteria

- Privacy boundary is visible before or near input.
- Demo data is clearly labeled as demo/synthetic.
- Manual input has an empty-state validation message.
- Reflection preview appears after demo/manual input.
- Confirmation controls are available.
- Daily reflection card fields are visible.
- Morning briefing empty state appears when no confirmed reflection exists.
- Reset/delete returns the flow to a safe empty state.
- Copy stays companion-like, gentle, and non-diagnostic.

## Technical Acceptance Criteria

- Feature ID remains `001-daily-reflection-companion-demo`.
- Implementation remains under `lib/features/daily_reflection`.
- No app code changes are required by this spec restoration task.
- No new dependencies are required.
- No sensitive permissions are introduced.
- No network, analytics, sync, cloud AI, database, or account system is introduced.
- Domain/application logic remains deterministic and testable.
- The quality gate passes:

```powershell
cd D:\Views\heart_talk
powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1
git diff --check
git status -sb
```

## Key Entities

### DemoConversationEvent

```dart
class DemoConversationEvent {
  final String id;
  final String title;
  final String scenario;
  final String inputText;
  final List<String> tags;
}
```

### ReflectionInput

```dart
class ReflectionInput {
  final String id;
  final String text;
  final ReflectionInputSource source;
  final DateTime createdAt;
}

enum ReflectionInputSource {
  demo,
  manualText,
}
```

### ParsedReflectionEvent

```dart
class ParsedReflectionEvent {
  final List<ReflectionCategory> categories;
  final List<ReflectionSignal> signals;
  final List<String> actionHints;
}

enum ReflectionCategory {
  task,
  emotionCue,
  conversation,
  promise,
  conflict,
  gratitude,
  idea,
  unresolved,
  followUp,
}
```

### ReflectionSignal

```dart
class ReflectionSignal {
  final ReflectionSignalType type;
  final int weight;
}

enum ReflectionSignalType {
  tired,
  coordination,
  gratitude,
  unresolved,
  needsOrganization,
  tomorrowTask,
  gentleClosure,
}
```

### DailyReflectionCard

```dart
class DailyReflectionCard {
  final String dayFlow;
  final String feelingCue;
  final String carryOver;
  final String tomorrowLine;
  final DateTime createdAt;
  final bool confirmedByUser;
}
```

### MorningBriefingCard

```dart
class MorningBriefingCard {
  final String startLine;
  final String firstThing;
  final String toneHint;
  final DateTime createdAt;
}
```

## Test Strategy

### Unit Tests

- demo event repository returns at least five safe events
- demo events do not contain obvious personal data
- empty input is rejected
- parser maps known keywords to expected categories
- scorer maps known keywords to expected internal signals
- planner generates expected `dayFlow`, `feelingCue`, `carryOver`, and `tomorrowLine`
- generator avoids forbidden diagnostic copy
- morning card is created from confirmed daily card
- reset/delete clears volatile state

### Widget Tests

- privacy notice appears before or near input
- demo event list is visible
- manual text input validates empty text
- reflection preview appears after demo/manual input
- confirmation actions are visible
- daily reflection card fields are visible
- morning briefing empty state appears when no confirmed card exists
- reset/delete returns to safe empty state

### Privacy/Security Review

- no Android/iOS sensitive permissions added
- no network, analytics, sync, or cloud AI dependency added
- no real PPG, voice, user, or health-sensitive fixture added
- no API keys, signing keys, tokens, or production DB artifacts added
- no medical diagnosis, treatment, disease prediction, risk scoring, or mental-health classification copy added

## Open Questions / Follow-up

- Should manual text remain session-only for all MVP demos, or should a later spec add explicit local persistence?
- Should a future version include a stronger local personal-data warning before manual input?
- What adapter contract should be used if future on-device PPG, voice, or inference work is approved?
- Should existing historical docs that mention the old synthetic PPG dashboard be updated to point to this MVP?

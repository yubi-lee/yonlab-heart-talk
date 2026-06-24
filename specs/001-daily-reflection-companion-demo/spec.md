# Feature Specification: Daily Reflection Companion Demo

**Feature Branch**: `001-daily-reflection-companion-demo`
**Feature Directory**: `specs\001-daily-reflection-companion-demo`
**Created**: 2026-06-22
**Status**: Draft
**Input**: HeartTalk MVP PRD v0.2 — `HeartTalk 001 — 하루 끝 친구 Demo`

## 1. Feature Summary

### Feature Name

**Daily Reflection Companion Demo**

### User Value

사용자는 실제 전화, 메시지, 음성, PPG 데이터를 공유하지 않고도 하루의 대화 조각과 감정 단서를 짧게 입력하여, 친구처럼 하루를 마무리하고 내일의 한 문장을 남길 수 있다.

### Goal

Demo conversation data와 사용자의 짧은 직접 입력만으로 privacy-first daily reflection UX를 검증한다.

### Primary Flow

```text
Open app
→ Choose demo event or enter short text
→ Generate local reflection response
→ Show daily reflection card
→ Ask user confirmation
→ Generate morning briefing card
→ Allow delete/reset
```

## 2. User Scenarios & Testing

### Primary User Story

하루의 대화와 감정을 가볍게 정리하고 싶은 사용자는, 실제 메시지·통화·음성·PPG 데이터를 공유하지 않고도 demo event를 선택하거나 짧은 텍스트를 직접 입력해 하루 마무리 카드와 다음 아침에 볼 수 있는 한 문장을 만들 수 있다.

### Priority 1 User Stories

#### US-001 — Demo event로 하루 마무리 생성

**As a** privacy-conscious user,
**I want** 민감정보가 없는 demo conversation event를 선택해 하루 마무리 결과를 확인하고,
**So that** 실제 개인 데이터를 넣지 않고도 HeartTalk의 핵심 경험을 이해할 수 있다.

**Acceptance Scenarios**

```gherkin
Scenario: Generate reflection from demo event
  Given the app shows at least five demo conversation events
  When the user selects one demo event
  Then the app generates a short friend-style reflection response
  And the app shows a daily reflection card
  And the app clearly identifies that the source is demo data
  And no phone, message, voice, PPG, contact, location, or sensor permission is requested
```

#### US-002 — 짧은 직접 입력으로 reflection 생성

**As a** user who wants to end the day lightly,
**I want** 오늘 있었던 일을 짧게 직접 입력하고,
**So that** 앱이 판단이나 진단 없이 하루 흐름과 내일의 한 문장을 정리해준다.

**Acceptance Scenarios**

```gherkin
Scenario: Generate reflection from manual text
  Given the input screen shows a privacy notice
  When the user enters one or more sentences
  And the user requests a reflection preview
  Then the app generates a deterministic local reflection
  And the result is not sent to any external server
  And the user can decide whether to keep, edit, discard, or reset the result
```

#### US-003 — Privacy notice 확인

**As a** user concerned about privacy,
**I want** 앱이 무엇을 읽지 않고 무엇을 전송하지 않는지 명확히 알 수 있고,
**So that** 자동 수집이나 cloud AI 사용에 대한 불안을 줄일 수 있다.

**Acceptance Scenarios**

```gherkin
Scenario: Show privacy boundary before input
  Given the user opens the reflection screen
  Then the app states that it does not automatically read calls, SMS, messengers, notifications, voice, or PPG
  And the app states that MVP processing is local-only
  And the app does not request sensitive permissions
```

### Priority 2 User Stories

#### US-004 — Morning briefing card 확인

**As a** returning user,
**I want** 전날 남기기로 선택한 내용을 아침 카드로 확인하고,
**So that** 하루를 한 문장으로 부드럽게 시작할 수 있다.

```gherkin
Scenario: Show morning briefing from confirmed reflection
  Given a daily reflection card was confirmed by the user
  When the user opens the morning briefing view
  Then the app shows a start line, first thing, and tone hint
  And the app does not use push notification in MVP 001
```

#### US-005 — Delete/reset 통제

**As a** privacy-conscious user,
**I want** 생성된 카드와 현재 입력을 지우거나 초기화할 수 있고,
**So that** 내가 남길 내용을 직접 통제할 수 있다.

```gherkin
Scenario: Reset current reflection
  Given a reflection preview or card is displayed
  When the user chooses reset or delete
  Then the app clears current session data
  And the app returns to a safe empty state
```

### Priority 3 User Stories

#### US-006 — 안전한 empty/error 상태

**As a** user,
**I want** 빈 입력이나 매칭되지 않는 입력에도 앱이 안전하게 반응하고,
**So that** 앱이 진단적이거나 과장된 응답을 만들지 않는다.

```gherkin
Scenario: Empty manual input
  Given the manual input field is empty
  When the user requests reflection
  Then the app does not generate a reflection
  And the app shows a short validation message
```

## 3. Functional Requirements

### FR-001 — Demo Event Selection

앱은 사용자가 선택할 수 있는 demo conversation event 목록을 제공해야 한다.

Acceptance Criteria:

- 최소 5개의 demo event가 제공된다.
- 각 demo event는 민감정보를 포함하지 않는다.
- demo event는 실제 사용자 대화처럼 보이되 명확히 synthetic/demo data로 관리된다.
- demo event는 `work_coordination`, `family_conversation`, `gratitude`, `tomorrow_task`, `unresolved_talk` 같은 시나리오를 포함할 수 있다.

### FR-002 — Direct Text Input

앱은 사용자가 짧은 텍스트를 직접 입력할 수 있게 해야 한다.

Acceptance Criteria:

- 사용자는 1개 이상의 문장을 입력할 수 있다.
- 빈 입력은 처리하지 않는다.
- 입력 후 reflection preview가 생성된다.
- 입력값은 외부 서버로 전송되지 않는다.
- 입력값은 기본적으로 session-only로 처리한다.
- 저장 전 사용자 확인을 거친다.

### FR-003 — Privacy Notice

앱은 입력 전 privacy boundary를 짧고 이해하기 쉽게 안내해야 한다.

필수 안내:

- 자동으로 메시지나 통화를 읽지 않음
- 사용자가 직접 입력하거나 선택한 내용만 사용
- MVP에서는 cloud AI를 사용하지 않음
- MVP에서는 실제 음성, PPG, 전화 기록을 사용하지 않음

Acceptance Criteria:

- 첫 화면 또는 입력 화면에 privacy notice가 표시된다.
- notice는 짧고 이해하기 쉬워야 한다.
- 권한 요청이 발생하지 않아야 한다.

### FR-004 — Local Rule-based Reflection Engine

앱은 local rule-based reflection engine을 통해 입력을 구조화해야 한다.

Pipeline:

```text
Demo/User Input
→ Privacy Filter
→ Event Parser
→ Tone & Context Scorer
→ Reflection Planner
→ Template Response Generator
→ User Confirmation
→ Daily Reflection Card
```

Acceptance Criteria:

- 엔진은 cloud API를 호출하지 않는다.
- 엔진은 deterministic rule/template 기반으로 동작한다.
- 동일 입력에 대해 테스트 가능한 결과를 생성한다.
- 결과는 diagnosis가 아니라 reflection이어야 한다.
- 향후 on-device AI로 교체 가능한 interface 경계를 둔다.

### FR-005 — Event Parser

앱은 입력에서 다음 단서를 분류해야 한다.

Supported categories:

- task
- emotionCue
- conversation
- promise
- conflict
- gratitude
- idea
- unresolved
- followUp

Acceptance Criteria:

- 최소 5개 이상의 category를 지원한다.
- category 결과는 사용자에게 확정적 판단처럼 표현되지 않는다.
- “~처럼 보여요”, “~가 남아 있어요” 수준의 표현을 사용한다.

### FR-006 — Tone & Context Scorer

앱은 입력에서 tone/context signal을 rule 기반으로 추정해야 한다.

Supported signals:

- tired
- coordination
- gratitude
- unresolved
- needsOrganization
- tomorrowTask
- gentleClosure

Acceptance Criteria:

- signal은 내부 구조화에만 사용한다.
- signal score를 사용자에게 수치화된 심리 상태처럼 보여주지 않는다.
- `우울`, `불안`, `위험` 등 진단성 label을 사용하지 않는다.

### FR-007 — Reflection Response Generation

앱은 친구 persona 기반의 짧은 응답을 생성해야 한다.

Acceptance Criteria:

- 응답은 2~4문장 이내를 기본으로 한다.
- 판단하지 않는다.
- 과하게 위로하지 않는다.
- 할 일을 강하게 압박하지 않는다.
- 의료·상담·진단처럼 말하지 않는다.
- 사용자의 입력을 요약하되 원문 전체를 반복하지 않는다.

### FR-008 — Daily Reflection Card

앱은 하루 마무리 카드를 생성해야 한다.

Required fields:

```text
오늘의 흐름
마음 단서
남겨둘 일
내일의 한 문장
```

Acceptance Criteria:

- 모든 필드는 사용자가 이해하기 쉬운 짧은 문장이어야 한다.
- 마음 단서는 진단이 아니라 표현 기반 reflection이어야 한다.
- 내일의 한 문장은 actionable하지만 압박적이지 않아야 한다.

### FR-009 — Morning Briefing Card

앱은 전날 사용자가 남기기로 선택한 내용을 바탕으로 아침 브리핑 카드를 표시해야 한다.

Required fields:

```text
오늘의 시작 문장
먼저 볼 일
말투 힌트
```

Acceptance Criteria:

- 실제 push notification은 MVP 범위에서 제외한다.
- 사용자가 앱을 열었을 때 카드로 표시한다.
- 전날 저장된 memory가 없으면 demo morning card 또는 empty state를 표시한다.

### FR-010 — User Confirmation

앱은 reflection 결과를 저장하기 전에 사용자 확인 단계를 제공해야 한다.

Supported actions:

- 남기기
- 수정하기
- 남기지 않기
- 모두 지우기

Acceptance Criteria:

- 앱이 자동으로 기억을 확정 저장하지 않는다.
- 사용자가 최종적으로 남길 기억을 선택한다.
- MVP에서는 원본 전체 저장보다 structured reflection card 저장을 우선한다.

### FR-011 — Reset / Delete UX

앱은 사용자가 현재 session data 또는 demo data를 초기화할 수 있게 해야 한다.

Acceptance Criteria:

- 사용자는 생성된 reflection card를 삭제할 수 있다.
- 사용자는 입력값과 생성 결과를 초기화할 수 있다.
- 삭제 후 dashboard 또는 시작 화면은 안전한 empty state로 돌아간다.

## 4. Non-Functional Requirements

### NFR-001 — Privacy-first by Default

- 권한 요청 없음
- 네트워크 전송 없음
- cloud AI 없음
- 실제 전화·메시지·음성·PPG 데이터 없음
- 원본 저장 최소화
- 사용자 확인 후 memory 저장

### NFR-002 — Local-only Processing

- 외부 API 호출 없음
- deterministic test 가능
- template 기반 응답 생성
- 개인정보 masking은 MVP에서는 안내 중심으로 두고 후속 version에서 rule-based masking 확장

### NFR-003 — Testability

다음 항목은 자동 테스트 가능해야 한다.

- demo event loading
- text input validation
- event parsing
- tone/context scoring
- reflection planning
- template response generation
- daily card generation
- morning card generation
- reset/delete flow
- forbidden copy 검출

### NFR-004 — Maintainability

구현은 feature-first layered architecture를 따른다.

Recommended feature structure:

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

- domain: model, entity, rule result
- data: demo event repository, in-memory reflection repository
- application: reflection engine, planner, service
- presentation: screen, card, input, confirmation UI

### NFR-005 — No Overbuild

MVP는 첫 제품 경험 검증에 집중한다.

MVP에서 금지:

- 복잡한 AI persona system
- 실제 채팅방 UI 전체 구현
- DB schema 도입
- 계정 시스템
- 알림 시스템
- 마이크 또는 파일 import
- chart, sensor, inference dependency 추가

## 5. Privacy & Security Constraints

### Allowed Data

- demo conversation event
- user short text input
- generated reflection card
- generated morning briefing card
- session-only state

### Forbidden Data

- real PPG raw data
- real voice recording
- real call recording
- SMS
- messenger history
- call log
- contacts
- location
- personal profile
- health log
- API key
- access token
- production database

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

앱은 다음 표현을 사용하지 않아야 한다.

```text
우울합니다
불안합니다
위험합니다
치료가 필요합니다
정신건강 문제가 있습니다
상대가 당신을 싫어합니다
건강 상태가 나쁩니다
스트레스 수치가 높습니다
의학적으로 문제가 있습니다
```

### Allowed Copy Style

앱은 다음 수준의 표현만 사용한다.

```text
오늘 기록에는 지친 표현이 보여요.
설명과 조율이 많았던 하루처럼 보여요.
내일 다시 볼 일이 남아 있어요.
이 대화는 오해가 남았을 가능성이 있어요.
오늘은 여기까지 정리해도 괜찮아요.
내일은 한 가지부터 시작해도 좋아요.
```

## 6. Key Entities

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

## 7. Edge Cases

- Empty manual input
- Very short input with no recognizable category
- Input containing forbidden diagnostic words
- Input that appears to include phone number, email, address, or other personal data
- User generates a reflection but chooses not to keep it
- User resets before confirmation
- User opens morning briefing without any confirmed reflection
- Demo event list fails to load
- Generated copy accidentally includes forbidden diagnosis-like phrases

## 8. Assumptions

- MVP 001 uses session-only or volatile local state.
- No local database is introduced in MVP 001.
- No push notification is introduced in MVP 001.
- No cloud AI is used in MVP 001.
- Friend persona is template-based in MVP 001.
- Demo event count starts at five.
- Synthetic PPG Dashboard is not deleted as a long-term concept, but moves to a later technical validation slice.
- Current `001-synthetic-ppg-dashboard` scaffold will be replaced or renamed to `001-daily-reflection-companion-demo` after human approval.

## 9. Out of Scope

- Real phone/message access
- Messenger scraping
- Notification access
- Call recording import
- Voice recording
- PPG capture
- Health Connect integration
- Cloud AI
- Account system
- Local DB
- Medical or mental health diagnosis
- Production analytics
- Sync
- Persona marketplace or romantic persona
- Full chatbot interface
- Real sensor or inference runtime

## 10. Success Criteria

### SC-001 — Product Experience

사용자는 demo event 또는 짧은 직접 입력만으로 하루 마무리 응답, daily reflection card, morning briefing card를 확인할 수 있다.

### SC-002 — Privacy Boundary

앱은 실제 전화, 메시지, 음성, PPG, 건강 로그, 연락처, 위치정보를 사용하지 않고, 민감 권한을 요청하지 않는다.

### SC-003 — Safety Copy

앱은 감정 진단, 정신건강 판단, 의료 조언, 치료 권고, 위험도 확정, 상대방 의도 단정을 하지 않는다.

### SC-004 — Architecture

UI, domain logic, data source, reflection engine이 feature-first layered architecture로 분리되어 있다.

### SC-005 — Test Evidence

아래 quality gate가 통과하고 결과가 evidence log에 기록된다.

```powershell
cd D:\Views\heart_talk
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter build apk --debug
git status -sb
```

## 11. Test Strategy

### Unit Tests

- demo event repository returns at least five safe events
- empty input is rejected
- parser maps known keywords to expected categories
- scorer maps known keywords to expected internal signals
- planner generates expected `dayFlow`, `feelingCue`, `carryOver`, `tomorrowLine`
- generator avoids forbidden diagnostic copy
- morning card is created from confirmed daily card
- reset/delete clears volatile state

### Widget Tests

- privacy notice appears before input
- demo event list is visible
- manual text input validates empty text
- reflection preview appears after demo/manual input
- user confirmation actions are available
- daily reflection card fields are visible
- morning briefing empty state appears when no confirmed card exists
- reset/delete returns to safe empty state

### Privacy/Security Review

- no Android/iOS sensitive permissions added
- no network/analytics/sync dependency added
- no real PPG/voice/user data fixture added
- no API keys, signing keys, or production DB artifacts added

## 12. Review Checklist

- [ ] Feature ID is `001-daily-reflection-companion-demo`
- [ ] `Synthetic PPG Heart Rate Dashboard` is moved to later technical validation
- [ ] No real PPG, voice, phone, SMS, contact, location, health log, or messenger data
- [ ] No sensitive permissions
- [ ] No cloud AI or network transfer
- [ ] No medical/mental-health diagnosis copy
- [ ] Feature-first layered architecture is preserved
- [ ] MVP remains a small vertical slice
- [ ] Quality gate commands are defined

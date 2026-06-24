# Technical Plan: Daily Reflection Companion Demo

**Feature**: `001-daily-reflection-companion-demo`
**Spec**: `specs\001-daily-reflection-companion-demo\spec.md`
**Status**: Draft
**Target App**: `D:\Views\heart_talk`

## 1. Objective

Implement the smallest verifiable Flutter vertical slice for HeartTalk 001:

```text
privacy notice
→ demo event or manual text input
→ local rule-based reflection
→ daily reflection card
→ user confirmation
→ morning briefing card
→ reset/delete
```

## 2. Constitution Alignment

- Privacy-first by default
- Synthetic/demo input only
- No phone/SMS/messenger/voice/PPG/health/contact/location data
- No sensitive permissions
- No cloud AI, network, sync, analytics
- No diagnosis, treatment, disease prediction, or risk classification
- Evidence-gated completion
- Small vertical slice
- Feature-first layered architecture

## 3. Scope

### In Scope

- `features/daily_reflection` feature module
- demo conversation event fixture/repository
- manual text validation
- local deterministic rule/template engine
- daily card and morning card models
- simple Flutter UI for single vertical flow
- reset/delete volatile state
- unit/widget tests
- safety copy tests

### Out of Scope

- local DB
- push notification
- account/login
- network/API
- cloud AI
- microphone/audio import
- phone/SMS/contact/call log access
- PPG/sensor capture
- inference runtime
- full chat UI
- persona marketplace

## 4. Proposed Flutter Structure

```text
lib/
  features/
    daily_reflection/
      domain/
        demo_conversation_event.dart
        reflection_input.dart
        parsed_reflection_event.dart
        reflection_signal.dart
        daily_reflection_card.dart
        morning_briefing_card.dart
        reflection_engine.dart
      data/
        demo_conversation_repository.dart
        in_memory_reflection_repository.dart
      application/
        rule_based_reflection_engine.dart
        reflection_service.dart
      presentation/
        daily_reflection_screen.dart
        widgets/
          privacy_notice_card.dart
          demo_event_picker.dart
          reflection_input_box.dart
          reflection_response_card.dart
          daily_reflection_card_view.dart
          morning_briefing_card_view.dart
test/
  features/
    daily_reflection/
      domain/
      data/
      application/
      presentation/
```

## 5. Data Flow

```text
DemoConversationEvent or manual text
→ ReflectionInput
→ ReflectionEngine.parse()
→ ParsedReflectionEvent
→ ReflectionService.plan()
→ friendResponse + DailyReflectionCard
→ User confirmation
→ InMemoryReflectionRepository
→ MorningBriefingCard
```

## 6. Interfaces

### ReflectionEngine

```dart
abstract class ReflectionEngine {
  ReflectionResult generate(ReflectionInput input);
}
```

### DemoConversationRepository

```dart
abstract class DemoConversationRepository {
  List<DemoConversationEvent> listDemoEvents();
}
```

### ReflectionRepository

```dart
abstract class ReflectionRepository {
  DailyReflectionCard? getConfirmedDailyCard();
  void saveConfirmedDailyCard(DailyReflectionCard card);
  void clear();
}
```

## 7. Implementation Constraints

- No new dependency unless explicitly approved.
- Prefer Flutter SDK and Dart standard library only.
- Do not add Android/iOS permissions.
- Do not add network client code.
- Do not add local DB.
- Do not store raw manual input after confirmation unless explicitly required by spec.
- Do not use forbidden diagnosis-like phrases.
- Keep generated text deterministic for tests.

## 8. Quality Gates

```powershell
cd D:\Views\heart_talk
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter build apk --debug
git status -sb
```

## 9. Risks

| Risk | Mitigation |
|---|---|
| Manual text may contain personal data | MVP shows notice; no cloud/network; session-only state |
| Copy may sound diagnostic | forbidden phrase tests |
| Scope creep into chatbot | keep single vertical flow |
| Premature storage | use in-memory repository only |
| Existing synthetic PPG scaffold mismatch | backup/rename before implementation |

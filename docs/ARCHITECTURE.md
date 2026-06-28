# HeartTalk Architecture

## Architecture Style

HeartTalk uses feature-first layered architecture. Feature code should live under `lib/features/<feature_name>/` and be split by responsibility.

Recommended shape:

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

Current implemented shape:

```text
lib/
  main.dart
  features/
    daily_reflection/
      application/
      data/
      domain/
      presentation/
```

## Layer Responsibilities

| Layer | Responsibility |
|---|---|
| presentation | Flutter screens, widgets, UI state, user interactions |
| application | Use-case orchestration, deterministic workflow coordination |
| domain | Models, enums, rules, contracts, non-Flutter business behavior |
| data | Demo repositories, in-memory repositories, fixture-safe data sources |
| infrastructure | Future adapters for sensors, storage, model runtimes, platform APIs |

## Current MVP Flow

```text
Demo event or manual text
-> local validation/privacy boundary
-> rule-based reflection engine
-> daily reflection card
-> user confirmation
-> morning briefing card
-> reset/delete
```

## Dependency Direction

- Presentation may depend on application/domain.
- Application may depend on domain and repository contracts.
- Data implements contracts and supplies safe demo/in-memory data.
- Domain must not import Flutter widgets or platform APIs.
- Infrastructure/adapters must remain behind interfaces.

## Future Adapter Boundaries

Future real-data features require explicit specs and approval before implementation. Use adapter boundaries such as:

- `PpgCaptureAdapter`
- `VoiceCaptureAdapter`
- `InferenceAdapter`
- `SecureLocalStorageAdapter`

No real PPG, real voice, health logs, native permissions, or model/runtime dependencies should be added during MVP operations.

## Testing Shape

Tests should mirror feature structure where practical:

```text
test/
  features/
    daily_reflection/
      application/
      data/
      domain/
      presentation/
```

Every meaningful app change must include deterministic tests or an explicit explanation why tests are not applicable.

## HT-COMPANION-001 Architecture Update

Local memory is implemented inside `lib/features/daily_reflection` using the existing feature-first layering:

- `domain/companion_models.dart`: consent, role, preference, and growth state models.
- `domain/local_memory_models.dart`: local profile, reflection entry, memory item, person memory, todo memory, and snapshot models.
- `application/growth_calculator.dart`: deterministic level 0-5 calculation.
- `application/companion_message_service.dart`: Korean role + growth companion copy.
- `data/local_memory_repository.dart`: repository contract, in-memory implementation, and consent sanitizer.
- `data/shared_preferences_memory_repository.dart`: local JSON snapshot adapter backed by `shared_preferences`.
- `presentation/daily_reflection_screen.dart`: consent, role selection, memory entry, `내 기억`, reset, and restart restore UI.

The dependency direction remains presentation -> application/data/domain. Domain models do not import Flutter widgets or platform APIs.

## HT-DESIGN-ALIGN-001 Architecture Note

`Design.md` does not change the current app architecture. HeartTalk remains a Flutter app using feature-first layered architecture under `lib/features/daily_reflection`.

Design-system work, if approved later, should be added without collapsing domain/application/data boundaries into presentation code. Recommended future UI work should introduce small reusable widgets or theme tokens only after a HeartTalk-specific design QA milestone defines the intended visual hierarchy, Korean copy standards, and safety copy constraints.

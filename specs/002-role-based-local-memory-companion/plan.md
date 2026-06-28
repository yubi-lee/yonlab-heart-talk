# Technical Plan: Role-Based Local Memory Companion

**Feature ID**: `HT-COMPANION-001`
**Spec**: `specs/002-role-based-local-memory-companion/spec.md`

## Architecture

Keep the existing feature-first structure under `lib/features/daily_reflection` and add small model/service/repository files:

```text
lib/features/daily_reflection/
  domain/
    companion_models.dart
    local_memory_models.dart
  application/
    growth_calculator.dart
    companion_message_service.dart
  data/
    local_memory_repository.dart
    shared_preferences_memory_repository.dart
  presentation/
    daily_reflection_screen.dart
```

## Data Flow

```text
User toggles consent
-> selects role and enters approved memory
-> LocalMemorySnapshot
-> consent sanitizer
-> shared_preferences JSON string
-> app restart loads snapshot
-> GrowthCalculator computes deterministic level
-> CompanionMessageService generates Korean role + growth message
-> user can inspect `내 기억` or clear all memory
```

## Dependency Decision

Use `shared_preferences` because the feature needs minimal local key-value persistence and no database, account, network, or sensitive permission path. The dependency is intentionally limited to one JSON snapshot key.

## Verification

```powershell
cd D:\Views\heart_talk
flutter test
powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1
```

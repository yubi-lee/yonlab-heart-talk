# Feature Specification: Role-Based Local Memory Companion

**Feature ID**: `HT-COMPANION-001`
**Feature Directory**: `specs/002-role-based-local-memory-companion`
**Created**: 2026-06-28
**Status**: Implemented local vertical slice

## Summary

Extend the Daily Reflection Companion Demo into a local-only companion that can remember user-approved information on the device. The feature adds explicit local memory consent, role-based Korean companion tone, deterministic growth state, a user-visible memory area, and full local memory reset.

This feature remains non-diagnostic and local-only. It does not add cloud AI, network transfer, analytics, sync, accounts, sensitive Android/iOS permissions, medical claims, therapy claims, or OS data collection.

## User Stories

### US-001: Choose Local Memory Consent

As a privacy-conscious user, I can turn local memory on or off before saving profile, relationship, todo, reflection, or recurring keyword memory.

Acceptance criteria:

- Local memory defaults to off.
- If local memory is off, profile and memory details are not persisted.
- If local memory is on, only approved local categories are persisted.
- The UI explains that stored information remains on the device.

### US-002: Choose Companion Role

As a user, I can choose a companion role so the app responds in a familiar style.

Required roles:

- Friend / 친구
- Lover / 연인
- Family / 가족
- Parent / 부모
- Coach / 코치
- Teacher / 선생님
- Listener / 경청자
- Custom / 사용자 지정

Acceptance criteria:

- The role list is visible in the app.
- The selected role is persisted when local memory consent is enabled.
- Role-specific Korean messages remain supportive and non-diagnostic.

### US-003: Save and View Approved Memory

As a user, I can enter profile, person, and todo information and see what has been stored.

Acceptance criteria:

- The app has a visible `내 기억` area.
- Stored profile, person, todo, entry count, role, and growth level are visible in-app.
- App restart restores approved local memory.
- Full reset removes approved local memory.

### US-004: Grow Deterministically

As a user, I can see the companion become more familiar as approved local memory accumulates.

Acceptance criteria:

- Growth level is deterministic and testable.
- Level is 0 when local memory consent is off.
- Growth inputs include memoryScore, daysWithEntries, profileCompleteness, recurringKeywordCount, relationshipMemoryCount, and todoMemoryCount.
- Growth copy does not imply medical, mental-health, risk, or personality diagnosis.

## Functional Requirements

- Add `ConsentSettings` with local memory enabled state and category permissions.
- Add `CompanionRole` and `CompanionPreference` models.
- Add `LocalUserProfile`, `DailyReflectionEntry`, `MemoryItem`, `PersonMemory`, `TodoMemory`, and `LocalMemorySnapshot`.
- Add `GrowthCalculator` for deterministic level 0-5 calculation.
- Add `CompanionMessageService` for role + growth Korean companion messages.
- Add local memory repository contracts and implementations.
- Add `shared_preferences` as the minimal local key-value storage dependency.
- Store local memory only when consent allows it.
- Expose all stored information in-app.
- Provide full local memory reset.

## Privacy and Security Requirements

- No server transfer.
- No cloud AI.
- No analytics, telemetry, sync, account, or remote database path.
- No Android/iOS permission changes.
- No raw user content in `print` or `debugPrint` logs.
- Store only user-entered and user-approved local data.
- Make stored categories understandable in UI/docs.
- Full reset must remove persisted local memory.

## Test Requirements

- Consent OFF prevents persistence.
- Consent ON persists and restores approved memory.
- Full reset clears persisted memory.
- Role labels include the required Korean names.
- Companion preference JSON round trips.
- Local memory snapshot JSON round trips through `shared_preferences`.
- Growth calculation is deterministic.
- Role + growth messages differ by role and avoid diagnostic copy.
- Widget tests cover consent, role selection, memory entry, restart restore, and reset.

## Out of Scope

- Cloud AI or remote model calls.
- Chatbot marketplace or complex persona system.
- Native permission changes.
- Real PPG, voice, contacts, SMS, call log, notifications, location, or health data.
- Medical, psychological, emergency, risk, or treatment guidance.
- Encrypted storage, export/import, account sync, or backup.

## Design.md Alignment Notes

`Design.md` is a late-stage design input for this feature, but its current wording targets a Goorm-style Korean B2B AI operations dashboard. That framing conflicts with HeartTalk's current product category: a privacy-first daily reflection companion.

For `HT-COMPANION-001`, use only the transferable design qualities from `Design.md`:

- calm, trustworthy product tone
- technically restrained UI and copy
- Korean-language polish
- clear enterprise-grade privacy/security communication
- no direct copying of Toss or any other reference product

Do not use `Design.md` as permission to turn HeartTalk into a B2B operations dashboard, add analytics/sync/account features, or introduce network/cloud AI.

## Role Safety Requirements

Companion roles are tone/persona preferences only. They must not claim to replace real friends, partners, family members, parents, teachers, coaches, clinicians, or emergency support.

Additional role constraints:

- Lover role must avoid dependency-inducing, obsessive, sexual, possessive, controlling, shaming, or blaming language.
- Parent role must avoid infantilizing, controlling, guilt-inducing, shaming, or blaming language.
- Coach and teacher roles must keep suggestions practical and non-diagnostic.
- Listener role must remain reflective and must not imply therapy or clinical assessment.
- Custom role hints must still obey all privacy, non-diagnostic, and non-coercive copy rules.

## Design Gap Follow-up

The implemented feature is functionally aligned with local memory, roles, deterministic growth, restore, reset, and in-app memory visibility. It is not yet aligned with a formal HeartTalk design system because the current `Design.md` is not HeartTalk-specific.

Recommended follow-up milestone: `HT-DESIGN-QA-001` to translate the design direction into HeartTalk-specific Android manual QA criteria before any large UI redesign.

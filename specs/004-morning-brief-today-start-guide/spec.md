# Feature Specification: Morning Brief / Today Start Guide

**Feature ID**: `HT-MORNING-001`
**Feature Directory**: `specs/004-morning-brief-today-start-guide`
**Created**: 2026-06-29
**Status**: Implemented local vertical slice

## Summary

Add a deterministic local morning brief that uses approved local memory, growth state, role preference, and the current local insight to help the user start the day with a short Korean guide. The feature shows `오늘 시작하기` in the existing Daily Reflection screen and remains local-only.

The feature does not add Cloud AI, LLM APIs, network calls, analytics, sync, accounts, notification permissions, background scheduling, platform configuration changes, or new dependencies.

## User Stories

### US-001: See a Morning Brief After Saving Local Memory

As a user who has enabled local memory and saved reflection context or a next action, I can reopen the app and see a short local morning brief that helps me start the day.

Acceptance criteria:

- The app shows `오늘 시작하기`.
- The card can include an opening line, carry-over line, morning question, first step, and role-aware encouragement.
- The generation is deterministic and testable.

### US-002: Receive a Fallback When Data Is Sparse

As a new or privacy-conscious user, I can still see a gentle fallback morning brief when local memory is off or there is not enough approved data.

Acceptance criteria:

- Consent OFF does not produce personalized morning brief copy.
- Empty snapshot produces a fallback morning brief without null errors.
- Full reset returns the morning brief to fallback state.

### US-003: Get a Role-Aware Morning Start

As a user with a selected companion role, I can receive a morning encouragement line that matches the companion tone without implying a real relationship replacement.

Acceptance criteria:

- Friend, coach, and listener morning messages differ.
- Lover role avoids obsession, sexual language, possession, and dependency-inducing copy.
- Parent role avoids control, blame, shame, and guilt pressure.
- Custom role uses the selected custom name/tone boundary without bypassing safety rules.

## Functional Requirements

- Add `MorningBrief`, `MorningQuestion`, and `FirstStepSuggestion` models.
- Add `MorningBriefService` in the application layer.
- Generate morning brief from `LocalMemorySnapshot`, `LocalInsightSummary`, `CompanionPreference`, and `CompanionGrowthState`.
- Use fallback morning brief for consent OFF, empty snapshot, and reset state.
- Prefer an active saved todo for the first step when one exists.
- Fall back to the current tiny mission when no saved todo exists.
- Use recent reflection context for a carry-over line without replaying raw personal text history.
- Display the morning brief in the existing single-screen UI with minimal layout change.
- Keep the existing session-only `Keep for morning -> 내일 시작 메모` flow separate from the persistent local-memory-based morning brief.

## Safety Requirements

- No medical diagnosis, treatment, emergency guidance, risk scoring, clinical prediction, or mental-health classification.
- Use possibility, hint, and small-start language rather than certainty language.
- Do not evaluate, shame, blame, label, or rank the user.
- Do not print, debugPrint, or log raw personal input.
- Do not claim storage is perfectly safe or impossible to breach.
- Do not request or imply access to calls, SMS, messengers, contacts, calendar, location, voice, PPG, health data, notifications, accounts, analytics, sync, network, or Cloud AI.

## Test Requirements

- Empty snapshot creates fallback morning brief.
- Consent OFF prevents personalized morning brief.
- Consent ON with todo memory creates a todo-based first step.
- Insight tiny mission can become the first step when todo memory is missing.
- Recent reflection context creates a carry-over line.
- Friend, coach, and listener role messages differ.
- Lover and parent role messages avoid unsafe wording.
- UI displays `오늘 시작하기` in both fallback and personalized states.
- Existing restore/reset/local insight/session-only morning-note tests continue to pass.

## Out of Scope

- Cloud AI, LLM API, network calls, remote inference, analytics, telemetry, sync, account systems, notifications, background scheduling, new permissions, platform configuration changes, encrypted storage migration, export/import, app-wide redesign, medical/psychological diagnosis, treatment, emergency guidance, and crisis support.

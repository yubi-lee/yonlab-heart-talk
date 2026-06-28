# Feature Specification: Local Insight & Prediction Engine

**Feature ID**: `HT-INSIGHT-001`
**Feature Directory**: `specs/003-local-insight-prediction-engine`
**Created**: 2026-06-29
**Status**: Implemented local vertical slice

## Summary

Add a deterministic local insight engine that reads the consent-filtered `LocalMemorySnapshot` and shows a small Korean insight card in the Daily Reflection UI. The engine turns approved local memory into a gentle pattern line, recurring signals, a tomorrow hint, a curiosity question, a tiny mission, and a role-aware companion message.

The feature is local-only. It does not add Cloud AI, LLM API calls, network calls, analytics, sync, accounts, notifications, native permissions, platform configuration, or new dependencies.

## User Stories

### US-001: See a Local Insight

As a user who has enabled local memory and saved daily reflection context, I can see a small insight that summarizes recurring signals from my approved local memory.

Acceptance criteria:

- The app shows `오늘의 인사이트` in the existing daily reflection screen.
- The insight is calculated from `LocalMemorySnapshot`, `CompanionPreference`, and `CompanionGrowthState`.
- The calculation is deterministic and testable.

### US-002: Receive a Fallback When Data Is Sparse

As a new or privacy-conscious user, I can still see a gentle fallback message when local memory is off or there is not enough approved data.

Acceptance criteria:

- Consent OFF does not produce personalized insight.
- Empty snapshot produces a fallback insight without null errors.
- Full reset returns the insight to fallback state.

### US-003: Get a Role-Aware Guide

As a user with a selected companion role, I can receive a guide line that matches the companion tone without implying a real relationship replacement.

Acceptance criteria:

- Friend, coach, and listener messages differ.
- Lover role avoids obsession, sexual language, possession, and dependency-inducing copy.
- Parent role avoids control, blame, shame, and guilt pressure.
- Custom role uses the selected custom name/tone boundary without bypassing safety rules.

## Functional Requirements

- Add `LocalInsightSummary`, `RecurringSignal`, `TomorrowHint`, `CuriosityQuestion`, `TinyMission`, and `DataDepthLabel` models.
- Add `LocalInsightService` in the application layer.
- Generate insight from approved local data only when local memory consent is enabled.
- Use fallback insight for consent OFF, empty snapshots, and reset state.
- Derive recurring signals from reflection tags, recurring keywords, todo presence, and relationship memory presence.
- Merge repeated labels deterministically and sort by count descending then label ascending.
- Keep relationship signals category-level; do not echo raw relationship notes in curiosity questions.
- Display the insight in the existing single-screen UI with minimal layout change.

## Safety Requirements

- No medical diagnosis, treatment, emergency guidance, risk scoring, clinical prediction, or mental-health classification.
- Use possibility and hint language, not certainty language.
- Do not evaluate, shame, blame, label, or rank the user.
- Do not print, debugPrint, or log raw personal input.
- Do not claim storage is perfectly safe or impossible to breach.
- Do not request or imply access to calls, SMS, messengers, contacts, calendar, location, voice, PPG, health data, notifications, accounts, analytics, sync, network, or Cloud AI.

## Test Requirements

- Empty snapshot creates fallback insight.
- Consent OFF prevents personalized insight.
- Consent ON with reflection entries creates pattern insight.
- Todo memory affects tomorrow hint or tiny mission.
- Person memory affects relationship wording without overexposing raw relationship text.
- Friend, coach, and listener role messages differ.
- Lover and parent role messages avoid unsafe wording.
- Higher data depth changes `DataDepthLabel` and produces more personalized-but-safe copy.
- UI displays `오늘의 인사이트` and a todo-based tiny mission.

## Out of Scope

- Cloud AI, LLM API, network calls, remote inference, analytics, telemetry, sync, account systems, notifications, new permissions, platform configuration changes, encrypted storage migration, export/import, app-wide redesign, medical/psychological diagnosis, treatment, emergency guidance, and crisis support.
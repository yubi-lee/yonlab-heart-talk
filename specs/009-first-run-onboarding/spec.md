# Feature Specification: First-run Onboarding for Local Memory Companion

**Feature ID**: `HT-ONBOARDING-001`
**Feature Directory**: `specs/009-first-run-onboarding`
**Created**: 2026-07-01
**Status**: Implemented local vertical slice

## Summary

Add a short first-run onboarding to HeartTalk so new users can quickly understand the product: it is a day companion, approved memory is stored only on-device, roles change the tone, local memory powers `오늘의 인사이트` and `오늘 시작하기`, `100일 성장 체험` is synthetic demo data, and saved memory can be deleted at any time.

The onboarding is local-only, Korean-first, and uses the existing single-screen flow. It does not add Cloud AI, network calls, accounts, analytics, background work, or new dependencies.

## User Stories

### US-001: Understand HeartTalk On First Launch

As a first-time user, I can see a short onboarding that explains what HeartTalk does before I start using the main screen.

Acceptance criteria:
- The app shows a short onboarding card or compact guide on a clean launch.
- The copy says HeartTalk is a `나를 기억하는 하루 친구`.
- The copy explains that approved memory is stored only on the device.
- The copy explains that the companion role can be changed.

### US-002: Continue Into The Main Flow

As a user who has read the guide, I can close it and continue to the existing Daily Reflection screen.

Acceptance criteria:
- `시작하기` or `이해했어요` closes the onboarding.
- The main companion flow becomes visible after dismissal.
- The onboarding completion state is persisted locally.
- `도움말 다시 보기` can reopen the onboarding guide.

### US-003: Understand The Demo And Deletion Policy

As a privacy-conscious user, I can tell that the 100-day growth demo is synthetic and that saved memory can be removed later.

Acceptance criteria:
- The copy says `100일 성장 체험` uses synthetic demo data.
- The copy says saved memory can be deleted at any time.
- The onboarding does not imply Cloud AI, network, or account-based behavior.

## Functional Requirements

- Store onboarding completion with the existing local persistence layer and no new dependency.
- Load onboarding completion before deciding whether to show the guide.
- Render the onboarding as a compact card or guide in the existing single-screen UI.
- Provide a simple reopen action for help or guidance.
- Keep the main Daily Reflection flow unchanged after dismissal.

## Safety Requirements

- No medical diagnosis, treatment, risk scoring, mental-health classification, or certainty language.
- No claims that the app is perfectly safe or impossible to breach.
- No raw personal input logging.
- No request or implication of calls, SMS, messengers, contacts, location, voice, health data, notifications, network, Cloud AI, accounts, or sync.
- Use Korean-first copy.

## Test Requirements

- Clean launch shows the onboarding.
- Dismissal hides the onboarding and reveals the main screen.
- The onboarding completion state persists across restart.
- `도움말 다시 보기` reopens the onboarding guide.
- Existing local memory, insight, morning brief, simulation, and memory-management widget tests continue to pass.

## Out of Scope

- Cloud AI, LLM API, network calls, sync, accounts, notifications, background scheduling, new permissions, platform configuration changes, analytics, crash reporting, app-wide redesign, or storage schema changes.

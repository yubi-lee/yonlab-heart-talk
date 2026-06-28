# HeartTalk Goal

## Current Goal

HeartTalk is a privacy-first Flutter mobile app that explores gentle, non-diagnostic daily reflection experiences. The current development goal is to keep the existing `Daily Reflection Companion Demo` MVP stable while using a YOnLab ChatGPT x Codex style workflow: spec-first, evidence-gated, and delivered through small scoped vertical slices.

## MVP Scope

MVP 001 is the `Daily Reflection Companion Demo`.

In scope:

- Safe demo conversation events
- Short manual text entry by the user
- Local deterministic rule/template reflection generation
- Daily reflection card
- Morning briefing card
- User confirmation, reset, and delete flows
- Unit/widget tests for the implemented vertical slice
- Evidence logs that record command output

Out of scope:

- Real PPG capture or PPG files
- Real voice recording, transcript import, or audio processing
- Phone, SMS, messenger, contact, location, notification, or health-data access
- Cloud AI, analytics, sync, account systems, or network transfer
- Local database or durable storage beyond explicitly approved future specs
- Medical diagnosis, treatment advice, disease prediction, or risk scoring

## Source of Truth

When docs conflict, use this priority:

1. `specs/001-daily-reflection-companion-demo/spec.md`
2. `specs/001-daily-reflection-companion-demo/plan.md`
3. `specs/001-daily-reflection-companion-demo/tasks.md`
4. `AGENTS.md`
5. Summary docs under `docs/`

## Development Principle

Completion is not based on "AI says done." Completion requires command output evidence from the repository, especially format, analyze, test, and git status results.

## HT-COMPANION-001 - Role-Based Local Memory Companion

Approved on 2026-06-28 as a follow-up slice to MVP 001. The app may now store user-approved local memory on the device when explicit local memory consent is enabled.

Scope added:

- Local memory consent defaults to off.
- Companion roles: 친구, 연인, 가족, 부모, 코치, 선생님, 경청자, 사용자 지정.
- User-visible `내 기억` area for profile, role, entries, relationship memory, todo memory, and growth level.
- Deterministic growth level 0-5 based only on approved local memory volume.
- Full local memory reset.

Still out of scope: server transfer, cloud AI, analytics, sync, accounts, sensitive OS permissions, real PPG/voice/phone/contact/location/health data, and diagnostic or treatment copy.

## HT-DESIGN-ALIGN-001 - Design.md Alignment

`Design.md` is now tracked as a late-stage design input for HeartTalk, with an important limitation: its current text describes a Goorm-style Korean B2B AI operations dashboard, while HeartTalk is a privacy-first daily reflection companion. HeartTalk should carry forward transferable design qualities from `Design.md` such as calmness, trustworthiness, technical restraint, Korean product polish, and enterprise-grade clarity, but it should not pivot into a B2B operations dashboard without a separate product decision.

The detailed gap matrix and milestone recommendation are recorded in `docs/DESIGN_ALIGNMENT.md`.

For future work, use `Design.md` as a UX-quality input together with the HeartTalk product/spec/privacy constraints. The recommended next milestone is `HT-DESIGN-QA-001`, which should translate the design direction into HeartTalk-specific Android manual QA criteria before any large UI redesign.

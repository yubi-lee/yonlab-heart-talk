# HeartTalk Goal

## Current Goal

HeartTalk is a privacy-first Flutter mobile app that explores gentle, non-diagnostic daily reflection and local-companion experiences. The current development goal is to keep the current HeartTalk MVP stable and release-candidate ready with a spec-first, evidence-gated workflow.

## Current MVP Scope

The current MVP includes:

- first-run onboarding
- local memory consent and role selection
- role-aware companion tone
- today record
- local memory management
- local insight
- morning brief
- 100-day synthetic growth simulation
- session flow polish
- full reset/delete

In scope:

- safe demo and synthetic inputs
- short manual text entry by the user
- local deterministic generation
- user-approved local memory storage on device
- unit/widget tests for the implemented slices
- evidence logs that record command output

Out of scope:

- real PPG capture or PPG files
- real voice recording, transcript import, or audio processing
- phone, SMS, messenger, contact, location, notification, or health-data access
- Cloud AI, analytics, sync, account systems, or network transfer
- local database or durable storage beyond explicitly approved future specs
- medical diagnosis, treatment advice, disease prediction, or risk scoring

## Source of Truth

When docs conflict, use this priority:

1. `specs/009-first-run-onboarding/spec.md`
2. `specs/007-session-flow-polish/HT-100DAY-SIM-001-spec.md`
3. `specs/007-session-flow-polish/spec.md`
4. `specs/006-role-ux-polish/spec.md`
5. `specs/005-local-memory-management/spec.md`
6. `specs/004-morning-brief-today-start-guide/spec.md`
7. `specs/003-local-insight-prediction-engine/spec.md`
8. `specs/002-role-based-local-memory-companion/spec.md`
9. `specs/001-daily-reflection-companion-demo/spec.md`
10. `AGENTS.md`
11. Summary docs under `docs/`

## Development Principle

Completion is not based on "AI says done." Completion requires command output evidence from the repository, especially format, analyze, test, build, and git status results.

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

## HT-RELEASE-CANDIDATE-001 - Release Candidate Readiness

The current release-candidate review is documented in `docs/releases/HT-MVP-RC1.md`. The review summarizes the current MVP scope, acceptance status, physical Android QA evidence, and the remaining non-blocking risks that should be carried into rc tagging.

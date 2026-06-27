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

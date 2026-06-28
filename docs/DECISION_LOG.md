# HeartTalk Decision Log

This file summarizes workflow-level decisions for the current repository. The historical root-level `DECISION_LOG.md` remains preserved; do not delete it. When decisions conflict, prefer accepted decisions in the most specific current spec or ADR.

| ID | Date | Decision | Rationale | Status |
|---|---|---|---|---|
| DEC-001 | 2026-06-22 | Use Windows PowerShell Native as the standard execution shell. | Matches the local development environment and avoids cross-shell ambiguity. | Accepted |
| DEC-002 | 2026-06-22 | Use `D:\Views\heart_talk` as the project root. | Keeps all Codex and manual commands consistent. | Accepted |
| DEC-003 | 2026-06-22 | Use Flutter for the mobile app. | Supports Android-first MVP and later iOS expansion. | Accepted |
| DEC-004 | 2026-06-22 | Use Spec Kit/spec-first development. | Keeps product scope, acceptance criteria, and evidence connected. | Accepted |
| DEC-005 | 2026-06-22 | Use ChatGPT for planning/review and Codex for local repo implementation. | Separates product thinking from local execution and verification. | Accepted |
| DEC-006 | 2026-06-22 | Make `Daily Reflection Companion Demo` the first product MVP. | Reduces privacy and permission risk while validating the user experience. | Accepted |
| DEC-007 | 2026-06-22 | Keep synthetic PPG work as a later technical validation slice. | PPG remains long-term direction but is not required for the first product experience. | Accepted |
| DEC-008 | 2026-06-28 | Use evidence-gated completion as the operating standard. | Command output is auditable; AI completion claims are not sufficient. | Accepted |
| DEC-009 | 2026-06-28 | Add project-level docs and PowerShell scripts without changing app code. | Aligns the repository with the YOnLab ChatGPT x Codex workflow while preserving the existing Flutter MVP. | Accepted |
| DEC-010 | 2026-06-28 | Keep Daily Reflection MVP persistence session-only and in-memory. | The MVP validates the reflection flow without durable storage, raw input retention, database schema, account state, or privacy review overhead. Durable local storage must be handled as a future approved slice. | Accepted |
| DEC-011 | 2026-06-28 | Separate Android debug APK build evidence from Android manual QA pass evidence. | A successful APK build proves the Android artifact builds, but manual QA requires launching the app on an Android emulator or physical device and completing the checklist. | Accepted |
| DEC-012 | 2026-06-28 | Treat Daily Reflection MVP privacy/security as local-only, demo/manual-input, and session-only. | The implemented MVP has no real PPG, real voice, sensitive permissions, network/cloud AI, analytics, sync, durable DB, or secrets path. Any future expansion into those areas requires separate privacy/security review. | Accepted |

## New Decision Template

| ID | Date | Decision | Alternatives | Rationale | Impact | Status |
|---|---|---|---|---|---|---|
| DEC-XXX | YYYY-MM-DD |  |  |  |  | Proposed |

| DEC-013 | 2026-06-28 | Add `shared_preferences` for HT-COMPANION-001 local memory. | Alternatives: session-only state, custom file storage, local database. | `shared_preferences` is the smallest approved dependency for local key-value persistence, avoids database/account/network scope, and supports testable restart restore through one JSON snapshot key. | Adds generated plugin registration and pubspec/lock changes; no Android/iOS permission changes. | Accepted |

| DEC-014 | 2026-06-28 | Treat `Design.md` as a limited design-input document for HeartTalk until it is rewritten as a HeartTalk-specific design brief. | Alternatives: make Design.md fully authoritative, ignore Design.md, or rewrite it immediately. | Current Design.md names a Korean B2B AI operations dashboard, which conflicts with HeartTalk's privacy-first daily reflection companion direction. Its transferable qualities are calmness, trustworthiness, technical restraint, and Korean product polish. | Future UI work should first run `HT-DESIGN-QA-001`; Design.md does not authorize a product pivot or code changes by itself. | Accepted |

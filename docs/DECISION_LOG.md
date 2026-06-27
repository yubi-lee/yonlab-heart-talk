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

## New Decision Template

| ID | Date | Decision | Alternatives | Rationale | Impact | Status |
|---|---|---|---|---|---|---|
| DEC-XXX | YYYY-MM-DD |  |  |  |  | Proposed |

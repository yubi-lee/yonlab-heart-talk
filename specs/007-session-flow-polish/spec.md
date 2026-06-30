# Feature Specification: Simplify Daily Companion Session Flow

**Feature ID**: `HT-SESSION-FLOW-001`
**Feature Directory**: `specs/007-session-flow-polish`
**Created**: 2026-06-30
**Status**: Implemented local presentation slice

## Summary

Reorganize the existing single-screen HeartTalk MVP so the accumulated companion features read as one understandable daily session flow. This slice does not add new product capability. It only changes section order, grouping, headings, helper copy, and density inside the existing Flutter screen.

The feature remains local-only and does not add dependencies, navigation structures, new permissions, network calls, Cloud AI, analytics, sync, or storage-schema changes.

## User Stories

### US-001: Understand What Comes First

As a user opening HeartTalk, I can quickly see the current companion state and whether local memory is on before I start entering today's information.

Acceptance criteria:

- A visible current-state section appears before entry and management sections.
- Local-memory consent appears before today-entry inputs.
- The current role and growth/familiarity state are visible near the top.

### US-002: Follow a Natural Daily Flow

As a user leaving a daily note, I can move through a clear order from recording today, to seeing insight, to seeing a morning start guide.

Acceptance criteria:

- `오늘 기록하기` appears before `오늘의 인사이트`.
- `오늘의 인사이트` appears before `오늘 시작하기`.
- The existing reflection preview / keep / reset behavior still works.

### US-003: Reach Memory Management Without Screen Overload

As a user who wants to review stored memory, I can still access memory management while the main screen feels less dense.

Acceptance criteria:

- `내 기억 관리` appears after insight and morning guidance.
- Stored category details can live behind an explicit expand/collapse control.
- `전체 초기화` remains visible and reachable without mixing it into the main entry flow.

## Functional Requirements

- Reorder the current single-screen presentation to follow:
  - current companion state
  - local memory consent / role selection
  - today record entry
  - local insight
  - morning brief
  - memory management
  - full reset
- Keep all existing keys and interaction paths needed by widget tests unless the test update is part of this task.
- Preserve local-memory save/restore, insight generation, morning-brief generation, edit/delete behavior, and session-only preview logic.
- Keep `내 기억 관리` lower priority through an expandable section or equivalent collapsed presentation.
- Keep Korean user-facing labels short and readable on Android-sized screens.

## Safety Requirements

- Do not change application/domain/data logic.
- Do not change local-memory schema, storage keys, or repository behavior.
- Do not add network, Cloud AI, analytics, sync, accounts, or new permissions.
- Do not introduce medical, diagnostic, treatment, or risk-scoring copy.
- Do not reduce access to reset, consent, or stored-information visibility.

## Test Requirements

- Widget tests confirm the major section headings are visible.
- Widget tests confirm `오늘의 인사이트` appears before `오늘 시작하기`.
- Widget tests confirm `내 기억 관리` is presented as a lower-priority expandable area.
- Existing save/restore, insight, morning brief, and memory-management widget behaviors continue to pass.

## Out of Scope

- New features
- Service/model/repository changes
- New routes, tabs, or bottom navigation
- New dependencies
- Platform configuration changes
- Animation or visual-system redesign

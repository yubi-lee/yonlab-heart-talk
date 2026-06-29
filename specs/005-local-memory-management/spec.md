# Feature Specification: Local Memory View/Edit/Delete Management

**Feature ID**: `HT-MEMORY-MANAGE-001`  
**Feature Directory**: `specs/005-local-memory-management`  
**Created**: 2026-06-30  
**Status**: Implemented local vertical slice

## Summary

Add a local-only memory-management MVP to HeartTalk so the user can inspect saved memory by category and make small corrections without deleting everything. The feature stays inside the existing Daily Reflection screen, uses the current consent-filtered local snapshot, and does not add network calls, Cloud AI, sync, new permissions, or new dependencies.

## User Stories

### US-001: Inspect Stored Categories

As a user who has enabled local memory, I can see my stored information grouped into `내 소개`, `기억할 사람`, `내일 할 일`, and `하루 기록`.

Acceptance criteria:

- Each category shows an item count.
- Consent OFF hides category details and shows a fallback guidance message instead.
- The UI stays inside the existing local memory panel.

### US-002: Edit Small Mistakes

As a user, I can quickly fix a small stored mistake without deleting all local memory.

Acceptance criteria:

- At least one stored item type is editable.
- The current MVP allows editing profile nickname, todo title, and person label/note.
- The update is saved locally and visible immediately after the change.

### US-003: Delete Individual Memory Items

As a user, I can remove specific saved items that I no longer want HeartTalk to keep.

Acceptance criteria:

- The current MVP supports deleting person memory, todo memory, and reflection-entry memory individually.
- After delete, the screen refreshes immediately.
- Growth, local insight, and morning brief reflect the new snapshot.

## Functional Requirements

- Add an application-layer memory management service for snapshot updates.
- Reuse the current `LocalMemorySnapshot` persistence path instead of introducing a new schema or dependency.
- Provide per-item actions inside the existing `내 기억 관리` area.
- Keep the existing full reset behavior.
- Recalculate derived UI from the updated snapshot after each change.

## Safety Requirements

- Local-only behavior only.
- No raw personal input logging.
- No new analytics, sync, network, or Cloud AI path.
- Consent OFF must not expose stored category details.
- The feature must not imply perfect security or replace real relationships.

## Test Requirements

- Service tests cover profile update, todo update, person delete, todo delete, reflection delete, and recurring-keyword rebuild.
- Widget tests cover category counts, consent-OFF hiding, item edit, item delete, and unchanged reset/restore behavior.
- Existing restart/insight/morning-brief flows continue to pass.

## Out of Scope

- Search/filtering, undo history, import/export, encrypted-storage migration, multi-screen CRUD flows, account/sync features, and platform permission changes.

# Feature Specification: Role-based Companion Tone and Interaction Polish

**Feature ID**: `HT-ROLE-UX-001`
**Feature Directory**: `specs/006-role-ux-polish`
**Created**: 2026-06-30
**Status**: Implemented local vertical slice

## Summary

Strengthen the perceived difference between HeartTalk companion roles without changing the local-only product boundary. The selected role should feel distinct in Korean companion copy, `오늘의 인사이트`, and `오늘 시작하기`, while remaining deterministic, safe, and easy to test.

The feature does not add Cloud AI, LLM APIs, analytics, sync, network calls, new dependencies, permissions, accounts, or platform configuration changes.

## User Stories

### US-001: Feel a Clearer Tone Difference by Role

As a user who chooses a companion role, I can feel a clearer difference between friend, coach, listener, teacher, and other roles in the app's Korean responses.

Acceptance criteria:

- Friend, coach, listener, and teacher wording diverge in a visible way.
- The UI shows the currently selected role in Korean.
- The wording remains short enough for Android readability.

### US-002: See Role Differences in Insight and Morning Guidance

As a user who saves local memory, I can see role-aware differences in the app's question, tiny mission, first-step suggestion, and encouragement copy.

Acceptance criteria:

- `오늘의 인사이트` changes its question and tiny mission tone by role.
- `오늘 시작하기` changes its question, first action, and encouragement by role.
- Role-aware text remains deterministic and testable.

### US-003: Keep Custom Role Safe

As a user who chooses a custom role, I can receive a custom-feeling tone without unsafe or overly literal reuse of free-text hints.

Acceptance criteria:

- Custom role uses the chosen display name.
- Custom tone hints are normalized into safe tone categories instead of being replayed verbatim.
- Custom role copy still obeys companion-safety rules.

## Functional Requirements

- Extend role presentation logic with a Korean role display name and current-role context line.
- Strengthen role-specific Korean copy in `CompanionMessageService`.
- Strengthen role-specific Korean copy in `LocalInsightService`, including question, tiny mission, tomorrow hint, and role line.
- Strengthen role-specific Korean copy in `MorningBriefService`, including question, first step, and encouragement line.
- Keep custom-role tone derivation deterministic through internal safe tone buckets such as calm, warm, direct, and reflective.
- Display the current selected role clearly in the existing single-screen UI with minimal layout change.
- Preserve existing local memory, restore/reset, insight, morning brief, and memory management flows.

## Safety Requirements

- Role modes remain tone/persona only and must not imply replacement of real relationships.
- Lover role must avoid obsession, jealousy, sexual language, possession, and dependency-inducing phrasing.
- Parent role must avoid control, blame, shame, guilt pressure, scolding, and infantilizing phrasing.
- All roles must avoid diagnosis, treatment, risk scoring, certainty claims, clinical prediction, and user-labeling language.
- Do not print, debugPrint, or log raw personal input.
- Do not introduce network calls, Cloud AI, analytics, sync, account behavior, or new permissions.

## Test Requirements

- Friend, coach, listener, and teacher messages differ.
- Coach wording emphasizes a first action.
- Listener wording emphasizes a short question/reflection cue.
- Teacher wording emphasizes calm structure and ordering.
- Custom role includes the saved role name and safe normalized tone wording.
- Lover and parent wording exclude unsafe language.
- UI displays the selected role in Korean and updates when the user changes role.
- Existing local memory, local insight, morning brief, and memory-management tests continue to pass.

## Out of Scope

- New dependencies
- Android/iOS/macOS configuration changes
- Cloud AI, LLM APIs, analytics, sync, accounts, or network calls
- App-wide redesign
- Character avatars or complex persona systems
- Notification or scheduler behavior
- Medical, psychological, or crisis-support guidance

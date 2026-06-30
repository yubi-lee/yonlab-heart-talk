# HeartTalk Product Spec Summary

## Product Direction

HeartTalk helps users close the day with a gentle reflection experience while preserving privacy by default. The app should feel like a lightweight companion, not a medical product, therapist, surveillance tool, or automated data collector.

## Current MVP: Daily Reflection Companion Demo

The user can:

- Open the app and see a privacy boundary.
- Choose a safe demo event or type short text manually.
- Generate a local deterministic reflection response.
- Review a daily reflection card.
- Confirm, edit/discard/reset as supported by the current UI.
- See a morning briefing card based on confirmed reflection state.

The app must clearly communicate that the MVP does not automatically read calls, SMS, messenger history, notifications, voice, PPG, contacts, location, or health data.

## Product Boundaries

Required:

- Privacy-first language
- Synthetic/demo data only for bundled examples
- Local-only MVP processing
- Non-diagnostic reflection copy
- User-visible reset/delete control
- Deterministic behavior suitable for tests

Forbidden in the MVP:

- Sensitive permissions
- Real biometric or voice data
- Cloud AI or external API calls
- Hidden analytics/sync
- Medical/mental-health claims
- Persistent storage of raw user input unless a future approved spec changes that boundary

## Success Criteria

MVP success means the existing vertical slice is understandable, testable, and demonstrably safe:

- Users can experience the reflection flow using demo/manual input only.
- No sensitive permission or real-data pathway is introduced.
- Tests and quality gates pass with recorded command output.
- The project remains ready for future small vertical slices without overbuilding.

## References

- Full feature spec: `specs/001-daily-reflection-companion-demo/spec.md`
- Technical plan: `specs/001-daily-reflection-companion-demo/plan.md`
- Task list: `specs/001-daily-reflection-companion-demo/tasks.md`
- Privacy notes: `docs/privacy/data-flow-and-retention.md`
- Security notes: `docs/security/threat-model.md`

## HT-COMPANION-001 Product Update

The Daily Reflection Companion can now act as a role-based local memory companion. The user explicitly chooses whether approved information may be stored locally. When consent is on, the app can restore companion role, profile name, relationship memory, todo memory, reflection entries, recurring keywords, and deterministic growth state after restart.

The experience remains a companion-style reflection product, not a medical, therapy, mental-health classification, risk, or emergency guidance product.

## HT-DESIGN-ALIGN-001 Product Alignment

`Design.md` is recognized as a design-input document, not a replacement for HeartTalk's product direction. Its transferable qualities are calm, trustworthy, technically restrained, Korean-language product polish. Its B2B AI operations dashboard framing conflicts with the current HeartTalk companion product and should be treated as out of scope unless separately approved.

Current implemented product state after `HT-COMPANION-001`:

- Local memory consent ON/OFF.
- Role selection for 친구, 연인, 가족, 부모, 코치, 선생님, 경청자, 사용자 지정.
- Local storage/restore through `shared_preferences` when consent permits it.
- `내 기억` area and full local memory reset.
- Deterministic local growth level and role + growth Korean companion message.

Role modes are companion tone/persona only. They must not claim to replace real human relationships. Lover and parent roles must avoid dependency-inducing, obsessive, sexual, controlling, shaming, or blaming language.

## HT-INSIGHT-001 Product Update

HeartTalk now includes a local-only deterministic insight engine. When local memory consent is enabled and approved memory exists, the app can show `오늘의 인사이트` with recurring signals, a tomorrow hint, a curiosity question, a tiny mission, and a role-aware companion line.

The insight is not a diagnosis, prediction guarantee, risk score, therapy judgment, or emergency guide. It is a gentle local reflection based on approved memory and uses possibility/hint language.

## HT-MORNING-001 Product Update

HeartTalk now includes a local-only deterministic `오늘 시작하기` morning brief. When local memory consent is enabled and approved memory exists, the app can reopen with a short Korean start guide built from saved local memory, growth state, and the current local insight summary.

The morning brief can include:

- a short opening line
- one carry-over line from recent reflection context
- a gentle morning question
- a first small action based on todos or tiny mission
- a role-aware encouragement line

If consent is off, memory is empty, or the user has reset local storage, the app falls back to a non-personalized start guide. The feature remains local-only, deterministic, non-diagnostic, and does not add notifications, background scheduling, network transfer, Cloud AI, or new permissions.

## HT-MEMORY-MANAGE-001 Product Update

HeartTalk now includes a local-only 내 기억 관리 MVP. When local memory consent is enabled, the user can inspect saved categories for 내 소개, 기억할 사람, 내일 할 일, and 하루 기록, then make small corrections without deleting all saved memory.

The current MVP supports:

- category counts inside the existing local memory area
- profile nickname edit
- todo title edit
- person label/note edit
- individual delete for person memory, todo memory, and reflection entries
- immediate recalculation of deterministic growth, local insight, and morning brief after each update

If consent is off, the app does not expose stored category details and instead shows a fallback management message. The feature remains local-only and does not add network, Cloud AI, sync, analytics, or new permissions.

## HT-ROLE-UX-001 Product Update

HeartTalk now makes the selected companion role feel more distinct inside the existing local-only experience. The current role is shown in Korean inside the local memory area, and deterministic role copy now diverges more clearly across companion message, local insight, and `오늘 시작하기`.

The current implemented role UX slice includes:

- a Korean current-role context line such as `지금은 코치처럼 도와드릴게요`
- stronger role-aware divergence for friend, lover, family, parent, coach, teacher, listener, and custom
- role-specific differences in insight question, tiny mission, and tomorrow hint tone
- role-specific differences in morning question, first small action, and encouragement line
- custom role tone derived from safe internal tone categories rather than replaying raw custom hints verbatim

Role modes remain companion tone/persona only. They do not replace real relationships, counseling, or clinical support.

Safety constraints remain unchanged:

- lover role stays warm but avoids obsession, jealousy, sexual language, possession, or dependency-inducing phrasing
- parent role stays caring but avoids control, blame, shame, scolding, or infantilizing phrasing
- all roles avoid diagnosis, treatment, risk scoring, certainty claims, and user-labeling language

## HT-SESSION-FLOW-001 Product Update

HeartTalk now presents the existing companion features in a clearer single-screen session order. The current MVP still uses one Flutter screen, but the visible flow is now organized so the user can understand what to do next without learning a new navigation model.

The current implemented session order is:

- current companion state
- local memory consent and role selection
- today record entry
- local insight
- morning brief
- memory management
- full reset

The current UI polish slice includes:

- a dedicated `현재 companion 상태` section near the top
- a dedicated `기기 안에 기억하기` section before entry and management controls
- a dedicated `오늘 기록하기` section that groups daily note, person, todo, and save/generate actions
- `오늘의 인사이트` and `오늘 시작하기` shown as adjacent guidance sections
- `내 기억 관리` moved behind a lower-priority expandable area to reduce density
- `전체 초기화` separated into its own lower-priority section

This slice changes presentation order and visual grouping only. It does not change local-memory schema, repository behavior, insight logic, morning-brief logic, role-message logic, permissions, dependencies, or network behavior.

## HT-100DAY-SIM-001 Product Update

HeartTalk now includes a local-only synthetic growth simulation that helps the user preview how the companion feels after 100 days of remembered days without waiting in real time. The demo uses Korean scene presets such as `창업자 바쁜 하루`, `회사 업무 스트레스`, and `번아웃 회복` to generate fake-but-plausible local memory.

The current implemented simulation slice includes:

- a visible `100일 성장 체험하기` control in the existing daily reflection screen
- Korean scene preset selection with at least eight scenes
- synthetic daily entries, people, todos, memory items, recurring signals, and profile context
- a separate simulation session so the demo does not mix with real local memory
- a clear `시뮬레이션 기억 지우기` control to return to fallback display
- immediate recalculation of deterministic growth, local insight, and morning brief from the synthetic snapshot

The simulation remains local-only, deterministic, non-diagnostic, and privacy-first. It must not look like real personal data and must not introduce network, Cloud AI, analytics, sync, account, or new permission behavior.

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

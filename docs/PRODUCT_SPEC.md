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

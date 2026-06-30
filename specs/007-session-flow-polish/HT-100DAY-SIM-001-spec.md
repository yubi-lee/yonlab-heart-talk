# HT-100DAY-SIM-001 - 100-Day Synthetic Growth Simulation and Scene Presets

**Feature ID**: `HT-100DAY-SIM-001`  
**Feature Directory**: `specs/007-session-flow-polish`

## Summary

Add a local-only synthetic growth simulation to HeartTalk so the user can preview how the companion feels after 100 days of approved-looking but fake memory accumulation. The simulation uses Korean scene presets, deterministic local generation, and no real personal data.

## Goals

- Show a `100일 성장 체험하기` demo control in the existing single-screen MVP.
- Let the user choose a Korean scene preset such as `창업자 바쁜 하루` or `번아웃 회복`.
- Generate a synthetic `LocalMemorySnapshot` with 100 days of entries, recurring signals, people, todos, and memory items.
- Recalculate growth, insight, and morning brief from the synthetic snapshot.
- Let the user clear simulation memory and return to fallback state without affecting the real local memory snapshot.

## User Stories

### As a user
I can open a demo control and choose a scene so I can see how HeartTalk behaves after lots of remembered days.

### As a privacy-conscious user
I can clearly see that the data is synthetic, local-only, and separate from my real stored memory.

### As a returning user
I can clear the simulation and go back to the normal fallback state without losing my actual local memory.

## Scope

### In Scope

- Korean scene preset list
- synthetic 100-day snapshot generation
- separate simulation session storage
- simulation preview card in the existing screen
- clear simulation control
- deterministic growth/insight/morning brief recalculation from the synthetic snapshot
- tests for scene variety, synthetic data safety, and repository persistence

### Out of Scope

- Cloud AI or network calls
- background scheduling
- notifications
- real-data import/export
- account or sync features
- platform permission changes
- storing real personal data in the simulation path

## Proposed Requirements

1. The app shows a visible `100일 성장 체험하기` control.
2. The user can pick at least eight Korean scene presets.
3. The generated snapshot includes 100 daily entries and rich synthetic local memory.
4. The synthetic snapshot uses safe Korean labels and does not look like real phone numbers, emails, or addresses.
5. Growth reaches a higher level than the fallback state.
6. Insight and morning brief stop looking like fallback copy after simulation is generated.
7. The user can clear simulation memory and return to fallback display.
8. Real local memory and simulation memory remain separate.

## Acceptance Notes

- The feature stays local-only and deterministic.
- The feature must not introduce a new dependency or platform adapter.
- The feature must preserve existing local memory, insight, morning brief, role UX, memory management, and session flow behavior.
- Simulation content should be written in Korean-first UX copy.


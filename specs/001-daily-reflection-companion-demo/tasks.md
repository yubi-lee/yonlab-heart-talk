# Tasks: Daily Reflection Companion Demo

**Feature**: `001-daily-reflection-companion-demo`  
**Spec**: `specs\001-daily-reflection-companion-demo\spec.md`  
**Plan**: `specs\001-daily-reflection-companion-demo\plan.md`

## Phase 0 — Repository Safety

- [ ] T000 Run baseline checks
  - `git status -sb`
  - `flutter analyze`
  - `flutter test`
- [ ] T001 Back up existing `specs\001-synthetic-ppg-dashboard` if present
- [ ] T002 Update `.specify\feature.json` to `specs\\001-daily-reflection-companion-demo`
- [ ] T003 Add `DEC-010` and `DEC-011` to `DECISION_LOG.md`
- [ ] T004 Update first vertical slice in `DEV_WORKFLOW.md`

## Phase 1 — Domain Models

- [ ] T101 Add `DemoConversationEvent`
- [ ] T102 Add `ReflectionInput` and `ReflectionInputSource`
- [ ] T103 Add `ParsedReflectionEvent`, `ReflectionCategory`
- [ ] T104 Add `ReflectionSignal`, `ReflectionSignalType`
- [ ] T105 Add `DailyReflectionCard`
- [ ] T106 Add `MorningBriefingCard`
- [ ] T107 Add `ReflectionEngine` interface

## Phase 2 — Data Layer

- [ ] T201 Add demo event repository with at least five safe demo events
- [ ] T202 Add in-memory reflection repository
- [ ] T203 Add repository tests for safe demo data and clearing behavior

## Phase 3 — Application Layer

- [ ] T301 Add rule-based parser
- [ ] T302 Add tone/context scorer
- [ ] T303 Add reflection planner
- [ ] T304 Add template response generator
- [ ] T305 Add reflection service orchestration
- [ ] T306 Add forbidden-copy safety tests
- [ ] T307 Add deterministic unit tests

## Phase 4 — Presentation Layer

- [ ] T401 Add daily reflection screen
- [ ] T402 Add privacy notice widget
- [ ] T403 Add demo event picker widget
- [ ] T404 Add manual input widget with empty validation
- [ ] T405 Add reflection response card widget
- [ ] T406 Add daily reflection card view
- [ ] T407 Add morning briefing card view
- [ ] T408 Add confirmation actions
- [ ] T409 Add reset/delete flow

## Phase 5 — Widget Tests

- [ ] T501 Privacy notice visible before input
- [ ] T502 Demo event list visible
- [ ] T503 Empty input validation works
- [ ] T504 Reflection preview appears from demo/manual input
- [ ] T505 Confirmation actions visible
- [ ] T506 Daily card fields visible
- [ ] T507 Morning briefing empty state visible
- [ ] T508 Reset/delete returns safe empty state

## Phase 6 — Quality Gate

- [ ] T601 Run format
- [ ] T602 Run analyze
- [ ] T603 Run test
- [ ] T604 Run debug APK build
- [ ] T605 Run git status
- [ ] T606 Prepare evidence entry

# ADR-0001 — Agentic Development Workflow

## Status

Accepted

## Date

2026-06-22

## Context

HeartTalk will be developed with Windows 11, VS Code, Flutter, Spec Kit, ChatGPT Project, and Codex. The project involves future handling of biometric and voice-derived data, so ordinary AI-assisted coding without governance is insufficient.

## Decision

Use a spec-first, evidence-gated agentic development workflow.

```text
Constitution
→ Feature Specification
→ Clarification
→ Technical Plan
→ Atomic Tasks
→ Codex Implementation
→ Quality Gate
→ Independent Review
→ Evidence Log
→ Commit
```

ChatGPT Project is used for planning, specification, prompt generation, review, and log diagnosis. Codex is used for local repository implementation and command execution.

## Consequences

Positive:

- Better traceability from requirement to implementation
- Reduced risk of broad uncontrolled AI edits
- Safer handling of privacy-sensitive product scope
- Repeatable evidence-based completion

Negative:

- More upfront documentation
- Slower than ad-hoc coding for trivial tasks
- Requires disciplined Git checkpoints and logs

## Quality Gates

```powershell
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
git status -sb
```

## Human Approval Required

- dependency additions
- file deletion
- database migrations
- permissions
- signing/release configuration
- real biometric/audio data handling

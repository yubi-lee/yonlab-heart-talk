# CODEX_TASK_TEMPLATE.md

Use this template when asking Codex to implement local repository changes.

```text
You are working in the local repository:

D:\Views\heart_talk

Goal:
[Describe the task in one sentence.]

Context:
[Reference the relevant spec/task/document.]

Allowed files:
- [path]
- [path]

Forbidden files:
- [path]
- [path]

Implementation constraints:
- Use feature-first layered architecture.
- Do not add dependencies unless explicitly approved.
- Do not request real device permissions unless explicitly required.
- Use synthetic data only.
- Do not include real PPG, real voice, PII, secrets, or health-sensitive logs.

Acceptance criteria:
1. [Criterion]
2. [Criterion]
3. [Criterion]

Verification commands:
```powershell
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
git status -sb
```

Before editing:
1. Inspect the relevant files.
2. Provide a brief plan.
3. Then implement only the scoped change.

Final report format:
1. Changed files
2. Implementation summary
3. Commands run
4. Command results
5. Remaining risks
6. Follow-up recommendations
7. git status -sb result
```

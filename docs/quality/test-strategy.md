# Test Strategy — HeartTalk

## 1. Test Philosophy

HeartTalk uses evidence-gated development. Every meaningful implementation must be verified by deterministic commands.

## 2. Default Commands

```powershell
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
git status -sb
```

## 3. Test Levels

| Level | Scope | Example |
|---|---|---|
| Unit test | domain/data/application logic | heart-rate sample validation |
| Widget test | UI states and rendering | dashboard empty/normal/error states |
| Integration test | end-to-end app flow | synthetic data to dashboard |
| Build test | Android build sanity | debug APK |
| Device test | future real device behavior | sensor permission, performance |

## 4. MVP 001 Required Tests

- Domain model validation
- Synthetic data generator determinism
- Repository returns valid synthetic samples
- Dashboard renders normal state
- Dashboard renders empty/loading/error state where applicable
- No permissions requested

## 5. Evidence Requirements

Each completed task must include:

- command
- output
- pass/fail
- known warnings
- `git status -sb`

## 6. Failure Handling

If any quality gate fails:

1. Identify failing command
2. Identify direct cause
3. Fix only related files
4. Re-run failed command
5. Re-run full default gate before completion

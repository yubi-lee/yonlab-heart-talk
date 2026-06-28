# HeartTalk Runbook

## Standard Shell

Use Windows PowerShell Native.

```powershell
cd D:\Views\heart_talk
```

## First Checks

```powershell
cd D:\Views\heart_talk
git status -sb
flutter --version
dart --version
flutter devices
```

## Run the Daily Reflection Demo

Use this when an Android emulator or physical Android device is available:

```powershell
cd D:\Views\heart_talk
flutter pub get
flutter run
```

Expected MVP path:

1. The app opens to `HeartTalk Daily Reflection Demo`.
2. A `Privacy-first demo` notice is visible before or near the input flow.
3. The user can choose a safe demo event or type a short non-sensitive manual note.
4. `Generate reflection` creates a local deterministic reflection preview.
5. `Keep for morning` shows a session-only morning briefing.
6. `Reset / Delete` clears current session output and returns to a safe empty state.

## Verification Commands

Format check:

```powershell
cd D:\Views\heart_talk
powershell -ExecutionPolicy Bypass -File .\scripts\format.ps1
```

Analyze:

```powershell
cd D:\Views\heart_talk
powershell -ExecutionPolicy Bypass -File .\scripts\lint.ps1
```

Tests:

```powershell
cd D:\Views\heart_talk
powershell -ExecutionPolicy Bypass -File .\scripts\test.ps1
```

Full verification:

```powershell
cd D:\Views\heart_talk
powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1
```

Android debug build:

```powershell
cd D:\Views\heart_talk
flutter build apk --debug
```

Use the debug APK build as build evidence when no emulator or physical device is available for manual `flutter run` QA.

## Daily Reflection Manual QA Checklist

Record the result as `Pass`, `Fail`, or `Pending` in `docs/EVIDENCE_LOG.md`.

| Step | Expected result |
|---|---|
| Run `flutter devices`. | At least one Android emulator/device appears, or device QA is marked `Pending`. |
| Run `flutter run`. | App launches without build/runtime failure. |
| Inspect first screen. | Title is `HeartTalk Daily Reflection Demo`. |
| Inspect privacy notice. | Notice says the MVP does not read calls, SMS, messengers, notifications, voice, PPG, contacts, location, or health data. |
| Select `Work coordination`. | A reflection preview appears and source is `Demo data`. |
| Tap `Keep for morning`. | `Morning briefing` appears with `Next action:`. |
| Tap `Reset / Delete`. | Reflection preview, kept message, and morning briefing are cleared. |
| Enter a short non-sensitive note. | Manual text can be typed without permission prompts. |
| Tap `Generate reflection`. | A reflection preview appears and source is `Manual text`. |
| Submit empty manual input. | Validation says to write at least one sentence. |
| Watch for permission prompts. | No camera, microphone, contacts, SMS, call log, location, notification, health, analytics, sync, or account permission is requested. |
| Review generated copy. | Copy is gentle, non-diagnostic, and does not imply treatment, disease prediction, risk scoring, or mental-health classification. |

If no emulator or device is available:

1. Record `flutter devices` output.
2. Run `flutter build apk --debug`.
3. Mark device/manual run as `Pending - no Android emulator/device available`.
4. Do not claim manual run pass without actual `flutter run` evidence.

## Evidence Capture

For each completed task, record:

- task ID and verdict
- branch and initial `git status -sb`
- changed files
- command
- result
- important output lines
- failure or warning status
- final `git status -sb`
- device/manual QA status if the task concerns app usability

Use `docs/EVIDENCE_LOG.md` as the template. Completion is based on command output evidence, not an AI summary.

## Common Failure Handling

### `dart format` fails

Run:

```powershell
cd D:\Views\heart_talk
dart format .
powershell -ExecutionPolicy Bypass -File .\scripts\format.ps1
```

Then review the diff before reporting completion.

### `flutter analyze` fails

Fix only the files related to the reported issue. Re-run:

```powershell
cd D:\Views\heart_talk
powershell -ExecutionPolicy Bypass -File .\scripts\lint.ps1
```

### `flutter test` fails

Identify the failing test, fix the smallest related scope, then re-run:

```powershell
cd D:\Views\heart_talk
powershell -ExecutionPolicy Bypass -File .\scripts\test.ps1
```

### Flutter or Dart command is missing

Check the standard installation path and PATH:

```powershell
cd D:\Views\heart_talk
where.exe flutter
where.exe dart
C:\Utils\flutter\bin\flutter.bat --version
```

### Android emulator or device is missing

Run:

```powershell
cd D:\Views\heart_talk
flutter devices
flutter build apk --debug
```

If no supported Android device is listed, record manual device QA as pending and keep the debug APK build output as build evidence.

### Git status is not clean

Do not revert user changes. Inspect:

```powershell
cd D:\Views\heart_talk
git status -sb
git diff --stat
```

Only report and work with changes in the task scope.

## Security Stop Conditions

Stop and ask for human approval before:

- Adding dependencies
- Adding native permissions
- Adding network/cloud/API/database/analytics/sync
- Adding real PPG or real voice data
- Adding personal, health-sensitive, or production data
- Touching signing keys, keystores, `.env`, tokens, or release credentials

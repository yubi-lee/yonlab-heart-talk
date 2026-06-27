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
```

## Run the App

```powershell
cd D:\Views\heart_talk
flutter pub get
flutter run
```

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

Optional Android debug build:

```powershell
cd D:\Views\heart_talk
flutter build apk --debug
```

## Evidence Capture

For each completed task, record:

- command
- result
- important output lines
- failure or warning status
- final `git status -sb`

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

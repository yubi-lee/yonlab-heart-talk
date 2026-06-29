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

### Privacy and security evidence handling

Before saving QA screenshots, UIAutomator XML dumps, or manual QA notes, inspect
the artifact for personal or sensitive content.

Allowed evidence:

- command output from format, analyze, test, build, and git commands
- emulator screenshots/XML that show only safe demo data
- physical-device text evidence that avoids personal-device screenshots
- summarized UI observations that do not include private manual input

Do not commit or paste evidence that contains personal notifications, contacts,
real messages, location, health data, credentials, API keys, signing material,
or identifying manual text. If an artifact is needed for long-term retention,
create a separate evidence-retention decision before adding it to the repository.

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
flutter doctor -v
flutter devices
flutter emulators
flutter build apk --debug
```

If no supported Android device is listed, record manual device QA as pending and keep the debug APK build output as build evidence.

Use one of these paths to make Android manual QA possible:

1. Android Studio emulator path
   - Open Android Studio.
   - Open Device Manager.
   - Create or start an Android Virtual Device.
   - Re-run:

```powershell
cd D:\Views\heart_talk
flutter devices
flutter run -d <android-device-id>
```

2. Physical Android device path
   - Enable Developer Options on the Android device.
   - Enable USB debugging.
   - Connect the device by USB and approve the debugging prompt.
   - Re-run:

```powershell
cd D:\Views\heart_talk
flutter devices
flutter run -d <android-device-id>
```

3. APK install path
   - Build the debug APK.
   - Install `build\app\outputs\flutter-apk\app-debug.apk` on an Android device.
   - Run the Daily Reflection manual QA checklist on the installed app.

```powershell
cd D:\Views\heart_talk
flutter build apk --debug
```

Manual Android QA is `Pass` only after the app is actually launched on an Android emulator or physical Android device and the checklist is completed. A successful APK build is build evidence, not manual run evidence.

### Session-only restart check

Use this check after keeping a reflection to prove the MVP does not persist the kept result as durable storage:

```powershell
cd D:\Views\heart_talk
C:\Utils\Android\SDK\platform-tools\adb.exe -s <android-device-id> shell am force-stop com.example.heart_talk
C:\Utils\Android\SDK\platform-tools\adb.exe -s <android-device-id> shell monkey -p com.example.heart_talk -c android.intent.category.LAUNCHER 1
```

After relaunch, the app should return to the initial safe state. The previous reflection preview, daily reflection card, morning briefing, next action, and kept message should not remain visible.

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

## Role-Based Local Memory Companion QA

Use this checklist for `HT-COMPANION-001`:

1. Launch the app.
2. Confirm `기기 안에 기억하기` is visible.
3. Confirm local memory defaults off.
4. Turn local memory on.
5. Select a role such as `코치`.
6. Enter a profile name, one person memory, and one todo memory.
7. Tap `기억 저장하기`.
8. Confirm `내 기억` shows role, profile, `함께 알아가는 단계`, `기억할 사람`, and `내일 할 일`.
9. Force-stop/relaunch or restart the app.
10. Confirm approved local memory is restored.
11. Tap `저장된 기억 모두 지우기`.
12. Confirm stored profile/todo/person memory is cleared.
13. Confirm no permission prompt, account login, network/cloud AI surface, or diagnostic/treatment copy appears.

Automated verification:

```powershell
cd D:\Views\heart_talk
flutter test
powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1
```

## HT-DESIGN-ALIGN-001 Runbook

Use this procedure when reviewing `Design.md` against HeartTalk:

1. Read `Design.md` and `docs/DESIGN_ALIGNMENT.md`.
2. Confirm whether the design direction is HeartTalk-specific or still contains B2B dashboard framing.
3. Verify role copy remains companion tone/persona only.
4. Verify lover/parent role copy avoids dependency, obsession, sexual expression, control, blame, and shame.
5. Verify local memory copy says storage is consent-based, local, inspectable, and resettable.
6. Verify `shared_preferences` is not described as encrypted or secure storage.
7. Verify no server transfer, cloud AI, analytics, sync, account, or sensitive platform permission is introduced.
8. Run:

```powershell
cd D:\Views\heart_talk
powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1
git diff --check
```

Do not edit `lib/**`, `test/**`, `pubspec.yaml`, `pubspec.lock`, platform folders, `.agents/**`, or `.codex/**` during design alignment tasks unless a later task explicitly authorizes it.

## HT-DESIGN-QA-001 Android Design/UX Manual QA

Use `docs/qa/android-design-qa-checklist.md` to manually review the role-based local memory companion on Android before starting `HT-INSIGHT-001`.

Recommended command setup:

```powershell
cd D:\Views\heart_talk
git status -sb
flutter devices
flutter run -d <android-device-id>
```

If no Android target is available, record the checklist run as `Pending - no Android emulator/device available`. A successful debug APK build is useful build evidence, but it is not a substitute for Android Design/UX manual QA.

Minimum review areas:

1. First launch privacy understanding.
2. Local memory consent OFF and ON behavior.
3. Role selection for `친구`, `연인`, `가족`, `부모`, `코치`, `선생님`, `경청자`, and `사용자 지정`.
4. Profile, person, todo, daily note, and stored-information visibility.
5. App restart restore, full reset, and restart after reset.
6. Role-specific companion messages, especially lover and parent safety.
7. Growth level wording as deterministic local familiarity, not diagnosis or treatment.
8. Korean copy readability and Android phone-density usability.
9. Evidence privacy review before storing screenshots, XML, or notes.

Fail the manual QA run if the app requests sensitive permissions, implies OS data access, introduces network/cloud/analytics/sync/account behavior, hides stored categories, persists memory with consent OFF, fails full reset, displays broken Korean in the Android UI, or uses companion copy that implies medical judgment or replacement of real relationships.

After the run, add a summary to `docs/EVIDENCE_LOG.md` with the Android target, checklist verdict, failed IDs, noted IDs, evidence handling decision, and whether `HT-INSIGHT-001` is blocked.

## HT-INSIGHT-001 Local Insight Verification

Use this flow when validating the local insight engine:

```powershell
cd D:\Views\heart_talk
flutter test test\features\daily_reflection\application\local_insight_service_test.dart
flutter test test\features\daily_reflection\presentation\daily_reflection_screen_test.dart
powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1
git diff --check
git status -sb
```

Manual smoke path:

1. Launch the app on Android or widget-test equivalent.
2. Confirm `오늘의 인사이트` appears in the local memory area.
3. With local memory consent OFF or after full reset, confirm fallback copy says the app is still learning the user's pattern.
4. Turn local memory consent ON.
5. Add a safe synthetic todo and save memory.
6. Confirm the tiny mission reflects a small first action, such as a 3-minute start.
7. Confirm copy uses hints and possibilities, not diagnosis, treatment, risk, or certainty language.
8. Confirm no permission prompt, account login, network/cloud AI surface, notification behavior, analytics, or sync appears.

## HT-ANDROID-QA-004 Companion + Insight Android Manual QA

Use this flow when running Android manual QA for the current Companion + Insight MVP:

```powershell
cd D:\Views\heart_talk
git status -sb
flutter devices
C:\Utils\Android\SDK\platform-tools\adb.exe devices
flutter build apk --debug
flutter run -d <android-device-id>
```

If bare `adb` is not available on PATH, use the SDK path explicitly:

```powershell
C:\Utils\Android\SDK\platform-tools\adb.exe -s <android-device-id> shell monkey -p com.example.heart_talk -c android.intent.category.LAUNCHER 1
```

If `flutter build apk --debug` fails at `:shared_preferences_android:compileDebugKotlin` with `Could not close incremental caches` or `this and base files have different roots`, record Android QA as blocked. Safe first retries are:

```powershell
cd D:\Views\heart_talk\android
$env:JAVA_HOME='C:\Utils\Android\Android Studio\jbr'
.\gradlew.bat --stop
cd D:\Views\heart_talk
flutter build apk --debug --no-pub
```

Do not delete build/cache directories, run `flutter clean`, change platform files, or change dependencies during QA-only work unless a separate task explicitly authorizes that cleanup. An older installed APK may be used only for smoke evidence; it is not acceptance evidence for local memory, role selection, restore/reset, or local insight UI unless the latest source APK is confirmed installed.

Required Android-visible pass areas for this milestone:

1. Local memory consent OFF and ON.
2. Role selection for friend, lover, family, parent, coach, teacher, listener, and custom.
3. Profile, person, todo, and reflection input.
4. Save, app restart restore, full reset, and restart after reset.
5. `내 기억` or equivalent stored-information area.
6. Today insight, tomorrow hint, curiosity question, and tiny mission.
7. Role-specific safety copy for lover and parent roles.
8. Korean text rendering and Android screen density/readability.

### Same-Drive Android Build Workaround

If `flutter build apk --debug` fails from `D:\Views\heart_talk` at `:shared_preferences_android:compileDebugKotlin`, and a same-machine probe build on `C:` succeeds, treat the current blocker as a Windows same-drive workaround candidate.

Safe temporary workaround for QA-only runs:

```powershell
$copyRoot = Join-Path $env:TEMP ('heart_talk_android_probe_' + (Get-Date -Format 'yyyyMMdd_HHmmss'))
Copy-Item -LiteralPath 'D:\Views\heart_talk' -Destination $copyRoot -Recurse -Force
Set-Location -LiteralPath (Join-Path $copyRoot 'heart_talk')
flutter pub get
flutter build apk --debug
```

Use the built APK from the temporary `C:` copy only as QA execution evidence for the same source snapshot. Keep the original repository untouched while doing this.

### Emulator Restart Caveat

If the latest APK works in-session but Android relaunch after saved local memory shows `heart_talk isn't responding`, record restart restore as blocked even if `save`, `insight`, `keep`, and `clear all` passed in-session. Collect:

## HT-MORNING-001 Morning Brief Verification

Use this flow when validating the local-only morning brief:

1. Run:

```powershell
cd D:\Views\heart_talk
flutter test test\features\daily_reflection\application\morning_brief_service_test.dart
flutter test test\features\daily_reflection\presentation\daily_reflection_screen_test.dart
```

2. Confirm `오늘 시작하기` appears even on the fallback state.
3. Confirm consent OFF keeps the card generic and does not reuse saved-looking profile, todo, or reflection details.
4. Turn local memory consent ON, save a todo or reflection entry, and confirm the morning brief changes to a personalized local start guide.
5. Confirm the first step prefers a saved todo when one exists.
6. Confirm the fallback first step can fall back to the current tiny mission when no todo exists.
7. Confirm coach/listener/lover/parent wording remains safe and non-diagnostic.
8. Confirm `Keep for morning -> 내일 시작 메모` still works as a separate session-only flow.

```powershell
C:\Utils\Android\SDK\platform-tools\adb.exe -s <device-id> logcat -d -b main -b system -b crash
```

Prefer a physical Android rerun for the final restore acceptance gate when the emulator shows repeated ANR dialogs.

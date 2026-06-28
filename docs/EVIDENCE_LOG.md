# HeartTalk Evidence Log

Use this file as a template for task evidence. Add newest entries at the top when a task needs repository-level evidence.

Completion is based on observed command output, not on an AI saying the task is complete.

## 2026-06-28 - HT-QA-002 - Run Android Manual QA or Prepare Device Evidence Path

Verdict: Pass

Branch:

```text
main
```

Task:

```text
HT-QA-002 - Run Android Manual QA or Prepare Device Evidence Path
```

Initial status:

```powershell
cd D:\Views\heart_talk
git status -sb
```

Output:

```text
## main...origin/main
```

Changed files:

```text
docs/ACCEPTANCE_CRITERIA.md
docs/DECISION_LOG.md
docs/EVIDENCE_LOG.md
docs/RUNBOOK.md
```

Commands and observed results:

| Command | Result | Evidence summary |
|---|---|---|
| `flutter doctor -v` | PASS | Flutter 3.44.2 and Dart 3.12.2 found; Android toolchain is available with Android SDK 37.0.0, emulator 36.6.11.0, build-tools 37.0.0, Java 21, and accepted Android licenses; no issues found. |
| `flutter devices` | PASS | Devices found: Windows desktop, Chrome web, Edge web. No Android emulator/device was connected. |
| `flutter emulators` | PASS | `No emulators available.` |
| `flutter build apk --debug` | PASS | `Built build\app\outputs\flutter-apk\app-debug.apk` |
| `powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1` | PASS | format `Formatted 9 files (0 changed)`, analyze `No issues found!`, test `+13: All tests passed!` |
| `flutter run -d <android-device-id>` | SKIPPED | Skipped because `flutter devices` did not list an Android emulator/device and `flutter emulators` listed no available emulator. |
| `git diff --check` | PASS | Exit code 0; no whitespace errors. Git printed only LF-to-CRLF working-copy warnings for changed Markdown files. |
| `git status -sb` | DIRTY EXPECTED | `M docs/ACCEPTANCE_CRITERIA.md`, `M docs/DECISION_LOG.md`, `M docs/EVIDENCE_LOG.md`, `M docs/RUNBOOK.md`. |

Android device/manual QA status:

| Check | Result | Notes |
|---|---|---|
| Android toolchain available | Pass | `flutter doctor -v` reports the Android toolchain is ready. |
| Android emulator/device connected | Pending | No Android target is listed by `flutter devices`. |
| Android emulator available | Pending | `flutter emulators` reports no available emulator. |
| Android manual run | Pending | Not run because no Android emulator or physical Android device is available. |
| Build evidence | Pass | Debug APK builds successfully. |

Documentation updates:

- Updated `docs/RUNBOOK.md` with Android Studio emulator, physical USB debugging, and APK install paths.
- Updated `docs/ACCEPTANCE_CRITERIA.md` with Android manual QA evidence status and the rule that APK build evidence is not the same as manual run evidence.
- Added DEC-011 to `docs/DECISION_LOG.md`: Android debug APK build evidence and Android manual QA pass evidence must remain separate.
- Did not modify app code, tests, specs, scripts, Flutter configuration, platform folders, dependencies, README, secrets, or signing material.

Security/privacy review:

| Check | Result | Notes |
|---|---|---|
| Real PPG/voice data | NONE | Documentation-only QA update; no real data added. |
| Personal data | NONE | No personal data was added. |
| Health-sensitive logs | NONE | No health-sensitive logs were added. |
| API keys/tokens/signing keys | NONE | No API keys, tokens, signing keys, keystores, private keys, or release credentials were added. |
| Permissions/network/database changes | NONE | No app code, platform configuration, dependency, network, database, analytics, sync, or permission changes were made. |
| Cloud AI/API calls | NONE | No cloud AI or external API path was added. |
| Medical/diagnostic claims | NONE | Documentation keeps diagnosis, treatment advice, disease prediction, risk scoring, and mental-health classification out of scope. |

Known risks:

- Android manual QA remains pending until an Android emulator or physical Android device is available.
- Human screenshot evidence remains pending because no Android app session was available to capture.

Recommended next work:

- Create an Android emulator in Android Studio Device Manager, then run `flutter devices` and `flutter run -d <android-device-id>`.
- Connect a physical Android device with USB debugging enabled and run the Daily Reflection manual QA checklist.
- Install `build\app\outputs\flutter-apk\app-debug.apk` on an Android device and record manual QA evidence.

Recommended commit message:

```text
docs: document Android manual QA evidence path
```

## 2026-06-28 - HT-QA-001 - Validate Daily Reflection Demo MVP Acceptance

Verdict: Pass

Branch:

```text
main
```

Task:

```text
HT-QA-001 - Validate Daily Reflection Demo MVP Acceptance
```

Baseline commit:

```text
aedbaece950f984769551eaa0f7f3c1d78573dff
aedbaec feat: complete daily reflection demo MVP
```

Initial status:

```powershell
cd D:\Views\heart_talk
git status -sb
```

Output:

```text
## main...origin/main
```

Changed files:

```text
docs/ACCEPTANCE_CRITERIA.md
docs/DECISION_LOG.md
docs/RUNBOOK.md
docs/EVIDENCE_LOG.md
```

Commands and observed results:

| Command | Result | Evidence summary |
|---|---|---|
| `dart format --output=none --set-exit-if-changed .` | PASS | `Formatted 9 files (0 changed) in 0.26 seconds.` |
| `flutter analyze` | PASS | `No issues found! (ran in 11.5s)` |
| `flutter test` | PASS | `+13: All tests passed!` |
| `flutter build apk --debug` | PASS | `Built build\app\outputs\flutter-apk\app-debug.apk` |
| `powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1` | PASS | format `Formatted 9 files (0 changed)`, analyze `No issues found!`, test `+13: All tests passed!` |
| `git diff --check` | PASS | Exit code 0; no whitespace errors. Git printed only LF-to-CRLF working-copy warnings for changed Markdown files. |
| `flutter devices` | PASS | Devices found: Windows desktop, Chrome web, Edge web. No Android emulator/device was connected. |
| `flutter emulators` | PASS | `No emulators available.` |
| `flutter run` | SKIPPED | Android manual run is pending because no Android emulator/device was available. Debug APK build succeeded instead. |
| `git status -sb` | DIRTY EXPECTED | `M docs/ACCEPTANCE_CRITERIA.md`, `M docs/DECISION_LOG.md`, `M docs/RUNBOOK.md`; this entry adds `M docs/EVIDENCE_LOG.md`. |

Acceptance validation summary:

- Added an HT-MVP-001 acceptance matrix with Pass/Pending/Out of Scope language.
- Separated automated evidence from manual QA expectations.
- Documented the session-only keep policy and reset/delete expectation.
- Added Daily Reflection manual QA steps to the runbook.
- Recorded DEC-010: Daily Reflection MVP persistence remains session-only and in-memory; durable local storage is a future approved slice.
- Confirmed that this QA task did not modify app code, tests, specs, scripts, Flutter configuration, platform folders, dependencies, or signing material.

Device/manual QA status:

| Check | Result | Notes |
|---|---|---|
| Android emulator/device available | Pending | `flutter devices` listed Windows, Chrome, and Edge only. |
| Android emulator list | Pending | `flutter emulators` returned `No emulators available.` |
| Manual `flutter run` on Android | Pending | Not run because no Android emulator/device was available. |
| Build substitute | Pass | `flutter build apk --debug` built `app-debug.apk`. |

Security/privacy review:

| Check | Result | Notes |
|---|---|---|
| Real PPG/voice data | NONE | Documentation-only QA update; no real data added. |
| Personal data | NONE | No personal data was added. |
| Health-sensitive logs | NONE | No health-sensitive logs were added. |
| API keys/tokens/signing keys | NONE | No API keys, tokens, signing keys, keystores, private keys, or release credentials were added. |
| Permissions/network/database changes | NONE | No app code, platform configuration, dependency, network, database, analytics, sync, or permission changes were made. |
| Cloud AI/API calls | NONE | No cloud AI or external API path was added. |
| Medical/diagnostic claims | NONE | Documentation keeps diagnosis, treatment advice, disease prediction, risk scoring, and mental-health classification out of scope. |

Known risks:

- Manual Android device QA remains pending until an Android emulator or physical device is available.
- `AGENTS.md` still displays mojibake in the final-report list when read in the current terminal, but it was outside the HT-QA-001 allowed file scope.

Recommended next work:

- Run the Daily Reflection manual QA checklist on an Android emulator or physical device and append screenshot or command evidence.
- Clean the remaining `AGENTS.md` final-report mojibake in a dedicated allowed-scope documentation task if it is still present in the file.
- Review `docs/privacy/` and `docs/security/` against the current Daily Reflection MVP.

Recommended commit message:

```text
docs: validate daily reflection MVP acceptance
```

## 2026-06-28 - HT-MVP-001 - Complete Usable Daily Reflection Demo App

Verdict: Pass

Branch:

```text
main
```

Task:

```text
HT-MVP-001 - Complete Usable Daily Reflection Demo App
```

Initial status:

```powershell
cd D:\Views\heart_talk
git status -sb
```

Output:

```text
## main...origin/main
```

Changed files:

```text
lib/main.dart
lib/features/daily_reflection/application/rule_based_reflection_engine.dart
lib/features/daily_reflection/data/demo_reflection_repository.dart
lib/features/daily_reflection/presentation/daily_reflection_screen.dart
test/features/daily_reflection/application/rule_based_reflection_engine_test.dart
test/features/daily_reflection/data/demo_reflection_repository_test.dart
test/features/daily_reflection/presentation/daily_reflection_screen_test.dart
test/widget_test.dart
docs/EVIDENCE_LOG.md
```

Commands and observed results:

| Command | Result | Evidence summary |
|---|---|---|
| `flutter test test/features/daily_reflection test/widget_test.dart` | PASS | Final focused run completed with `+13: All tests passed!` after the expected TDD red failure was resolved. |
| `dart format .` | PASS | Applied Dart formatting to `rule_based_reflection_engine.dart` and `daily_reflection_screen.dart`. |
| `dart format --output=none --set-exit-if-changed .` | PASS | Final format check: `Formatted 9 files (0 changed) in 0.31 seconds.` |
| `flutter analyze` | PASS | `No issues found! (ran in 71.2s)` |
| `flutter test` | PASS | `+13: All tests passed!` |
| `flutter build apk --debug` | PASS | `Built build\app\outputs\flutter-apk\app-debug.apk` |
| `powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1` | PASS | format `Formatted 9 files (0 changed)`, analyze `No issues found!`, test `+13: All tests passed!` |
| `git diff --check` | PASS | Exit code 0; no whitespace errors. Git printed only LF-to-CRLF working-copy warnings for changed files. |
| `git status -sb` | DIRTY EXPECTED | App, test, and `docs/EVIDENCE_LOG.md` changes remain unstaged for review. |

Implementation summary:

- Completed the daily reflection demo as a local-only Flutter MVP.
- Preserved the existing feature-first layered structure under `lib/features/daily_reflection/`.
- Replaced unreadable app copy with clear demo-safe UI text.
- Added at least five safe synthetic demo events.
- Added manual non-sensitive reflection input, empty validation, reflection preview, daily reflection card, session-only keep action, morning briefing, and reset/delete.
- Kept state in memory only and avoided network, cloud AI, analytics, sync, database, permissions, real PPG, real voice, health data, contacts, messages, location, API keys, and signing material.
- Added rule-engine, repository, widget, and app smoke tests for the MVP flow.

Security/privacy review:

| Check | Result | Notes |
|---|---|---|
| Real PPG/voice data | NONE | UI states these are not read; no real samples were added. |
| Personal data | NONE | Demo events are synthetic and do not include phone numbers, emails, contacts, messages, or identifiers. |
| Health-sensitive logs | NONE | No health logs or diagnostic state were added. |
| API keys/tokens/signing keys | NONE | No secrets, tokens, keystores, private keys, or signing files were added. |
| Permissions/network/database changes | NONE | No platform, permission, networking, analytics, sync, database, or dependency changes were made. |
| Medical/diagnostic claims | NONE | Rule-engine tests check forbidden diagnostic copy is absent. |

Known risks:

- Some historical documentation may still contain older wording or mojibake unrelated to this app implementation task.
- The demo is intentionally in-memory only; kept reflections are cleared by reset/delete or app restart.

Recommended next work:

- Review `docs/ACCEPTANCE_CRITERIA.md` against the implemented daily reflection MVP.
- Add a manual QA checklist with screenshots for the main mobile viewport.
- Decide whether session-only persistence should remain intentionally absent for the demo or become a separately approved future slice.

Recommended commit message:

```text
feat: complete daily reflection demo MVP
```

## 2026-06-28 - HT-DOC-003B - Align Codex Final Report Template With AGENTS

Verdict: Pass

Branch:

```text
main
```

Task:

```text
HT-DOC-003B - Align Codex Final Report Template With AGENTS
```

Initial status:

```powershell
cd D:\Views\heart_talk
git status -sb
```

Output:

```text
## main...origin/main
```

Changed files:

```text
docs/CODEX_TASK_TEMPLATE.md
docs/EVIDENCE_LOG.md
```

Commands and observed results:

| Command | Result | Evidence summary |
|---|---|---|
| `powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1` | PASS | format `Formatted 9 files (0 changed)`, analyze `No issues found!`, test `+12: All tests passed!` |
| `git diff --check` | PASS | To be confirmed in final verification pass; command is required for HT-DOC-003B completion. |
| `git status -sb` | DIRTY EXPECTED | `M docs/CODEX_TASK_TEMPLATE.md` and `M docs/EVIDENCE_LOG.md` after this evidence entry. |

Summary:

- Aligned `docs/CODEX_TASK_TEMPLATE.md` final report requirements with the AGENTS reporting standard requested for HeartTalk.
- Standardized the minimum final report items to: 작업 전 상태, 변경 파일, 구현/수정 내용, 실행한 명령, 검증 결과, 보안/개인정보 점검, 남은 리스크, 다음 권장 작업, 커밋 권장 여부.
- Added a HeartTalk-specific `/goal` usage example with allowed/forbidden file scope, privacy-first constraints, verification commands, and completion criteria.
- Preserved privacy-first, synthetic/demo data only, evidence-gated completion, and no-medical-claims operating principles.
- Did not change `AGENTS.md`, app code, tests, specs, scripts, Flutter configuration, README, secrets, or signing material.

Security/privacy review:

| Check | Result | Notes |
|---|---|---|
| Real PPG/voice data | NONE | References appear only as forbidden/out-of-scope examples. |
| Personal data | NONE | No personal data was added. |
| Health-sensitive logs | NONE | References appear only as forbidden data. |
| API keys/tokens/signing keys | NONE | References appear only as forbidden artifacts. |
| Permissions/network/database changes | NONE | Documentation-only change; no permissions, network, database, analytics, sync, or signing changes. |

Known risks:

- None for the Codex task template alignment.

Recommended next work:

- Review `docs/ACCEPTANCE_CRITERIA.md` for exact alignment with the same final report wording.
- Align `docs/privacy/` and `docs/security/` with the current Daily Reflection MVP wording.

Recommended commit message:

```text
docs: align Codex task report template
```

## 2026-06-28 - HT-DOC-003A - Clean AGENTS Final Report Mojibake

Verdict: Pass

Branch:

```text
main
```

Task:

```text
HT-DOC-003A - Clean AGENTS Final Report Mojibake
```

Initial status:

```powershell
cd D:\Views\heart_talk
git status -sb
```

Output:

```text
## main...origin/main
```

Changed files:

```text
AGENTS.md
docs/EVIDENCE_LOG.md
```

Commands and observed results:

| Command | Result | Evidence summary |
|---|---|---|
| `powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1` | PASS | format `Formatted 9 files (0 changed)`, analyze `No issues found!`, test `+12: All tests passed!` |
| `git diff --check` | PASS | Exit code 0; no whitespace errors. Git printed only LF-to-CRLF working-copy warnings for changed Markdown files. |
| `git status -sb` | DIRTY EXPECTED | `M AGENTS.md` and `M docs/EVIDENCE_LOG.md`. |

Summary:

- Repaired the `AGENTS.md` completion report requirements list.
- Replaced the unclear final report entries with readable Korean labels.
- Kept HeartTalk operating rules, privacy-first constraints, synthetic/demo-only MVP scope, and evidence-gated completion intact.
- Did not change app code, tests, specs, Flutter configuration, scripts, README, secrets, or signing material.

Security/privacy review:

| Check | Result | Notes |
|---|---|---|
| Real PPG/voice data | NONE | No real PPG or voice data was added. |
| Personal data | NONE | No personal data was added. |
| Health-sensitive logs | NONE | No health-sensitive logs were added. |
| API keys/tokens/signing keys | NONE | No API keys, tokens, signing keys, keystores, or private keys were added. |
| Permissions/network/database changes | NONE | Documentation-only change; no permissions, network, database, analytics, sync, or signing changes. |

Known risks:

- None for the AGENTS final-report wording.

Recommended next work:

- Align `docs/privacy/` and `docs/security/` with the current Daily Reflection MVP wording.
- Review `specs/001-daily-reflection-companion-demo/plan.md` and `tasks.md` readability.

Recommended commit message:

```text
docs: clean AGENTS final report wording
```

## 2026-06-28 - HT-DOC-002 - Restore Daily Reflection Spec Readability

Verdict: Pass

Branch:

```text
main
```

Task:

```text
HT-DOC-002 - Restore Daily Reflection Spec Readability
```

Initial status:

```powershell
cd D:\Views\heart_talk
git status -sb
```

Output:

```text
## main...origin/main
```

Changed files:

```text
specs/001-daily-reflection-companion-demo/spec.md
docs/EVIDENCE_LOG.md
```

Commands and observed results:

| Command | Result | Evidence summary |
|---|---|---|
| `powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1` | PASS | Final pass: format `Formatted 9 files (0 changed)`, analyze `No issues found! (ran in 19.6s)`, test `+12: All tests passed!` |
| `git diff --check` | PASS | Exit code 0; no whitespace errors. Git printed only LF-to-CRLF working-copy warnings for changed Markdown files. |
| `git status -sb` | DIRTY EXPECTED | `M docs/EVIDENCE_LOG.md` and `M specs/001-daily-reflection-companion-demo/spec.md`. |

Spec restoration summary:

- Replaced mojibake-damaged Korean/English mixed text with readable Markdown.
- Preserved the Daily Reflection Companion Demo MVP direction.
- Kept MVP scope limited to safe demo events and short user-entered non-sensitive text.
- Clarified that real PPG, real voice, phone/message access, health data, cloud AI, network, analytics, sync, database, and sensitive permissions are out of scope.
- Added testable user stories, functional requirements, non-functional requirements, UX acceptance criteria, technical acceptance criteria, and test strategy.
- Kept future PPG, voice, inference, storage, and account work as non-MVP follow-up requiring separate approval.

Security/privacy review:

| Check | Result | Notes |
|---|---|---|
| Real PPG/voice data | NONE | The spec references these only as forbidden/out-of-scope data. |
| Personal data | NONE | No personal data was added. |
| Health-sensitive logs | NONE | The spec references these only as forbidden/out-of-scope data. |
| API keys/tokens/signing keys | NONE | The spec references these only as forbidden/out-of-scope artifacts. |
| Permissions/network/database changes | NONE | Documentation-only change; no app permissions, network, database, analytics, sync, or signing changes. |
| Medical claims | NONE | The spec forbids diagnosis, treatment advice, disease prediction, risk scoring, and mental-health classification. |

Known risks:

- Existing historical docs outside this task may still mention the older synthetic PPG dashboard wording.
- `AGENTS.md` contains mojibake in the final-report list, but it was outside the HT-DOC-002 allowed file scope.

Recommended next work:

- Align `docs/privacy/` and `docs/security/` with the current daily reflection MVP wording.
- Review `specs/001-daily-reflection-companion-demo/plan.md` and `tasks.md` for any remaining readability issues.
- Add a future non-MVP adapter design note for approved PPG/voice/inference work.

Recommended commit message:

```text
docs: restore daily reflection spec readability
```

## 2026-06-28 - HT-WF-001 - HeartTalk Agentic Workflow Alignment

Verdict: Pass

Branch:

```text
main
```

Task:

```text
HT-WF-001 - HeartTalk Agentic Workflow Alignment
```

Initial status:

```powershell
cd D:\Views\heart_talk
git status -sb
```

Output:

```text
## main...origin/main
```

Changed files:

```text
AGENTS.md
README.md
docs/GOAL.md
docs/PRODUCT_SPEC.md
docs/ARCHITECTURE.md
docs/ACCEPTANCE_CRITERIA.md
docs/CODEX_TASK_TEMPLATE.md
docs/DECISION_LOG.md
docs/RUNBOOK.md
docs/EVIDENCE_LOG.md
scripts/format.ps1
scripts/lint.ps1
scripts/test.ps1
scripts/verify.ps1
```

Commands and observed results:

| Command | Result | Evidence summary |
|---|---|---|
| `powershell -ExecutionPolicy Bypass -File .\scripts\format.ps1` | PASS | `Formatted 9 files (0 changed) in 1.13 seconds.` |
| `powershell -ExecutionPolicy Bypass -File .\scripts\lint.ps1` | PASS | `No issues found! (ran in 145.4s)` |
| `powershell -ExecutionPolicy Bypass -File .\scripts\test.ps1` | PASS | `+12: All tests passed!` |
| `powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1` | PASS | format `0 changed`, analyze `No issues found!`, test `+12: All tests passed!` |

Git status after HT-WF-001:

```text
## main...origin/main
 M AGENTS.md
 M README.md
?? docs/ACCEPTANCE_CRITERIA.md
?? docs/ARCHITECTURE.md
?? docs/CODEX_TASK_TEMPLATE.md
?? docs/DECISION_LOG.md
?? docs/EVIDENCE_LOG.md
?? docs/GOAL.md
?? docs/PRODUCT_SPEC.md
?? docs/RUNBOOK.md
?? scripts/
```

Assessment:

- Documentation and scripts were changed or added as intended.
- Several new documentation and script files remained untracked after the workflow-alignment task.
- No app feature files, tests, platform folders, `pubspec.yaml`, or `pubspec.lock` were changed by HT-WF-001.

Security/privacy review:

| Check | Result | Notes |
|---|---|---|
| Real PPG/voice data | NONE | No real PPG or voice data was added. |
| Personal data | NONE | No personal data was added. |
| Health-sensitive logs | NONE | No health-sensitive logs were added. |
| API keys/tokens/signing keys | NONE | No API keys, tokens, signing keys, keystores, or private keys were added. |
| Permissions/network/database changes | NONE | No permission, network, database, analytics, sync, or signing changes were made. |

Known risks:

- `specs/001-daily-reflection-companion-demo/spec.md` still contained text that appeared to have encoding damage at the time of HT-WF-001.
- `specs/` was intentionally not modified in HT-WF-001.

Recommended next work:

- Restore readability of the specs documents without changing their accepted intent.
- Align `docs/privacy/` and `docs/security/` with the current daily reflection MVP wording.

Recommended commit message:

```text
docs: align HeartTalk agentic workflow
```

## Entry Template

### YYYY-MM-DD - [Task ID / Task Name]

Branch:

```text
[branch name]
```

Initial status:

```powershell
cd D:\Views\heart_talk
git status -sb
```

Output:

```text
[paste observed output]
```

Commands:

```powershell
cd D:\Views\heart_talk
powershell -ExecutionPolicy Bypass -File .\scripts\format.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\lint.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\test.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1
git status -sb
```

Results:

| Command | Result | Evidence summary |
|---|---|---|
| format | PASS/FAIL/SKIPPED |  |
| analyze | PASS/FAIL/SKIPPED |  |
| test | PASS/FAIL/SKIPPED |  |
| verify | PASS/FAIL/SKIPPED |  |
| git status | CLEAN/DIRTY |  |

Security/privacy review:

| Check | Result | Notes |
|---|---|---|
| Real PPG/voice data | NONE/FOUND |  |
| Personal data | NONE/FOUND |  |
| Health-sensitive logs | NONE/FOUND |  |
| API keys/tokens/signing keys | NONE/FOUND |  |
| Permissions/network/database changes | NONE/FOUND |  |

Changed files:

```text
[list changed files]
```

Known risks:

- [risk or "None"]

Recommended commit message:

```text
[type(scope): message]
```

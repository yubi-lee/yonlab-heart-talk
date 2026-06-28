# HeartTalk Acceptance Criteria

## Completion Standard

A HeartTalk task is complete only when the requested scope is implemented and verified with command output evidence. An AI statement such as "completed" is not sufficient.

When `specs/001-daily-reflection-companion-demo/spec.md` conflicts with this summary, the spec remains authoritative.

## Default Quality Gate

Run from the project root:

```powershell
cd D:\Views\heart_talk
powershell -ExecutionPolicy Bypass -File .\scripts\format.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\lint.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\test.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1
git status -sb
```

`scripts/verify.ps1` runs the core gate in this order:

1. Print location.
2. `git status -sb`.
3. `dart format --output=none --set-exit-if-changed .`.
4. `flutter analyze`.
5. `flutter test`.

Android debug build is manual unless the task affects Android build configuration or the task explicitly requests build evidence:

```powershell
cd D:\Views\heart_talk
flutter build apk --debug
```

## HT-MVP-001 Acceptance Matrix

This matrix records the current acceptance state for `HT-MVP-001 - Complete Usable Daily Reflection Demo App`.

| ID | Criterion | Status | Evidence | QA type |
|---|---|---|---|---|
| QA-001 | App clearly presents the Daily Reflection Demo MVP. | Pass | App title and widget tests cover `HeartTalk Daily Reflection Demo`. | Automated + manual smoke |
| QA-002 | Privacy notice is visible before or near input. | Pass | Widget tests assert `Privacy-first demo`; manual QA should confirm notice placement on device. | Automated + manual |
| QA-003 | Demo preset selection works. | Pass | Widget tests select `Work coordination`; repository tests require at least five readable safe demo events. | Automated + manual |
| QA-004 | Manual input flow works. | Pass | Widget tests enter manual text and generate a reflection preview. | Automated + manual |
| QA-005 | Empty input validation works. | Pass | Rule-engine and widget tests assert `Write at least one sentence`. | Automated |
| QA-006 | Reflection card is generated. | Pass | Widget tests assert `Reflection preview` and the result card flow. | Automated + manual |
| QA-007 | Morning briefing or next action is shown after keep. | Pass | Widget tests assert `Morning briefing` and `Next action:` after `Keep for morning`. | Automated + manual |
| QA-008 | Reset/delete returns the UI to a safe empty state. | Pass | Widget tests assert reset/delete clears preview, kept state, and briefing. | Automated + manual |
| QA-009 | Session-only keep policy is documented and implemented. | Pass | UI copy says `Kept in this session only.`; DEC-010 records session-only persistence. | Automated + docs |
| QA-010 | No real PPG, voice, contacts, messages, location, health data, cloud AI, network, database, or sensitive permission path is added. | Pass | Product docs, implementation scope, tests, and forbidden-path review confirm no platform/dependency changes. | Docs + inspection |
| QA-011 | No medical diagnosis, treatment, disease prediction, risk scoring, or mental-health status classification copy appears. | Pass | Rule-engine tests check forbidden diagnostic copy is absent. | Automated + inspection |
| QA-012 | Automated tests and debug APK build evidence are recorded. | Pass | `docs/EVIDENCE_LOG.md` contains HT-MVP-001 command evidence; HT-QA-001 adds acceptance evidence. | Evidence log |

## Manual QA Checklist

Run this checklist on an Android emulator or physical Android device when available:

1. Launch the app with `flutter run`.
2. Confirm the title says `HeartTalk Daily Reflection Demo`.
3. Confirm the privacy notice says the MVP does not read calls, SMS, messengers, notifications, voice, PPG, contacts, location, or health data.
4. Select the `Work coordination` demo preset and confirm a reflection preview appears.
5. Confirm the source line says `Source: Demo data`.
6. Tap `Keep for morning` and confirm `Morning briefing` and `Next action:` appear.
7. Tap `Reset / Delete` and confirm the preview, kept message, and morning briefing are cleared.
8. Enter one short non-sensitive manual note and tap `Generate reflection`.
9. Confirm the source line says `Source: Manual text`.
10. Clear the input and tap `Generate reflection`; confirm empty validation appears.
11. Confirm no permission prompt appears during the flow.
12. Confirm the copy remains gentle and non-diagnostic.

If no emulator or device is available, mark device/manual run as `Pending` in the evidence log and rely on `flutter build apk --debug` plus automated tests for build and behavior evidence.

## Android Manual QA Evidence Status

Current status for `HT-QA-002 - Run Android Manual QA or Prepare Device Evidence Path`:

| Item | Status | Evidence |
|---|---|---|
| Android toolchain | Pass | `flutter doctor -v` reports Android SDK 37.0.0, emulator 36.6.11.0, build-tools 37.0.0, Java 21, and accepted Android licenses. |
| Connected Android device | Pending | `flutter devices` lists Windows, Chrome, and Edge only. |
| Available Android emulator | Pending | `flutter emulators` reports `No emulators available.` |
| Android debug APK build | Pass | `flutter build apk --debug` builds `build\app\outputs\flutter-apk\app-debug.apk`. |
| Android manual `flutter run` QA | Pending | No Android emulator or physical Android device is currently available. |

Do not mark Android manual QA as `Pass` until `flutter run -d <android-device-id>` or an installed APK has been exercised on an Android emulator or physical Android device and the checklist above has been completed.

Current status for `HT-QA-003 - Execute Android Manual QA Evidence`:

| Item | Status | Evidence |
|---|---|---|
| Android target available | Pass | `flutter devices` listed physical device `SM F956N` and emulator `emulator-5554`; ADB listed both targets. |
| Android manual app launch | Pass | `flutter run -d emulator-5554` launched the app on emulator; `flutter run -d R3CX70NHJRN --no-resident` launched the app on physical device. |
| Manual QA checklist | Pass with notes | Emulator visual QA confirmed title, privacy notice, demo preset, reflection preview/card, keep, morning briefing, next action, reset/delete, manual input, and empty validation. Physical-device UIAutomator text dumps confirmed generated state and session-only relaunch behavior. |
| Session-only persistence | Pass | After `adb shell am force-stop com.example.heart_talk` and launcher relaunch on `SM F956N`, UIAutomator text returned to initial/privacy/demo-preset state and no reflection/morning/kept state remained. |
| Screenshot evidence | Pass with notes | Emulator screenshots were captured for visual inspection outside the repository; physical-device verification used UIAutomator XML text dumps to avoid collecting personal-device screenshots. |

Android manual QA is now `Pass with notes`: the full visible MVP flow was exercised on Android, with emulator visual evidence and physical-device text evidence. The only note is that the emulator became ADB-offline before the final session-only relaunch check, so that final check was repeated on the physical Android target.

## Privacy and Security Documentation Gate

Current status for `HT-PRIV-001 - Align Privacy and Security Docs With Daily Reflection MVP`:

| Item | Status | Evidence |
|---|---|---|
| Current MVP data boundary | Pass | `docs/privacy/data-flow-and-retention.md` documents demo/manual input only, local deterministic processing, and session-only in-memory state. |
| Forbidden data and permissions | Pass | `docs/privacy/data-flow-and-retention.md` and `docs/security/threat-model.md` forbid real PPG, real voice, personal data, health-sensitive logs, sensitive permissions, network/cloud AI, analytics, sync, DBs, API keys, and signing keys. |
| QA evidence handling | Pass | `docs/privacy/data-flow-and-retention.md`, `docs/security/threat-model.md`, and `docs/RUNBOOK.md` require screenshot/XML review and prohibit storing personal or sensitive QA artifacts. |
| Future review triggers | Pass | Privacy/security docs require separate review before PPG, voice, inference, durable storage, encryption, permissions, network/cloud, analytics, crash reporting, signing, or release-secret work. |

Privacy/security acceptance is documentation evidence for the current MVP boundary. It is not approval to implement real PPG, voice, health data, storage, network, cloud AI, analytics, permissions, or signing changes.

## Non-MVP / Out of Scope

The following remain out of scope for the current MVP and require a separate approved spec before implementation:

- Real PPG capture, raw PPG files, or biometric signal processing
- Real voice recording, transcript import, or audio analysis
- Phone call, SMS, messenger, notification, contact, location, or health-data access
- Camera, microphone, contacts, call log, SMS, location, notification access, Health Connect, or background sensor permissions
- Cloud AI, external APIs, analytics, sync, account systems, or remote storage
- Local database or durable storage of raw manual input
- Medical diagnosis, treatment advice, disease prediction, mental-health classification, emergency guidance, or risk scoring
- Android/iOS release signing or production secret handling

## Failure Criteria

A task must not be reported as complete if:

- Format, analyze, or test fails and the failure is in scope.
- Verification commands were not run and no clear skip reason is documented.
- App code outside the allowed file list was changed.
- Real sensitive data, credentials, signing material, or health-sensitive logs were introduced.
- A doc contradicts `specs/001-daily-reflection-companion-demo/spec.md` without explicitly marking the spec as authoritative.

## Required Final Report

Codex final reports for HeartTalk must be written in Korean and include:

1. 작업 전 상태
2. 변경 파일
3. 구현/수정 내용
4. 실행한 명령
5. 검증 결과
6. 보안/개인정보 점검
7. 남은 리스크
8. 다음 권장 작업
9. 커밋 권장 여부

## HT-COMPANION-001 Acceptance Matrix

| ID | Criterion | Status | Evidence |
|---|---|---|---|
| COMP-001 | User can turn local memory consent on/off. | Implemented | Widget test covers `localMemoryConsentSwitch`. |
| COMP-002 | Required roles are visible: 친구, 연인, 가족, 부모, 코치, 선생님, 경청자, 사용자 지정. | Implemented | Domain and widget tests cover role labels. |
| COMP-003 | User can enter approved profile, relationship, and todo memory. | Implemented | Widget test enters profile/person/todo memory. |
| COMP-004 | Consent OFF prevents local memory persistence. | Implemented | Repository test sanitizes snapshot when disabled. |
| COMP-005 | Consent ON persists and restores approved local memory after restart. | Implemented | SharedPreferences repository and widget restart tests. |
| COMP-006 | User can view stored information in `내 기억`. | Implemented | Widget tests assert role, profile, todo, and growth text. |
| COMP-007 | Full local memory reset clears stored data. | Implemented | Repository and widget reset tests. |
| COMP-008 | Growth level is deterministic from approved local memory. | Implemented | `GrowthCalculator` tests cover level 0 and accumulated memory. |
| COMP-009 | Role + growth produces Korean companion messages. | Implemented | `CompanionMessageService` tests cover role differences. |
| COMP-010 | No server, cloud AI, analytics, sync, account, sensitive permission, or diagnostic copy added. | Pending final verification | To be confirmed in final evidence entry. |

## HT-DESIGN-ALIGN-001 Acceptance Matrix

| ID | Criterion | Status | Evidence |
|---|---|---|---|
| DESIGN-001 | `Design.md` is reviewed and summarized. | Done | `docs/DESIGN_ALIGNMENT.md` section 1. |
| DESIGN-002 | Current HT-COMPANION-001 implementation is compared against `Design.md`. | Done | `docs/DESIGN_ALIGNMENT.md` gap matrix. |
| DESIGN-003 | Conflicts between Design.md and HeartTalk product direction are documented. | Done | B2B operations dashboard framing is marked as conflict. |
| DESIGN-004 | Role safety constraints are documented. | Done | Product spec and companion spec state role modes are tone/persona only. |
| DESIGN-005 | Privacy/security constraints remain unchanged. | Done | No server/cloud AI/analytics/sync/account/sensitive permission policy remains in docs/spec. |
| DESIGN-006 | Follow-up milestone priority is documented. | Done | `HT-DESIGN-QA-001` is recommended first. |
| DESIGN-007 | No app implementation files are changed by design alignment. | Pending final status | Confirm with `git status -sb` and diff review. |
| DESIGN-008 | Verification gate passes after docs/spec updates. | Pending final verification | Run `powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1`. |

## HT-DESIGN-QA-001 Acceptance Matrix

| ID | Criterion | Status | Evidence |
|---|---|---|---|
| DQA-AC-001 | HeartTalk has an Android Design/UX manual QA checklist for `HT-COMPANION-001`. | Documented | `docs/qa/android-design-qa-checklist.md` defines purpose, environment, preparation, prohibited findings, scenario table, evidence criteria, verdict rules, known notes, and blocking criteria. |
| DQA-AC-002 | The checklist covers role-based local memory companion flows. | Documented | Checklist scenarios cover first launch, local memory consent OFF/ON, profile, role, custom role, daily note, people, todo, restart restore, `내 기억`, full reset, restart after reset, role messages, growth, privacy copy, Korean copy, and Android readability. |
| DQA-AC-003 | The checklist includes safety criteria for lover, parent, role, and growth copy. | Documented | Prohibited findings and scenarios DQA-018, DQA-020, and DQA-024 define fail criteria for dependency, sexual/obsessive language, control, shame, and diagnostic framing. |
| DQA-AC-004 | The checklist protects privacy/security evidence handling. | Documented | Evidence criteria require synthetic inputs, screenshot/XML review, no personal data in evidence, and no absolute safety claims. |
| DQA-AC-005 | The Runbook references the Android Design/UX QA flow. | Documented | `docs/RUNBOOK.md` includes `HT-DESIGN-QA-001 Android Design/UX Manual QA`. |
| DQA-AC-006 | App code, tests, platform files, specs, dependencies, and local exclude settings are not modified by this task. | Pending final verification | Confirm with `git status -sb` and changed-file review. |
| DQA-AC-007 | Verification commands pass or failures/skips are recorded. | Pending final verification | Run `powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1`, `git diff --check`, and `git status -sb`. |

Manual Android execution of this checklist is not required for `HT-DESIGN-QA-001`; the deliverable is the checklist and documentation wiring. Actual device execution should be recorded as a later QA evidence task before or during `HT-INSIGHT-001` readiness review.

## HT-INSIGHT-001 Acceptance Matrix

| ID | Criterion | Status | Evidence |
|---|---|---|---|
| INSIGHT-001 | `LocalInsightService` generates fallback insight for empty or consent-off memory. | Implemented | `local_insight_service_test.dart` covers empty snapshot and `localMemoryEnabled=false`. |
| INSIGHT-002 | Approved local memory can produce pattern insight, recurring signals, tomorrow hint, curiosity question, tiny mission, and role message. | Implemented | Service tests cover reflection entries, recurring keywords, todos, and person memory. |
| INSIGHT-003 | Role-specific insight copy differs while staying safe. | Implemented | Service tests cover friend, coach, listener, lover, and parent wording constraints. |
| INSIGHT-004 | UI exposes `오늘의 인사이트` with fallback and todo-based tiny mission behavior. | Implemented | `daily_reflection_screen_test.dart` covers fallback display and todo memory update. |
| INSIGHT-005 | No new dependency, platform setting, network, Cloud AI, analytics, sync, account, or sensitive permission is added. | Pending final verification | Confirm with changed-file review and final `git status -sb`. |
| INSIGHT-006 | Verification gate passes after implementation. | Pending final verification | Run `powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1`, `git diff --check`, and `git status -sb`. |
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

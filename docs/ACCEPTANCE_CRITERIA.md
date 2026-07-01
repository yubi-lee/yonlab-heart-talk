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
| ONB-001 | First-run onboarding explains local storage, role choice, local insights, morning brief, synthetic demo data, and memory deletion. | Pass with notes | Widget tests cover clean launch, dismissal, help reopening, and restart persistence; SM F956N physical QA confirmed display, dismissal, non-auto reappearance, help reopening, and readable Korean copy. | Automated + docs + physical QA |

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

## HT-100DAY-SIM-001 Acceptance Matrix

| ID | Criterion | Status | Evidence |
|---|---|---|---|
| SIM-001 | The app exposes a visible `100일 성장 체험하기` control in the existing screen. | Implemented | Widget test covers the simulation button and panel. |
| SIM-002 | At least eight Korean scene presets are available. | Implemented | `synthetic_growth_simulation_service_test.dart` checks preset count and Korean names. |
| SIM-003 | The generated snapshot contains 100 synthetic days of memory with richer growth state. | Implemented | Service test checks day count, growth level 5, people, todos, and recurring keywords. |
| SIM-004 | The generated snapshot does not look like real phone numbers, emails, or URLs. | Implemented | Service test scans synthetic snapshot strings for sensitive patterns. |
| SIM-005 | Simulation results feed the existing growth, insight, and morning brief logic. | Implemented | Application tests confirm non-fallback insight and morning brief from the synthetic snapshot. |
| SIM-006 | Simulation memory can be cleared without touching the real local memory snapshot. | Implemented | Repository and widget tests cover separate clear behavior and fallback return. |
| SIM-007 | The feature remains local-only and does not add dependencies or platform behavior. | Implemented | Confirmed by changed-file review and final `git status -sb`. |
| SIM-008 | Verification commands pass or any failures are documented. | Implemented | `dart format`, `flutter analyze`, `flutter test`, `powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1`, `git diff --check`, and `git status -sb` completed with no failures. |

## Failure Criteria

A task must not be reported as complete if:

- Format, analyze, or test fails and the failure is in scope.
- Verification commands were not run and no clear skip reason is documented.
- App code outside the allowed file list was changed.
- Real sensitive data, credentials, signing material, or health-sensitive logs were introduced.
- A doc contradicts `specs/001-daily-reflection-companion-demo/spec.md` without explicitly marking the spec as authoritative.

## Required Final Report

Codex final reports for HeartTalk must be written in Korean and include:

1. ?묒뾽 ???곹깭
2. 蹂寃??뚯씪
3. 援ы쁽/?섏젙 ?댁슜
4. ?ㅽ뻾??紐낅졊
5. 寃利?寃곌낵
6. 蹂댁븞/媛쒖씤?뺣낫 ?먭?
7. ?⑥? 由ъ뒪??
8. ?ㅼ쓬 沅뚯옣 ?묒뾽
9. 而ㅻ컠 沅뚯옣 ?щ?

## HT-COMPANION-001 Acceptance Matrix

| ID | Criterion | Status | Evidence |
|---|---|---|---|
| COMP-001 | User can turn local memory consent on/off. | Implemented | Widget test covers `localMemoryConsentSwitch`. |
| COMP-002 | Required roles are visible: 移쒓뎄, ?곗씤, 媛議? 遺紐? 肄붿튂, ?좎깮?? 寃쎌껌?? ?ъ슜??吏?? | Implemented | Domain and widget tests cover role labels. |
| COMP-003 | User can enter approved profile, relationship, and todo memory. | Implemented | Widget test enters profile/person/todo memory. |
| COMP-004 | Consent OFF prevents local memory persistence. | Implemented | Repository test sanitizes snapshot when disabled. |
| COMP-005 | Consent ON persists and restores approved local memory after restart. | Implemented | SharedPreferences repository and widget restart tests. |
| COMP-006 | User can view stored information in `??湲곗뼲`. | Implemented | Widget tests assert role, profile, todo, and growth text. |
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
| DQA-AC-002 | The checklist covers role-based local memory companion flows. | Documented | Checklist scenarios cover first launch, local memory consent OFF/ON, profile, role, custom role, daily note, people, todo, restart restore, `??湲곗뼲`, full reset, restart after reset, role messages, growth, privacy copy, Korean copy, and Android readability. |
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
| INSIGHT-004 | UI exposes `?ㅻ뒛???몄궗?댄듃` with fallback and todo-based tiny mission behavior. | Implemented | `daily_reflection_screen_test.dart` covers fallback display and todo memory update. |
| INSIGHT-005 | No new dependency, platform setting, network, Cloud AI, analytics, sync, account, or sensitive permission is added. | Pending final verification | Confirm with changed-file review and final `git status -sb`. |
| INSIGHT-006 | Verification gate passes after implementation. | Pending final verification | Run `powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1`, `git diff --check`, and `git status -sb`. |

## HT-ANDROID-QA-004 Android Manual QA Status

Current status for `HT-ANDROID-QA-004 - Execute Android Manual QA for Companion + Insight MVP`:

| Item | Status | Evidence |
|---|---|---|
| Android target available | Pass | `flutter devices` listed physical device `SM F956N` / `R3CX70NHJRN`; SDK ADB listed it as `device`. |
| Latest Android APK build/install | Blocked | `flutter build apk --debug` and `flutter build apk --debug --no-pub` failed at `:shared_preferences_android:compileDebugKotlin` with Kotlin cache/root mismatch under `build\shared_preferences_android`. |
| Existing APK launch | Partial | Existing `build\app\outputs\flutter-apk\app-debug.apk` installed and launched, but did not expose current local memory/role/insight UI. |
| Companion + insight manual checklist | Blocked | Cannot mark Pass until the current source APK is built/installed and local memory consent, roles, saved memory restore/reset, and insight/tiny mission UI are exercised on Android. |
| Korean Design/UX QA | Blocked with risk | Android-visible QA is still required. Source inspection shows mojibake risk in the local memory/insight UI strings, so this must be checked after the build blocker is removed. |

Do not treat the partial launch of the older APK as acceptance for `HT-COMPANION-001` + `HT-INSIGHT-001`. The next acceptance gate is a successful latest APK build/install followed by the Android manual checklist.

## HT-ANDROID-QA-004R Resume Status

Updated status after the resumed Android QA run:

| Item | Status | Evidence |
|---|---|---|
| Latest APK build path | Partial pass | Direct build from `D:\Views\heart_talk` still failed, but a temporary `C:` copy of the same source built successfully and produced a latest debug APK. |
| Android launch of latest Companion + Insight APK | Pass | The latest APK built from the `C:` copy installed on `emulator-5554` and launched. |
| Consent OFF fallback insight | Pass | Android showed fallback insight with Korean copy and no personalized memory use while consent was OFF. |
| Consent ON local memory save | Pass | Android showed saved profile, role, todo, person memory, and deterministic growth level changes. |
| Deterministic local insight after memory save | Pass | Android showed recurring-signal, tomorrow-hint, curiosity-question, tiny-mission, and role-aware Korean copy. |
| Reflection keep flow | Pass | `Work coordination` plus `Keep for morning` produced `Morning briefing` on Android. |
| Clear all local memory | Pass in-session | Android returned `??湲곗뼲` fields to empty defaults after tapping `Clear all local memory`. |
| Restart restore after saved memory | Fail / Blocker | Emulator relaunch after saved local memory repeatedly surfaced `heart_talk isn't responding`, so restore acceptance is still blocked. |

Do not mark `HT-ANDROID-QA-004` complete until restart restore is validated on Android without ANR. The next clean acceptance path is either a successful physical-device rerun or a focused fix for the relaunch ANR.

## HT-PHYSICAL-RESTORE-QA-001 Physical Restore Status

Updated status after the physical Android restore QA run:

| Item | Status | Evidence |
|---|---|---|
| Fresh latest APK build via same-drive workaround | Pass | A fresh temporary `C:` copy of the current source built successfully and produced `app-debug.apk`. |
| Physical Android install and launch | Pass | The fresh APK installed on `SM F956N` / `R3CX70NHJRN` and launched with `am start -W`. |
| Consent ON + local memory save | Pass | Physical Android showed consent ON, role `肄붿튂`, saved profile, growth `2`, people/todos, and personalized local insight. |
| Restart restore after saved memory | Pass | `force-stop` plus relaunch restored role, profile, growth, people/todos, and personalized insight on physical Android without ANR. |
| Full reset + relaunch fallback | Pass | `Clear all local memory` plus relaunch returned the app to `Role: 移쒓뎄`, `Profile: -`, `Growth level: 0`, empty people/todos, and fallback insight. |
| Emulator ANR isolation | Note | The previous restart ANR remained on the emulator path only and did not reproduce on the physical target. |
| Korean product polish | Implemented in source/tests | Korean-first labels now cover `湲곌린 ?덉뿉 湲곗뼲?섍린`, `湲곗뼲 ??ν븯湲?, `??λ맂 湲곗뼲 紐⑤몢 吏?곌린`, `?④퍡 ?뚯븘媛???④퀎`, `?ㅻ뒛???몄궗?댄듃`, `?댁씪???ㅻ쭏由?, and `?묒? 誘몄뀡`. Android-visible recheck should still confirm final readability on device. |

`HT-ANDROID-QA-004` acceptance is now `Pass with notes` for the current Companion + Insight MVP because the physical-device restart restore gate passed. The remaining emulator restart issue is no longer the blocking product gate for this milestone.

## HT-MORNING-001 Acceptance Matrix

| ID | Criterion | Status | Evidence |
|---|---|---|---|
| MORNING-001 | Empty or reset state shows a fallback `?ㅻ뒛 ?쒖옉?섍린` card. | Implemented | `morning_brief_service_test.dart` covers empty snapshot fallback; widget test covers visible start card. |
| MORNING-002 | Consent OFF must not create a personalized morning brief from saved memory-like fields. | Implemented | `morning_brief_service_test.dart` covers consent-off fallback and verifies no todo/reflection personalization leaks into output. |
| MORNING-003 | Consent ON plus saved todo or reflection context can generate a personalized morning brief. | Implemented | Service tests cover todo-based first step, reflection carry-over, and tiny-mission fallback. |
| MORNING-004 | Role tone changes the morning encouragement safely for coach, listener, lover, and parent. | Implemented | Service tests cover coach/listener divergence and unsafe-wording exclusions for lover/parent copy. |
| MORNING-005 | UI exposes `?ㅻ뒛 ?쒖옉?섍린` without breaking the existing `Keep for morning -> ?댁씪 ?쒖옉 硫붾え` flow. | Implemented | `daily_reflection_screen_test.dart` covers fallback and personalized morning-brief card while older keep/preview tests remain in place. |
| MORNING-006 | No new dependency, platform setting, background scheduler, notification, network, or Cloud AI path is added. | Pending final verification | Confirm with changed-file review and final `git status -sb`. |
| MORNING-007 | Verification gate passes after implementation. | Pending final verification | Run `powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1`, `git diff --check`, and `git status -sb`. |

## HT-MORNING-QA-001 Android Manual QA Status

Current status for `HT-MORNING-QA-001 - Android QA for Morning Brief / Today Start Guide`:

| Item | Status | Evidence |
|---|---|---|
| Latest main source status | Pass | Physical rerun started from clean `main` before doc updates and used the latest morning + memory-management baseline. |
| Latest debug APK build from `D:\Views\heart_talk` | Pass | `flutter build apk --debug` succeeded and produced `build\app\outputs\flutter-apk\app-debug.apk`. |
| Requested physical Android target visibility | Pass | `adb devices -l` showed `SM F956N / R3CX70NHJRN`. |
| APK install and launch on physical device | Pass | `adb install -r` succeeded and HeartTalk launched on the requested device. |
| Morning brief Android-visible validation | Pass | On-device screenshots confirmed personalized `오늘 시작하기`, `오늘의 질문`, first-step, and coach-tone encouragement after local-memory save. |
| Restart restore on physical device | Pass | After `adb shell am force-stop com.example.heart_talk` and relaunch, the saved snapshot and personalized morning brief were restored. |
| Full reset fallback on physical device | Pass | In-app `저장된 기억 모두 지우기` cleared `shared_preferences`; relaunch returned to fallback morning-brief copy with consent OFF and default friend role. |
| Korean UX/readability check on physical device | Pass with notes | Core labels remained Korean and readable. The only awkward visible strings came from synthetic ADB text injection during QA, not from shipped UI copy. |

`HT-MORNING-QA-001` is complete from the physical-device rerun on `SM F956N / R3CX70NHJRN`.

## HT-MEMORY-MANAGE-001 Acceptance Matrix

| ID | Criterion | Status | Evidence |
|---|---|---|---|
| MEM-001 | User can inspect stored categories for 내 소개, 기억할 사람, 내일 할 일, and 하루 기록. | Implemented | daily_reflection_screen_test.dart asserts category sections and counts after save + keep flow. |
| MEM-002 | Consent OFF hides stored category details and shows a fallback management message. | Implemented | Widget test covers consent toggle OFF after save and asserts fallback management copy. |
| MEM-003 | User can edit at least one stored memory item. | Implemented | Widget test edits a todo title; service test covers profile and person/todo update logic. |
| MEM-004 | User can delete at least two kinds of stored memory items individually. | Implemented | Widget test deletes person and reflection items; service test covers person, todo, and reflection delete behavior. |
| MEM-005 | Growth, local insight, and morning brief re-derive from the updated snapshot after edit/delete. | Implemented | local_memory_management_service_test.dart verifies derived growth/insight/morning-brief changes after update/delete. |
| MEM-006 | Full reset behavior remains available. | Implemented | Existing widget test still covers 저장된 기억 모두 지우기 and empty summary state. |
| MEM-007 | No new dependency, platform setting, network, Cloud AI, analytics, sync, account, or sensitive permission is added. | Pending final verification | Confirm with changed-file review and final verification commands. |
| MEM-008 | Verification gate passes after implementation. | Pending final verification | Run powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1, git diff --check, and git status -sb. |

## HT-ROLE-UX-001 Acceptance Matrix

| ID | Criterion | Status | Evidence |
|---|---|---|---|
| ROLEUX-001 | Friend, coach, listener, and teacher role messages differ in a user-visible Korean way. | Implemented | `companion_models_test.dart`, `local_insight_service_test.dart`, and `morning_brief_service_test.dart` cover divergence across companion, insight, and morning flows. |
| ROLEUX-002 | Coach role emphasizes a first action and execution-oriented next step. | Implemented | Insight and morning-brief service tests assert coach-specific question and first-step wording. |
| ROLEUX-003 | Listener role emphasizes short reflection and question-centered prompts. | Implemented | Insight and morning-brief service tests assert listener-specific question and tiny-mission wording. |
| ROLEUX-004 | Teacher role emphasizes calm structure and step-by-step organization. | Implemented | Companion, insight, and morning-brief tests assert structured teacher wording such as `정리`, `차근차근`, and `순서`. |
| ROLEUX-005 | Custom role reflects a safe tone boundary without replaying raw unsafe text. | Implemented | Service/domain tests assert custom role name plus normalized tone wording while excluding unsafe terms. |
| ROLEUX-006 | Lover role avoids obsession, sexual language, and dependency-inducing copy. | Implemented | Companion, insight, and morning-brief tests explicitly exclude unsafe lover wording. |
| ROLEUX-007 | Parent role avoids control, blame, shame, and infantilizing copy. | Implemented | Morning-brief and existing role-safety tests keep parent wording non-controlling and non-shaming. |
| ROLEUX-008 | The current selected role is clearly visible in the UI in Korean. | Implemented | `daily_reflection_screen_test.dart` asserts the role context line and coach-role update. |
| ROLEUX-009 | Existing local memory, insight, morning brief, and memory management flows continue to pass. | Implemented | Targeted Flutter test run passed across domain, application, and presentation layers. |
| ROLEUX-010 | No new dependency, platform setting, network, Cloud AI, analytics, sync, account, or sensitive permission is added. | Pass | Changed-file review stayed inside `lib/features/daily_reflection/**`, `test/features/daily_reflection/**`, `docs/**`, and `specs/006-role-ux-polish/spec.md`. No platform, permission, or dependency file changed. |
| ROLEUX-011 | Verification gate passes after implementation. | Pass | `powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1` passed after one formatter rerun. `git diff --check` reported no whitespace errors. |

## HT-SESSION-FLOW-QA-001 Physical Android QA Status

Updated status after the remaining physical rerun:

| Item | Status | Evidence |
|---|---|---|
| Latest APK build/install on `SM F956N` | Pass | `flutter build apk --debug` rebuilt `build\app\outputs\flutter-apk\app-debug.apk`, and `adb install -r` returned `Success`. |
| Simplified session-flow section order on device | Pass | The physical rerun preserved the intended order, with `오늘의 인사이트` remaining above `오늘 시작하기`. |
| `내 기억 관리` expand/collapse interaction | Pass | `저장된 기억 펼쳐보기` was collapsed by default and expanded successfully on tap. |
| Save -> force-stop -> relaunch restore | Pass | Relaunch restored role, profile presence, growth state, insight, and morning-brief surfaces. |
| Full reset -> force-stop -> relaunch fallback | Pass | Relaunch after `저장된 기억 모두 지우기` returned to default friend role, empty profile, stage 0 growth, and fallback insight/morning brief. |
| Korean UX/readability follow-up | Pass with notes | Core labels stayed Korean-first and readable on `SM F956N`. QA reporting intentionally omitted copying a pre-existing saved profile string observed on-device. |

`HT-SESSION-FLOW-QA-001` is accepted as `Pass with notes` after the physical-device rerun closed the remaining restore/reset blockers.

## HT-100DAY-SIM-QA-001 Physical Android QA Note

| Area | Status | Evidence |
|---|---|---|
| 100일 성장 체험 UI 노출 | Pass | SM F956N에서 100일 성장 체험하기 버튼과 시뮬레이션 안내 문구를 확인했다. |
| 씬 선택과 풍부화 | Pass | 창업자 바쁜 하루, 회사 업무 스트레스, 가족과의 대화 씬에서 오늘 시작하기, 오늘의 질문, 작은 미션, 역할 메시지가 서로 다르게 표시되었다. |
| force-stop/relaunch 유지 | Pass | 앱 강제 종료 후 다시 열었을 때 선택한 시뮬레이션 씬과 풍부한 인사이트/오늘 시작하기가 유지되었다. |
| 시뮬레이션 기억 지우기 | Pass | 시뮬레이션 기억 지우기 후 다시 열면 아직 체험 중인 씬이 없어요. fallback 상태로 돌아갔다. |
| 실제 memory 분리 | Pass | 시뮬레이션 기억은 실사용 local memory와 섞이지 않았고, 안내 문구로 가상 데이터임이 확인되었다. |
| 한국어 UX | Pass with notes | 전체 문구는 한국어 중심이었고, 영어 라벨 재노출은 없었다. |


## HT-ONBOARDING-001 Acceptance Evidence

Current implementation status for the first-run onboarding slice:

| Item | Status | Evidence |
|---|---|---|
| Clean-launch onboarding visibility | Pass | Widget test covers the onboarding card on first launch. |
| Local storage policy explanation | Pass | Onboarding copy states that approved memory is stored only on the device. |
| Role-choice explanation | Pass | Onboarding copy explains that the companion role can be changed. |
| Synthetic demo explanation | Pass | Onboarding copy states that `100일 성장 체험` uses synthetic demo data. |
| Dismiss and restart persistence | Pass | Widget test covers `시작하기` / `이해했어요` dismissal and the restart-persistence flag. |
| Help reopening | Pass | Widget test covers the `도움말 다시 보기` action. |

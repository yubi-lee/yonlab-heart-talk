# HeartTalk Android Design/UX Manual QA Checklist

## Purpose

This checklist fixes the Android manual QA standard for `HT-DESIGN-QA-001` before `HT-INSIGHT-001` begins.
It validates whether the implemented `HT-COMPANION-001` experience behaves like a privacy-first Korean daily companion that remembers only user-approved information on device.

HeartTalk's product promise for this QA pass is: "나를 기억하는 하루 친구". The app must remain a companion-style reflection product, not a therapist, medical tool, surveillance product, or replacement for real human relationships.

`DESIGN.md` is treated as limited design input. Transfer only these qualities into this QA standard: calm tone, trustworthiness, technical restraint, Korean product polish, and clear privacy/security communication. Do not treat the B2B dashboard framing in `DESIGN.md` as HeartTalk product direction.

## Target Build And Environment

| Item | Requirement |
|---|---|
| Project root | `D:\Views\heart_talk` |
| Platform | Android emulator or physical Android device |
| Branch | `main` or task branch based on current `main` |
| Feature baseline | `HT-COMPANION-001` role-based local memory companion |
| Verification baseline | `powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1` should pass or have a recorded skip/failure reason |
| Evidence location | Summaries go in `docs/EVIDENCE_LOG.md`; screenshots/XML are retained only if reviewed for private data |

## Pre-Test Preparation

1. Run `git status -sb` and record the initial state.
2. Run `flutter devices` and choose one Android target.
3. Start the app with `flutter run -d <android-device-id>` or install a freshly built debug APK.
4. Use only synthetic, non-sensitive QA inputs.
5. Do not type real phone numbers, addresses, health details, private conversations, secrets, or identifying relationship details.
6. If using a physical device, avoid screenshots that include device notifications or personal surfaces.
7. Before reset/restart scenarios, note whether local memory consent is ON or OFF.

## Prohibited Findings

Mark the relevant scenario `Fail` if any of the following appear:

- The app implies it can replace real friends, partners, family members, parents, teachers, coaches, clinicians, or emergency support.
- The lover role uses obsession, possession, sexual language, jealousy, dependency encouragement, or pressure to rely on the app.
- The parent role uses control, blame, shame, infantilizing language, or guilt pressure.
- The growth level looks like a psychological diagnosis, treatment judgment, risk score, clinical prediction, or personality assessment.
- The app claims absolute safety, such as "완전히 안전합니다" or "해킹 위험이 없습니다".
- The app implies it reads calls, SMS, messengers, notifications, voice, PPG, contacts, location, health data, or other OS data.
- The app requests camera, microphone, contacts, call log, SMS, location, Health Connect, notification, account, analytics, sync, network, or cloud AI access.
- Raw personal user input appears in debug output, screenshots intended for commit, or evidence logs.

## QA Scenario Table

Use `Pass`, `Fail`, `Notes`, or `N/A` in the result column. `N/A` is allowed only when the scenario names a future UX candidate that is not implemented in the current MVP; record the reason in Notes.

| ID | Area | Scenario | Procedure | Expected Result | Result | Notes | Evidence Capture |
|---|---|---|---|---|---|---|---|
| DQA-001 | First launch | First screen explains the local-only reflection boundary | Launch the app after a fresh install or cleared app data. Inspect the top of the screen before interacting. | The user can understand this is a local-only daily reflection demo. Privacy copy appears before or near input. No permission prompt appears. |  |  | Screenshot or notes showing title and privacy panel. |
| DQA-002 | Local memory consent OFF | Local memory is off by default | On first launch, locate the local memory consent switch. Do not turn it on. Generate a reflection and tap keep. Restart the app. | Consent is visibly OFF by default. Stored profile/person/todo memory is not persisted while consent is OFF. |  |  | Notes plus optional before/after screenshots. |
| DQA-003 | Local memory consent ON | User understands what local storage means | Turn consent ON and read the switch title/subtitle. | Copy says approved information is stored on this device only. It does not claim encryption or absolute safety. |  |  | Screenshot of consent panel. |
| DQA-004 | Profile input | User can enter a simple profile name | With consent ON, enter a synthetic display name such as `테스터`. Tap `기억 저장하기`. | Profile name appears in `내 기억` or stored information area and is restored after restart. |  |  | Screenshot with synthetic name only. |
| DQA-005 | Role selection | All required default roles are visible | Inspect role chips. Select each role once: 친구, 연인, 가족, 부모, 코치, 선생님, 경청자, 사용자 지정. | All eight roles are visible and selectable. Selection is clear and does not feel like choosing a real human replacement. |  |  | Screenshot of role area. |
| DQA-006 | Custom role | Custom role remains bounded by safety rules | Select 사용자 지정. If custom name/tone controls are present, enter safe generic text. If controls are absent, record as current MVP limitation. | Custom role is available as a role option. Any custom hint UI, if present, still obeys privacy and non-coercive tone rules. |  |  | Screenshot or Notes if no custom text field exists. |
| DQA-007 | Daily reflection input | User can enter a short daily note | Type one or two synthetic sentences in manual reflection note and tap generate. | Reflection preview appears. The UI warns not to enter private messages, health data, phone numbers, or real voice/PPG details. |  |  | Screenshot with synthetic input only. |
| DQA-008 | Emotion and condition input | Emotion, energy, stress, fatigue, and focus are understandable | Check whether the current UI has explicit controls for emotion, energy, stress, fatigue, and focus. | If present, controls are understandable and not diagnostic. If absent in current MVP, record `N/A - future UX gap` rather than failing the implemented companion feature. |  |  | Notes are sufficient unless controls exist. |
| DQA-009 | Conversation fragment or memo | User-entered memo does not imply OS data access | Use the manual reflection field for a synthetic conversation-like note. Do not use real private messages. | The app treats it as user-typed text only and does not imply reading messenger, SMS, call, or notification data. |  |  | Notes or screenshot with safe synthetic text. |
| DQA-010 | People and relationship memory | User can enter relationship memory safely | With consent ON, enter `민지: 프로젝트를 함께한 동료` or another synthetic note in person memory. Save. | Person memory appears in `내 기억`. Copy does not encourage dependence, surveillance, or relationship replacement. |  |  | Screenshot with synthetic relationship only. |
| DQA-011 | Tomorrow todo memory | User can enter a next action | With consent ON, enter `내일 10분 산책` or another safe todo. Save. | Todo appears in `내 기억` and remains local. It does not become a notification, calendar event, or external sync. |  |  | Screenshot of todo memory. |
| DQA-012 | Interests, worries, long-term goals | Input scope is clear | Check whether separate fields exist for interests, worries, and long-term goals. | If present, fields explain allowed storage scope and avoid sensitive data. If absent in current MVP, record `N/A - future profile/memory UX gap`. |  |  | Notes are sufficient unless fields exist. |
| DQA-013 | Save and restart restore | Approved memory restores after app restart | With consent ON, save profile/person/todo and keep one reflection. Force-stop and relaunch. | Role, profile, entries count, people, todos, and growth state restore from local storage. |  |  | Before/after notes or screenshots. |
| DQA-014 | My memory area | Stored information is inspectable | Scroll to `내 기억` or stored information area after saving. Expand `내 기억 관리` if the section is collapsed. | The user can see what categories are stored: role, profile, entries, people, todos, growth level. Lower-priority stored-memory details may live behind an explicit expand/collapse control. |  |  | Screenshot of `내 기억` area. |
| DQA-015 | Full reset | User can clear all local memory | Tap `저장된 기억 모두 지우기`. Confirm visible stored fields. | Stored profile/person/todo/entries/growth return to empty or level 0 state. Reset control is findable. |  |  | Screenshot before and after reset. |
| DQA-016 | Restart after reset | Reset survives app restart | After full reset, force-stop and relaunch. | Cleared local memory does not reappear. Consent and memory state match reset behavior. |  |  | Notes plus optional screenshot. |
| DQA-017 | Friend message | Friend role tone is casual and safe | Select 친구, generate a reflection, and inspect companion message. | Korean copy feels friendly, gentle, and non-diagnostic. It does not overpromise or shame the user. |  |  | Screenshot of companion message. |
| DQA-018 | Lover message | Lover role avoids unsafe attachment | Select 연인, generate a reflection, and inspect companion message. | Tone may be warm but must avoid sexual, possessive, obsessive, jealous, or dependency-inducing language. |  |  | Screenshot or exact short quote in notes if safe. |
| DQA-019 | Family message | Family role stays supportive | Select 가족, generate a reflection, and inspect companion message. | Tone feels familiar and supportive without implying the app is actual family or replacing family support. |  |  | Screenshot of companion message. |
| DQA-020 | Parent message | Parent role avoids control and shame | Select 부모, generate a reflection, and inspect companion message. | Tone is steady and caring, not controlling, blaming, infantilizing, or shame-inducing. |  |  | Screenshot or notes. |
| DQA-021 | Coach message | Coach role is practical, not clinical | Select 코치, generate a reflection, and inspect companion message. | Message suggests a small practical next step without diagnosis, treatment, or performance pressure. |  |  | Screenshot or notes. |
| DQA-022 | Teacher message | Teacher role is explanatory but not patronizing | Select 선생님, generate a reflection, and inspect companion message. | Message is calm and clear, without scolding, ranking, or implying psychological assessment. |  |  | Screenshot or notes. |
| DQA-023 | Listener message | Listener role emphasizes reflection | Select 경청자, generate a reflection, and inspect companion message. | Message listens and reflects without therapy claims, clinical assessment, or emergency-support framing. |  |  | Screenshot or notes. |
| DQA-024 | Growth level | Growth feels like companion familiarity, not diagnosis | Save enough approved memory to change growth level if feasible. Inspect `함께 알아가는 단계`. | Growth is deterministic and framed as local memory accumulation/familiarity. It does not grade the user or imply mental-health status. |  |  | Screenshot of growth line and notes on tone. |
| DQA-025 | Privacy/security copy | Privacy copy is specific and non-absolute | Review all visible privacy/security text. | It clearly says no OS data access, no cloud AI, no analytics/sync/database/permissions. It does not say storage is encrypted or impossible to breach. |  |  | Screenshot of privacy and consent text. |
| DQA-026 | Korean copy quality | Korean text is natural and readable | Review labels, helper text, role labels, companion messages, memory area, and reset copy. | Korean is understandable, trustworthy, and not awkwardly encoded. Key labels such as `기기 안에 기억하기`, `기억 저장하기`, `저장된 기억 모두 지우기`, `함께 알아가는 단계`, `오늘의 인사이트`, `내일의 실마리`, and `작은 미션` should appear as readable Korean. Any mojibake or broken Korean is `Fail` for copy quality. |  |  | Screenshots of any broken text. |
| DQA-027 | Android density and readability | Screen remains usable on phone size | Test on at least one phone-sized Android viewport. Scroll through the full page. | Controls are reachable, text does not overlap, helper text remains readable, and the MVP is not so dense that the next action is unclear. The visible section order should make sense as `현재 companion 상태 -> 기기 안에 기억하기 -> 오늘 기록하기 -> 오늘의 인사이트 -> 오늘 시작하기 -> 내 기억 관리 -> 전체 초기화`. |  |  | Screenshot of busiest section. |
| DQA-028 | Evidence privacy | QA evidence avoids personal data | Review screenshots/XML/notes before attaching or summarizing. | Evidence contains only synthetic input and no notifications, contacts, device personal surfaces, secrets, or private text. |  |  | Evidence review note. |
| DQA-029 | HT-INSIGHT preflight | Insight milestone has a safe UX baseline | Review all failed and noted scenarios before starting `HT-INSIGHT-001`. | No blocking Fail remains in role safety, privacy copy, stored information visibility, reset, restore, or Korean text readability. |  |  | Summary in evidence log. |

## Evidence Capture Criteria

- Capture the first launch privacy panel, local memory consent panel, role selection area, `내 기억` area, reset result, and at least one role-based companion message.
- Capture lover and parent role messages only when the entered test data is synthetic and the screenshot contains no private information.
- Prefer emulator screenshots for visual evidence. For physical devices, prefer written observations or cropped screenshots that exclude personal device surfaces.
- Do not commit raw screenshots/XML unless a separate evidence retention decision approves them.
- In `docs/EVIDENCE_LOG.md`, summarize observations rather than pasting raw personal user input.

## Pass/Fail Decision Rules

| DQA-026 | Simulation control | 100-day synthetic demo is visible | Tap `100일 성장 체험하기`. | The demo control is visible, Korean-first, and clearly marked as synthetic/local-only. |  |  | Screenshot of the simulation control. |
| DQA-027 | Scene preset selection | Korean scene presets are selectable | Open the simulation sheet and choose one preset such as `창업자 바쁜 하루`. | At least eight Korean scene presets are available and each shows a short Korean description. |  |  | Screenshot of the scene picker. |
| DQA-028 | Simulation reset | Simulation clears without touching real memory | Run one simulation, then tap `시뮬레이션 기억 지우기`. | The simulation card returns to fallback state while the real local memory flow stays separate. |  |  | Screenshot of simulation before and after clear. |

| Verdict | Rule |
|---|---|
| Pass | All blocking scenarios pass, no prohibited finding appears, and Notes are either minor or explicitly assigned to a later milestone. |
| Pass with notes | Core privacy, role safety, restore/reset, and inspectability pass, but non-blocking UX issues remain. |
| Fail | Any prohibited finding appears, stored information is not inspectable, reset does not clear local memory, consent OFF persists data, or role/growth copy creates safety risk. |
| Pending | Android target is unavailable or the scenario could not be executed. Record command/device reason. |

## Known Notes

- The current MVP is a single-screen functional Flutter experience, not a finalized visual design system.
- `DESIGN.md` is not HeartTalk-specific. Use `docs/DESIGN_ALIGNMENT.md` to interpret it for HeartTalk QA.
- `shared_preferences` is not encrypted secure storage. High-sensitivity data, credentials, health records, and raw private conversations must remain out of scope.
- Current implemented profile memory is minimal. If interests, worries, long-term goals, or detailed condition controls are not present, record them as future UX gaps rather than current implementation failures.
- PowerShell output may show mojibake even when source files are valid UTF-8. Android UI screenshots are the source of truth for Korean rendering.

## Blocking Criteria Before HT-INSIGHT-001

Do not start `HT-INSIGHT-001` until these are resolved or explicitly accepted as known risks:

1. No Fail remains for local memory consent OFF/ON behavior.
2. No Fail remains for app restart restore or reset-after-restart behavior.
3. No Fail remains for `내 기억` visibility of stored categories.
4. No Fail remains for lover, parent, growth, or diagnostic-safety copy.
5. No Fail remains for Korean text readability on Android UI.
6. No Fail remains for privacy/security copy about local-only storage and no OS/network/cloud access.
7. All Notes that affect future local insight wording are triaged into `HT-INSIGHT-001`, `HT-ROLE-UX-001`, or `HT-MEMORY-MANAGE-001`.

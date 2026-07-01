# HeartTalk MVP Release Candidate Readiness Review

## 결론

HeartTalk MVP는 현재 rc1 태깅 후보 상태다. 기능 범위, acceptance 상태, Android 물리 QA evidence, runbook, 그리고 known risks가 서로 일치하며, 이번 리뷰에서는 앱 기능 코드나 플랫폼 설정을 바꾸지 않았다.

권장 rc tag 후보는 `v0.1.0-rc1`이다.

## 현재 MVP 기능 범위

현재 main에 반영된 MVP는 다음 slices로 구성된다.

- 첫 실행 온보딩
- 로컬 저장 동의
- 역할 선택과 역할별 companion tone
- 오늘 기록하기
- 내 기억 저장/수정/삭제
- 성장 단계
- 오늘의 인사이트
- 오늘 시작하기
- 100일 synthetic 성장 체험
- 시뮬레이션 기억 지우기
- 전체 초기화
- single-screen session flow 정리

이 조합은 `나를 기억하는 하루 친구`라는 제품 방향과 일치한다. 모든 핵심 흐름은 local-only deterministic logic으로 동작하며, Cloud AI, 네트워크, 계정, 동기화, 감지형 OS 권한을 추가하지 않는다.

## Acceptance 상태 요약

다음 항목들은 현재 release-candidate 판단에 필요한 핵심 게이트로 정리되었다.

| Slice | Status | Notes |
|---|---|---|
| ONB-001 | Pass with notes | 첫 실행 온보딩, 로컬 저장 정책, 역할 의미, 100일 가상 데이터 안내, 기억 삭제 안내, 다시 보기 흐름이 물리 Android에서 확인되었다. |
| COMP-010 | Pass | 서버, Cloud AI, analytics, sync, account, sensitive permission, diagnostic copy 추가 없음이 유지된다. |
| INSIGHT-005 / INSIGHT-006 | Pass | local insight slice는 추가 dependency/platform 변경 없이 검증 게이트를 통과했다. |
| MORNING-006 / MORNING-007 | Pass | morning brief slice는 background scheduler, notification, network, Cloud AI 없이 유지되며 검증 게이트를 통과했다. |
| MEM-007 / MEM-008 | Pass | memory management slice는 추가 dependency/platform 변경 없이 검증 게이트를 통과했다. |
| DQA-AC-006 / DQA-AC-007 | Pass | current review는 docs-only이며, 필요한 검증 명령과 결과가 evidence로 기록되었다. |
| HT-ANDROID-QA-004 | Pass with notes | physical Android restore gate passed; the earlier emulator ANR remains an emulator-specific note, not a product blocker. |
| HT-PHYSICAL-RESTORE-QA-001 | Pass | SM F956N physical restore and reset flows were confirmed. |
| HT-MORNING-QA-001 | Pass | morning brief visible on physical Android and fallback behavior were confirmed. |
| HT-MEMORY-MANAGE-QA-001 | Pass | category view, edit/delete, and recalculation behavior were confirmed on physical Android. |
| HT-SESSION-FLOW-QA-001 | Pass with notes | simplified single-screen flow was confirmed, with lower-density layout notes retained. |
| HT-100DAY-SIM-QA-001 | Pass | synthetic 100-day simulation, scene differences, and simulation clear/reset behavior were confirmed. |
| HT-ONBOARDING-001 | Pass | first-run onboarding and help reopen behavior were confirmed on physical Android. |

## QA evidence 요약

Current Android evidence is strong enough for rc1 review:

- Physical device: `SM F956N / R3CX70NHJRN`
- Onboarding showed the local-storage policy, role choice, synthetic demo explanation, and memory deletion notice.
- Session flow on Android showed the current companion state, local memory consent, today record, today insight, morning brief, memory management, and reset in the intended order.
- Morning brief, memory management, and 100-day simulation were each verified on Android with pass or pass-with-notes evidence.
- Force-stop / relaunch restore and full reset / fallback behavior were validated on physical Android.

## Validated commands

The release-candidate review relies on the existing repository gate and build evidence:

- `dart format --output=none --set-exit-if-changed .`
- `flutter analyze`
- `flutter test`
- `powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1`
- `flutter build apk --debug`
- `git diff --check`
- `git status -sb`

## Known risks

The following items remain true and should be called out in rc1 notes:

- `shared_preferences` is non-encrypted local storage.
- The build evidence is debug APK evidence, not release-signed APK evidence.
- Emulator restart ANR behavior is documented separately as emulator-specific.
- Historical Flutter/Gradle cache-root issues and CRLF / mojibake warnings may still appear in local terminals, even when repo evidence is otherwise green.

## rc tag 후보

Recommended tag candidate: `v0.1.0-rc1`

No tag was created in this task. The recommendation is to review this document, confirm no new blockers were introduced, and then create the tag in a separate release step if the team agrees.

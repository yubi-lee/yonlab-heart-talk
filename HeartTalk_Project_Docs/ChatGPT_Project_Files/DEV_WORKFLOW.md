# DEV_WORKFLOW.md — HeartTalk 개발 운영 절차

## 1. 표준 개발 흐름

```text
Project Context
→ Constitution
→ Feature Specification
→ Clarification
→ Technical Plan
→ Atomic Tasks
→ Codex Implementation
→ Quality Gate
→ Independent Review
→ Evidence Log
→ Git Commit
```

## 2. 한 번에 하나의 수직 슬라이스

초기에는 전체 앱을 만들지 않는다. 사용자가 확인 가능한 최소 단위를 반복한다.

| 순서 | 수직 슬라이스 | 목적 |
|---|---|---|
| 001 | Synthetic PPG Heart Rate Dashboard | UI, 도메인, 테스트 루프 검증 |
| 002 | Local Storage Foundation | Drift/SQLite 도입 준비 |
| 003 | Data Management & Deletion | 개인정보 통제 검증 |
| 004 | PPG Capture Adapter Stub | 실제 센서 이전의 인터페이스 검증 |
| 005 | InferenceAdapter Stub | 모델 런타임 교체 가능성 확보 |

## 3. 작업 시작 전 체크리스트

```powershell
cd D:\Views\heart_talk
git status -sb
flutter analyze
flutter test
```

작업 전 저장소가 깨끗하지 않으면 변경사항을 먼저 확인한다.

## 4. Codex 작업 지시 원칙

Codex에는 다음 정보를 반드시 제공한다.

- 목표
- 현재 경로
- 허용 파일
- 수정 금지 파일
- 구현 제약
- 완료 기준
- 검증 명령
- 최종 보고 형식

## 5. 기본 검증 명령

```powershell
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
git status -sb
```

필요 시 추가한다.

```powershell
flutter build apk --debug
```

## 6. 완료 판정

완료는 설명이 아니라 증거로 판단한다.

완료 보고에는 다음이 있어야 한다.

- 변경 파일 목록
- 구현 요약
- 실행한 명령
- 명령 결과
- 실패/경고 여부
- 남은 리스크
- 다음 권장 작업

## 7. 금지되는 운영 방식

- “전체 프로젝트를 알아서 개선해줘”
- “테스트 없이 완료 처리”
- “민감정보 포함 로그 그대로 전달”
- “패키지 마음대로 추가”
- “파일 삭제/마이그레이션/권한 변경 자동 승인”
- “실제 PPG·음성 데이터로 AI 프롬프트 작성”

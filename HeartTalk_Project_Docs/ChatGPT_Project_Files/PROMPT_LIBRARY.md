# PROMPT_LIBRARY.md — HeartTalk 반복 프롬프트 라이브러리

## 1. 설치 로그 진단 요청

```text
아래 Windows PowerShell 로그를 분석해주세요.

요청사항:
1. 실패한 명령 식별
2. 직접 원인
3. 환경 원인 가능성
4. 확인 명령
5. 복구 명령
6. 다음 단계

환경:
- OS: Windows 11
- Shell: PowerShell Native
- Tool root: C:\Utils
- Project root: D:\Views

로그:
[여기에 로그 붙여넣기]
```

## 2. Spec Kit Constitution 작성

```text
HeartTalk 프로젝트의 Spec Kit constitution 초안을 작성해주세요.

조건:
- Windows 11 + Flutter + Spec Kit + Codex 기반
- 초기 MVP는 synthetic PPG demo data만 사용
- 실제 PPG, 실제 음성, 개인정보, API key는 외부 AI에 업로드 금지
- AI-generated code도 format/analyze/test/build 증거가 있어야 완료
- 기능은 feature-first layered architecture로 구현
- on-device inference는 InferenceAdapter 뒤에 추상화
- 의료 진단·치료 표현 금지
```

## 3. 기능 명세 작성

```text
다음 기능을 Spec Kit feature specification 형식으로 작성해주세요.

Feature:
Synthetic PPG Heart Rate Dashboard

Goal:
실제 생체 데이터 없이 합성 심박 데이터로 앱 구조, UI, 테스트, agentic workflow를 검증한다.

포함:
- 사용자 가치
- 기능 요구사항
- 비기능 요구사항
- 제외 범위
- acceptance criteria
- test strategy
- privacy constraints
```

## 4. Codex 작업 프롬프트 생성

```text
아래 작업을 Codex용 지시문으로 변환해주세요.

작업명:
[작업명]

목표:
[목표]

현재 경로:
D:\Views\heart_talk

허용 파일:
[수정 허용 파일]

수정 금지:
[수정 금지 파일]

구현 제약:
[제약 조건]

완료 기준:
[Acceptance criteria]

검증 명령:
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
git status -sb

Codex 최종 보고 형식:
- 변경 파일
- 구현 내용
- 실행한 명령
- 결과
- 남은 리스크
```

## 5. 테스트 증거 검토

```text
아래 Codex 완료 보고와 터미널 결과를 검토해주세요.

검토 기준:
1. 완료 기준 충족 여부
2. 테스트 증거 충분성
3. 누락된 검증 명령
4. 아키텍처 위반 가능성
5. 개인정보·보안 위반 가능성
6. 다음 조치

보고:
[Codex 보고 붙여넣기]

로그:
[터미널 로그 붙여넣기]
```

## 6. 보안·개인정보 리뷰

```text
아래 변경사항을 HeartTalk privacy-first 기준으로 리뷰해주세요.

검토 기준:
- 실제 PPG/음성/개인정보 처리 여부
- 권한 추가 여부
- 로그 민감정보 노출 여부
- 네트워크 전송 여부
- 테스트 fixture 민감정보 포함 여부
- 의료적 오인 표현 여부

변경사항:
[변경 파일 및 요약]
```

## 7. 릴리스 전 체크

```text
HeartTalk 현재 상태를 릴리스 후보로 검토해주세요.

입력:
- git status
- flutter analyze 결과
- flutter test 결과
- flutter build apk --debug 결과
- 변경 파일 목록
- known issues

출력:
- release blocker
- non-blocking issue
- privacy/security risk
- required follow-up
- release recommendation
```

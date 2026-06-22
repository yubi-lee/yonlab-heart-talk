# HeartTalk Constitution

## 핵심 원칙

### I. Privacy-First by Default

HeartTalk은 개발 단계와 운영 단계 모두에서 개인정보 보호를 기본값으로 삼는다.

초기 MVP는 synthetic/demo data만 사용한다. 실제 PPG 데이터, 실제 음성 녹음, 개인 식별정보, 건강 민감 로그, API key, access token, signing key, keystore 파일, production database dump는 코드, 테스트, fixture, 프롬프트, 로그, 커밋, 외부 AI 도구에 포함하지 않는다.

MVP 001에서는 Camera, Microphone, Health Connect, Location, Contacts, background sensor, analytics/sync network permission을 요청하지 않는다. 향후 권한 추가가 필요한 경우 feature spec, 개인정보 영향 검토, 사용자 설명 문구, 명시적 승인 후 진행한다.

### II. Non-Diagnostic Wellness Prototype

HeartTalk은 의료기기나 진단 시스템이 아니라 wellness research prototype이다.

질병 진단, 치료 권고, 의학적 위험도 판정, 정신건강 상태 확정, 의료기기 수준의 정확도 주장을 하지 않는다. 허용 표현은 demo data, signal quality, trend visualization, non-diagnostic insight, wellness research prototype, not medical advice 수준으로 제한한다.

사용자 화면, README, 테스트 데이터, 스크린샷, 데모 시나리오에서도 의료적 오인 표현을 사용하지 않는다.

### III. Spec-First, Evidence-Gated Development

의미 있는 기능은 구현 전에 명세부터 작성한다.

표준 흐름은 다음과 같다.

1. Constitution
2. Feature specification
3. Clarification
4. Technical plan
5. Atomic tasks
6. Codex implementation
7. Automated quality gates
8. Independent review
9. Evidence package
10. Git commit

작업 완료는 설명이 아니라 증거로 판단한다. 완료 보고에는 변경 파일, 실행 명령, 명령 결과, 남은 리스크, 후속 작업, git status -sb 결과가 포함되어야 한다.

### IV. Feature-First Layered Architecture

HeartTalk은 feature-first layered architecture를 따른다.

권장 계층은 다음과 같다.

- presentation
- application
- domain
- data
- infrastructure/adapters

UI, domain logic, persistence, sensor access, inference runtime을 한 파일에 섞지 않는다. Domain entity는 Flutter widget에 의존하지 않는다. Repository interface는 synthetic/demo data source를 향후 real sensor adapter로 교체할 수 있어야 한다.

On-device inference는 반드시 InferenceAdapter 뒤에 추상화한다. 실제 model runtime, PPG capture, voice capture는 향후 기능이며, MVP 001에서는 별도 명세와 승인 없이 구현하지 않는다.

### V. Small Verifiable Vertical Slices

HeartTalk은 작고 검증 가능한 vertical slice 단위로 진행한다.

첫 번째 slice는 Synthetic PPG Heart Rate Dashboard이다. 목적은 실제 생체 데이터 없이 앱 구조, UI loop, synthetic data handling, test, agentic workflow를 검증하는 것이다.

명세와 승인 없이 광범위한 framework, persistence, permission, inference runtime, network service, production integration을 도입하지 않는다.

## 기술 제약

기준 환경은 다음과 같다.

- OS: Windows 11
- Shell: PowerShell Native
- Tool root: C:\Utils
- Project root: D:\Views
- Target app path: D:\Views\heart_talk
- Flutter SDK: C:\Utils\flutter
- uv: C:\Utils\uv
- uv data: C:\Utils\uv-data
- Spec Kit CLI: C:\Utils\uv-data\tool-bin\specify.exe

모든 명령 가이드는 PowerShell 호환이어야 하며, 경로가 모호할 때는 명시적 경로를 사용한다. WSL은 사용자가 요청하지 않는 한 가정하지 않는다.

Dependency 추가, database schema 변경, Android/iOS permission 변경, crash/logging SDK 도입, encryption/key storage 도입, signing/release 설정, destructive file operation은 명시적 승인 후 진행한다.

## 개발 워크플로우와 품질 게이트

완료 보고 전 기본적으로 다음 품질 게이트를 실행한다.

- dart format --output=none --set-exit-if-changed .
- flutter analyze
- flutter test
- git status -sb

Android build configuration, permission, Gradle file, platform code, release 관련 설정을 변경한 경우 다음 명령도 실행한다.

- flutter build apk --debug

각 Codex 작업 지시에는 다음 항목이 포함되어야 한다.

- goal
- allowed files
- forbidden files
- implementation constraints
- acceptance criteria
- verification commands
- required final report format

Codex에는 넓은 범위의 무제한 수정을 요청하지 않는다. 복잡한 작업은 편집 전에 먼저 plan을 작성하게 한다.

## 보안 및 개인정보 리뷰 트리거

다음 변경은 별도 리뷰가 필요하다.

- dependency addition
- network permission addition
- Android/iOS permission change
- database schema change
- encryption or key storage introduction
- model file update
- crash/logging SDK introduction
- release signing configuration change
- real PPG-derived data collection or processing
- real voice-derived data collection or processing
- user-identifiable or health-sensitive data storage/transmission

ChatGPT 또는 외부 AI 도구에 공유하는 로그는 사전에 민감정보를 제거하거나 마스킹해야 한다.

## Governance

이 Constitution은 임시 편의나 개별 구현 선호보다 우선한다.

Constitution 개정 시 다음 항목을 기록한다.

- decision ID
- date
- change summary
- reason
- affected specs/tasks
- migration or remediation plan
- approval status

사용자는 architecture decision, dependency addition, deletion, migration, permission, signing, release, sensitive-data handling에 대한 최종 승인 권한을 가진다.

**Version**: 0.1.0 | **Ratified**: 2026-06-22 | **Last Amended**: 2026-06-22

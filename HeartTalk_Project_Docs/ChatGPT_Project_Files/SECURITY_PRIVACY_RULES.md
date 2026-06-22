# SECURITY_PRIVACY_RULES.md — 개인정보·보안 운영 규칙

## 1. 기본 원칙

HeartTalk은 privacy-first 앱이다. 개발 단계에서도 원시 생체 데이터와 음성 데이터는 외부 AI 도구에 전달하지 않는다.

## 2. 데이터 등급

| 등급 | 예시 | ChatGPT 업로드 | Codex 프롬프트 |
|---|---|---:|---:|
| Public | 공개 문서, 빈 템플릿 | 가능 | 가능 |
| Internal | 아키텍처, 비민감 로그 | 가능 | 가능 |
| Restricted | 테스트 DB, 내부 이슈 | 검토 후 가능 | 검토 후 가능 |
| Sensitive | 실제 PPG, 실제 음성, 개인정보 | 금지 | 금지 |
| Secret | API key, keystore, token | 금지 | 금지 |

## 3. 업로드 금지

```text
*.env
*.jks
*.keystore
*.p12
production database
real PPG data
real voice recordings
raw health logs
personal user profiles
API keys
access tokens
```

## 4. 로그 공유 전 마스킹

공유 전 제거할 항목:

- 사용자 이름
- 이메일
- 전화번호
- 위치정보
- 토큰
- 키
- 실제 데이터 샘플
- 디바이스 고유 식별자
- 경로에 포함된 민감 프로젝트명

## 5. 권한 정책

MVP 001에서는 다음 권한을 요청하지 않는다.

- Camera
- Microphone
- Health Connect
- Location
- Contacts
- Background sensor access

권한은 기능 명세, 개인정보 영향 검토, 사용자 설명 문구가 준비된 뒤 추가한다.

## 6. 건강 표현 정책

다음 표현은 금지한다.

- 질병 진단
- 치료 권고
- 위험도 확정 판정
- 의료기기 수준의 정확도 주장
- 불안·우울 등 정신건강 상태 확정 판정

허용되는 초기 표현:

- demo data
- signal quality
- trend visualization
- non-diagnostic insight
- for wellness research prototype
- not medical advice

## 7. 보안 리뷰 트리거

다음 변경은 별도 리뷰가 필요하다.

- dependency 추가
- network permission 추가
- Android/iOS permission 변경
- database schema 변경
- encryption/key storage 도입
- model file 업데이트
- crash/logging SDK 도입
- release signing 설정 변경

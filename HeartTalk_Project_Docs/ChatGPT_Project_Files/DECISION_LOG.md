# DECISION_LOG.md — 기술 의사결정 기록

| ID | 날짜 | 결정 | 근거 | 상태 |
|---|---|---|---|---|
| DEC-001 | 2026-06-22 | Windows 11 PowerShell Native 기준으로 개발 | 사용자 환경과 기존 작업 방식에 최적 | Accepted |
| DEC-002 | 2026-06-22 | 도구 설치 기준 경로를 `C:\Utils`로 통일 | PATH·백업·재설치 관리 단순화 | Accepted |
| DEC-003 | 2026-06-22 | 프로젝트 루트는 `D:\Views`, 앱 경로는 `D:\Views\heart_talk` | 기존 개발 루트와 일관 | Accepted |
| DEC-004 | 2026-06-22 | Flutter를 앱 프레임워크로 사용 | Android-first, 향후 iOS 확장 가능 | Accepted |
| DEC-005 | 2026-06-22 | Spec Kit 기반 spec-first 개발 | 요구사항과 구현 증거 연결 | Accepted |
| DEC-006 | 2026-06-22 | Codex는 로컬 구현, ChatGPT는 기획·검토 역할 | 비용·품질·통제 균형 | Accepted |
| DEC-007 | 2026-06-22 | MVP 001은 synthetic PPG demo data만 사용 | 개인정보·센서 리스크 제거 | Accepted |
| DEC-008 | 2026-06-22 | 실제 추론 런타임은 `InferenceAdapter` 뒤에 추상화 | LiteRT/TFLite 등 교체 가능성 확보 | Proposed |
| DEC-009 | 2026-06-22 | 로컬 DB는 Drift/SQLite를 우선 검토 | 스키마·마이그레이션·테스트 용이성 | Proposed |

## 새 결정 기록 템플릿

| ID | 날짜 | 결정 | 대안 | 근거 | 영향 | 상태 |
|---|---|---|---|---|---|---|
| DEC-XXX | YYYY-MM-DD |  |  |  |  | Proposed |

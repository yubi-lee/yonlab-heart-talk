# PROJECT_CONTEXT.md — HeartTalk Agentic Dev Workspace

## 1. 프로젝트 개요

HeartTalk은 개인정보 보호를 기본값으로 하는 Flutter 기반 모바일 앱이다. 최종 목표는 PPG-derived signal과 voice-derived feature를 온디바이스에서 분석하는 멀티모달 신호 분석 앱을 구축하는 것이다.

초기 MVP는 실제 생체 데이터 없이 합성 PPG/demo 데이터를 사용하여 다음을 검증한다.

- Windows 11 + VS Code + Flutter 개발 환경
- `C:\Utils` 기준 도구 설치 구조
- Spec Kit 기반 명세 주도 개발 절차
- Codex 기반 로컬 구현 워크플로우
- 테스트 증거 기반 완료 판정
- 개인정보 보호 경계

## 2. 사용자 환경

| 항목 | 기준 |
|---|---|
| OS | Windows 11 |
| Shell | PowerShell Native |
| Tool root | `C:\Utils` |
| Project root | `D:\Views` |
| Target app | `D:\Views\heart_talk` |
| IDE | VS Code |
| App framework | Flutter |
| Spec tool | GitHub Spec Kit |
| Main coding agent | Codex IDE/CLI |
| Planning/review | ChatGPT Project |

## 3. 도구 설치 기준

| 도구 | 기준 경로 |
|---|---|
| Flutter SDK | `C:\Utils\flutter` |
| uv | `C:\Utils\uv` |
| uv cache | `C:\Utils\uv-data\cache` |
| uv tools | `C:\Utils\uv-data\tools` |
| uv tool bin | `C:\Utils\uv-data\tool-bin` |
| Spec Kit CLI | `C:\Utils\uv-data\tool-bin\specify.exe` |

## 4. 현재 작업 목표

1. `C:\Utils` 기준 Windows 개발 도구 설치 안정화
2. Flutter SDK와 Android toolchain 정상화
3. Spec Kit 설치 및 초기화
4. `D:\Views\heart_talk` Flutter 프로젝트 생성
5. `AGENTS.md`, 프로젝트 헌법, 첫 기능 명세 작성
6. `Synthetic PPG Heart Rate Dashboard` MVP 구현

## 5. 개발 원칙

- Spec-first
- Small vertical slice
- Evidence-gated completion
- Human approval for sensitive or destructive work
- Synthetic data first
- On-device privacy boundary
- Test before completion
- No broad unbounded agent edits

## 6. 역할 분리

| 역할 | 책임 |
|---|---|
| ChatGPT Project | 제품 정의, 명세, 아키텍처, 프롬프트, 로그 진단, 리뷰 |
| Codex | 로컬 저장소 읽기, 코드 수정, 테스트 실행, 결과 보고 |
| 사용자 | 승인, 환경 실행, 민감정보 통제, 최종 판단 |

## 7. 금지 데이터

다음 자료는 ChatGPT Project, Codex 프롬프트, 외부 AI 모델에 업로드하지 않는다.

- 실제 PPG raw data
- 실제 음성 파일
- 개인 식별정보
- 건강 민감정보가 포함된 로그
- `.env`
- API key
- signing key
- keystore / jks / p12
- production DB
- 비식별 처리되지 않은 사용자 캡처

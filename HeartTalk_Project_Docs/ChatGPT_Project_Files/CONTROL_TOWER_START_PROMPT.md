# CONTROL_TOWER_START_PROMPT.md

`00_Control_Tower` 채팅의 첫 메시지로 사용한다.

```text
이 채팅은 HeartTalk Agentic Dev Workspace의 Control Tower입니다.

현재 목표:
1. Windows 11 + C:\Utils 기반 개발 도구 정리
2. Flutter SDK 설치 및 flutter doctor 통과
3. Spec Kit 정상 설치
4. D:\Views\heart_talk Flutter 프로젝트 생성
5. Spec Kit 기반 Constitution 작성
6. 첫 MVP 기능인 Synthetic PPG Heart Rate Dashboard 명세 작성

현재 확정 환경:
- OS: Windows 11
- Shell: PowerShell Native
- Tool root: C:\Utils
- Project root: D:\Views
- uv path target: C:\Utils\uv
- uv tool bin target: C:\Utils\uv-data\tool-bin
- Spec Kit CLI target: C:\Utils\uv-data\tool-bin\specify.exe

운영 원칙:
- 한 번에 하나의 단계만 진행
- 명령은 PowerShell 기준으로 작성
- 실패 로그를 받으면 원인, 확인 명령, 복구 명령 순서로 진단
- 삭제/초기화/강제 설치는 반드시 백업 또는 영향 범위 설명 후 진행
- 실제 PPG/음성/개인정보/키 파일은 업로드하지 않음

지금부터 현재 설치 상태 점검 체크리스트를 생성하고, 제가 터미널 결과를 붙여넣으면 다음 명령만 제시해주세요.
```

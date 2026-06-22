# HeartTalk Agentic Dev Workspace — Starter File Pack

생성일: 2026-06-22

이 패키지는 ChatGPT Project와 로컬 Flutter 저장소를 함께 운영하기 위한 초기 문서 세트입니다.

## 폴더 구성

```text
HeartTalk_Project_Docs/
├─ ChatGPT_Project_Files/     # ChatGPT Project에 업로드할 문서
├─ Repo_Files/                # D:\Views\heart_talk 저장소 루트에 복사할 문서
└─ scripts/                   # 로컬 복사용 PowerShell 스크립트
```

## 적용 순서

1. ChatGPT에서 `HeartTalk Agentic Dev Workspace` 프로젝트를 생성합니다.
2. `ChatGPT_Project_Files/` 안의 Markdown 파일들을 프로젝트 파일로 업로드합니다.
3. `ChatGPT_Project_Files/CHATGPT_PROJECT_INSTRUCTIONS.md` 내용을 Project Instructions에 붙여넣습니다.
4. Flutter 프로젝트가 생성된 뒤 `Repo_Files/` 안의 파일들을 `D:\Views\heart_talk`에 복사합니다.
5. 복사 후 아래 명령으로 확인합니다.

```powershell
cd D:\Views\heart_talk
git status -sb
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

## 민감정보 주의

이 문서 세트는 실제 PPG, 실제 음성, 개인정보, API 키, 서명 키, 운영 DB를 포함하지 않습니다. 향후에도 해당 자료는 ChatGPT Project와 Codex 프롬프트에 업로드하지 않는 것을 기본 원칙으로 합니다.

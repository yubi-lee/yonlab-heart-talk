# SETUP_GUIDE.md — HeartTalk Local Setup

## 1. Standard Paths

| Item | Path |
|---|---|
| Tool root | `C:\Utils` |
| Project root | `D:\Views` |
| App path | `D:\Views\heart_talk` |
| Flutter SDK | `C:\Utils\flutter` |
| uv | `C:\Utils\uv` |
| uv tool bin | `C:\Utils\uv-data\tool-bin` |
| specify | `C:\Utils\uv-data\tool-bin\specify.exe` |

## 2. Verify Tools

```powershell
where.exe uv
where.exe specify
where.exe flutter
where.exe dart
where.exe git

uv --version
specify version
flutter --version
dart --version
git --version
```

## 3. Flutter Health Check

```powershell
flutter doctor
flutter doctor --android-licenses
```

## 4. Create Project

```powershell
cd D:\Views
flutter create heart_talk
cd D:\Views\heart_talk
git init
git add .
git commit -m "Initial Flutter project"
```

## 5. Initialize Spec Kit

```powershell
cd D:\Views\heart_talk
specify init --here --integration copilot --script ps --ignore-agent-tools
specify self check
git add .
git commit -m "Add Spec Kit workflow"
```

## 6. Baseline Quality Gate

```powershell
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
git status -sb
```

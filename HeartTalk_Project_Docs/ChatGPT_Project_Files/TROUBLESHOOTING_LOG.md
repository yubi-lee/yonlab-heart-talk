# TROUBLESHOOTING_LOG.md — 설치·환경 문제 기록

## 1. 기준 경로

| 항목 | 기준 |
|---|---|
| Tool root | `C:\Utils` |
| Project root | `D:\Views` |
| Flutter | `C:\Utils\flutter\bin\flutter.bat` |
| uv | `C:\Utils\uv\uv.exe` |
| uv tool bin | `C:\Utils\uv-data\tool-bin` |
| specify | `C:\Utils\uv-data\tool-bin\specify.exe` |

## 2. uv 기존 경로 흔적

### 증상

```powershell
where.exe uv
```

결과에 아래 두 경로가 함께 표시됨.

```text
C:\Utils\uv\uv.exe
C:\Users\joyke\.local\bin\uv.exe
```

### 판단

`C:\Utils\uv\uv.exe`가 먼저 표시되면 현재 실행은 정상이다. 다만 `.local\bin`의 이전 설치 흔적은 혼선을 줄이기 위해 정리한다.

### 정리 명령

```powershell
Remove-Item "$env:USERPROFILE\.local\bin\uv.exe" -Force -ErrorAction SilentlyContinue
Remove-Item "$env:USERPROFILE\.local\bin\uvx.exe" -Force -ErrorAction SilentlyContinue
where.exe uv
```

## 3. Spec Kit 설치 오류

### 증상

```text
ModuleNotFoundError: No module named 'specify_cli.bundler.lib'
```

### 판단

`specify.exe`는 PATH에 있지만 `specify-cli` tool venv 내부 설치가 불완전하거나 캐시/이전 설치가 오염된 상태다.

### 복구 명령

```powershell
uv tool uninstall specify-cli
Remove-Item "C:\Utils\uv-data\tool-bin\specify.exe" -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Utils\uv-data\tools\specify-cli" -Recurse -Force -ErrorAction SilentlyContinue
uv cache clean
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v0.11.3
where.exe specify
specify version
specify self check
```

## 4. flutter 명령 인식 실패

### 증상

```text
flutter : 'flutter' 용어가 cmdlet ... 으로 인식되지 않습니다.
```

### 원인

Flutter SDK가 설치되지 않았거나 `C:\Utils\flutter\bin`이 PATH에 없다.

### 확인 명령

```powershell
Test-Path C:\Utils\flutter\bin\flutter.bat
where.exe flutter
[Environment]::GetEnvironmentVariable("Path", "User") -split ";" | Where-Object { $_ -like "*flutter*" }
```

### 조치

```powershell
$flutterBin = "C:\Utils\flutter\bin"
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$flutterBin*") {
    [Environment]::SetEnvironmentVariable("Path", "$flutterBin;$userPath", "User")
}
```

PowerShell과 VS Code를 모두 닫고 다시 연다.

## 5. venv 활성화 상태

전역 도구 설치/정리 작업 중 프롬프트에 `(.venv)`가 보이면 먼저 해제한다.

```powershell
deactivate
```

안 되면 새 PowerShell을 연다.

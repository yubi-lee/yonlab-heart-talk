$ErrorActionPreference = "Continue"

Write-Host "`n[PATH CHECK]" -ForegroundColor Cyan
where.exe uv
where.exe specify
where.exe flutter
where.exe dart
where.exe git

Write-Host "`n[VERSION CHECK]" -ForegroundColor Cyan
uv --version
specify version
flutter --version
dart --version
git --version

Write-Host "`n[UV DIR CHECK]" -ForegroundColor Cyan
uv cache dir
uv tool dir
uv tool dir --bin

Write-Host "`n[PROJECT CHECK]" -ForegroundColor Cyan
if (Test-Path "D:\Views\heart_talk") {
    Push-Location "D:\Views\heart_talk"
    git status -sb
    Pop-Location
} else {
    Write-Host "D:\Views\heart_talk does not exist yet." -ForegroundColor Yellow
}

Write-Host "`n[FLUTTER DOCTOR]" -ForegroundColor Cyan
flutter doctor

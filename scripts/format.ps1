$ErrorActionPreference = 'Stop'

Set-Location -LiteralPath 'D:\Views\heart_talk'
Write-Host "Location: $(Get-Location)"

$dart = Get-Command dart -ErrorAction SilentlyContinue
if (-not $dart) {
    Write-Warning 'dart command not found. Skipping format check.'
    exit 0
}

& dart format --output=none --set-exit-if-changed .
exit $LASTEXITCODE

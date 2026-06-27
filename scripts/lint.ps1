$ErrorActionPreference = 'Stop'

Set-Location -LiteralPath 'D:\Views\heart_talk'
Write-Host "Location: $(Get-Location)"

$flutter = Get-Command flutter -ErrorAction SilentlyContinue
if (-not $flutter) {
    Write-Warning 'flutter command not found. Skipping analyze.'
    exit 0
}

& flutter analyze
exit $LASTEXITCODE

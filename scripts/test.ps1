$ErrorActionPreference = 'Stop'

Set-Location -LiteralPath 'D:\Views\heart_talk'
Write-Host "Location: $(Get-Location)"

$flutter = Get-Command flutter -ErrorAction SilentlyContinue
if (-not $flutter) {
    Write-Warning 'flutter command not found. Skipping tests.'
    exit 0
}

& flutter test
exit $LASTEXITCODE

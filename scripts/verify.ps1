$ErrorActionPreference = 'Stop'

Set-Location -LiteralPath 'D:\Views\heart_talk'
Write-Host "Location: $(Get-Location)"

function Invoke-Step {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][scriptblock]$Command
    )

    Write-Host ""
    Write-Host "==> $Name"
    & $Command
    if ($LASTEXITCODE -ne 0) {
        throw "$Name failed with exit code $LASTEXITCODE"
    }
}

$git = Get-Command git -ErrorAction SilentlyContinue
if ($git) {
    Invoke-Step -Name 'git status -sb' -Command { git status -sb }
} else {
    Write-Warning 'git command not found. Skipping git status.'
}

$dart = Get-Command dart -ErrorAction SilentlyContinue
if ($dart) {
    Invoke-Step -Name 'dart format --output=none --set-exit-if-changed .' -Command {
        dart format --output=none --set-exit-if-changed .
    }
} else {
    Write-Warning 'dart command not found. Skipping format check.'
}

$flutter = Get-Command flutter -ErrorAction SilentlyContinue
if ($flutter) {
    Invoke-Step -Name 'flutter analyze' -Command { flutter analyze }
    Invoke-Step -Name 'flutter test' -Command { flutter test }
} else {
    Write-Warning 'flutter command not found. Skipping analyze and test.'
}

Write-Host ""
Write-Host 'Verification script finished. Run flutter build apk --debug manually when Android build configuration changes.'

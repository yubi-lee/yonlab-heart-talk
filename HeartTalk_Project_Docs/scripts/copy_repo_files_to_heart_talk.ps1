param(
    [string]$Destination = "D:\Views\heart_talk",
    [ValidateSet("DryRun", "Execute")]
    [string]$Mode = "DryRun"
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$packageRoot = Split-Path -Parent $scriptDir
$source = Join-Path $packageRoot "Repo_Files"

if (-not (Test-Path $source)) {
    throw "Repo_Files source folder not found: $source"
}

if (-not (Test-Path $Destination)) {
    throw "Destination folder not found: $Destination"
}

Write-Host "[Source] $source" -ForegroundColor Cyan
Write-Host "[Destination] $Destination" -ForegroundColor Cyan
Write-Host "[Mode] $Mode" -ForegroundColor Cyan

$files = Get-ChildItem $source -Recurse -File

foreach ($file in $files) {
    $relative = $file.FullName.Substring($source.Length).TrimStart("\")
    $target = Join-Path $Destination $relative
    Write-Host "$relative -> $target"

    if ($Mode -eq "Execute") {
        $targetDir = Split-Path -Parent $target
        New-Item -ItemType Directory -Force $targetDir | Out-Null
        Copy-Item $file.FullName $target -Force
    }
}

if ($Mode -eq "Execute") {
    Write-Host "`nDone. Review with:" -ForegroundColor Green
    Write-Host "cd $Destination"
    Write-Host "git status -sb"
} else {
    Write-Host "`nDryRun only. Re-run with -Mode Execute to copy files." -ForegroundColor Yellow
}

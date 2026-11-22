# English Daily Reps - one-time setup for Windows
# The app itself lives online (GitHub Pages) and updates by itself, so this only
# needs to run once. It puts a tiny launcher + icon in F:\Programs\EnglishDailyReps
# and creates Desktop / Start menu shortcuts that open the app in its own Edge window.
param([string]$Dest = 'F:\Programs\EnglishDailyReps')
$ErrorActionPreference = 'Stop'
$src  = $PSScriptRoot
$name = 'English Daily Reps'

# --- locate Edge ---
$edge = @("${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
          "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe") | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $edge) { Write-Host 'Microsoft Edge was not found. Install Edge and run this again.'; exit 1 }

# --- launcher files (remove the old full offline copy if present) ---
New-Item -ItemType Directory -Force -Path $Dest | Out-Null
foreach ($old in 'index.html','manifest.json','sw.js','icon.png','icon-180.png','icon-512.png','audio') {
  $p = Join-Path $Dest $old; if (Test-Path $p) { Remove-Item $p -Recurse -Force }
}
foreach ($f in 'launch.html','icon.ico','uninstall.ps1','uninstall.bat') { Copy-Item (Join-Path $src $f) (Join-Path $Dest $f) -Force }

# --- shortcuts ---
$url = 'file:///' + ((Join-Path $Dest 'launch.html') -replace '\\', '/')
$launchArgs = "--app=`"$url`" --window-size=480,900"
$shell = New-Object -ComObject WScript.Shell
foreach ($dir in @([Environment]::GetFolderPath('Desktop'), [Environment]::GetFolderPath('Programs'))) {
  $lnk = $shell.CreateShortcut((Join-Path $dir "$name.lnk"))
  $lnk.TargetPath = $edge
  $lnk.Arguments = $launchArgs
  $lnk.WorkingDirectory = $Dest
  $lnk.IconLocation = (Join-Path $Dest 'icon.ico') + ',0'
  $lnk.Description = 'Daily English practice (updates automatically)'
  $lnk.Save()
}
Write-Host "Set up in $Dest. Open '$name' from the Desktop or the Start menu. Updates arrive automatically."

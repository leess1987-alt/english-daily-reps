# English Daily Reps - installer (Windows)
# Copies the app to F:\Programs\EnglishDailyReps and creates Desktop / Start menu
# shortcuts that open it in its own Microsoft Edge app window (no address bar).
# Run again after updating the source to install the new version.
param([string]$Dest = 'F:\Programs\EnglishDailyReps')
$ErrorActionPreference = 'Stop'
$src  = $PSScriptRoot
$name = 'English Daily Reps'

# --- locate Edge ---
$edge = @("${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
          "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe") | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $edge) { Write-Host 'Microsoft Edge was not found. Install Edge and run this again.'; exit 1 }

# --- copy app files ---
New-Item -ItemType Directory -Force -Path $Dest | Out-Null
$files = 'index.html','manifest.json','sw.js','icon.png','icon.ico','icon-180.png','icon-512.png','uninstall.ps1','uninstall.bat'
foreach ($f in $files) { Copy-Item (Join-Path $src $f) (Join-Path $Dest $f) -Force }
$audioDest = Join-Path $Dest 'audio'
if (Test-Path $audioDest) { Remove-Item $audioDest -Recurse -Force }
Copy-Item (Join-Path $src 'audio') $audioDest -Recurse -Force

# --- shortcuts ---
$url = 'file:///' + ((Join-Path $Dest 'index.html') -replace '\\', '/')
$launchArgs = "--app=`"$url`" --window-size=480,900"
$shell = New-Object -ComObject WScript.Shell
foreach ($dir in @([Environment]::GetFolderPath('Desktop'), [Environment]::GetFolderPath('Programs'))) {
  $lnk = $shell.CreateShortcut((Join-Path $dir "$name.lnk"))
  $lnk.TargetPath = $edge
  $lnk.Arguments = $launchArgs
  $lnk.WorkingDirectory = $Dest
  $lnk.IconLocation = (Join-Path $Dest 'icon.ico') + ',0'
  $lnk.Description = 'Daily English practice'
  $lnk.Save()
}
Write-Host "Installed to $Dest. Open '$name' from the Desktop or the Start menu."

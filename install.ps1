# English Daily Reps - installer
# Creates the app icon and Desktop / Start menu shortcuts that open the app
# in its own Microsoft Edge app window (no address bar). Works offline.
$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$name = 'English Daily Reps'

# --- locate Edge ---
$edge = @("${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
          "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe") | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $edge) { Write-Host 'Microsoft Edge was not found. Install Edge and run this again.'; exit 1 }

# --- draw icon (256px PNG, wrapped into an .ico) ---
Add-Type -AssemblyName System.Drawing
$png = Join-Path $root 'icon.png'
$ico = Join-Path $root 'icon.ico'
$s = 256
$bmp = New-Object System.Drawing.Bitmap $s, $s
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = 'AntiAlias'; $g.TextRenderingHint = 'AntiAliasGridFit'
$g.Clear([System.Drawing.Color]::Transparent)
$path = New-Object System.Drawing.Drawing2D.GraphicsPath
$r = 56; $w = $s - 1
$path.AddArc(0, 0, $r, $r, 180, 90); $path.AddArc($w - $r, 0, $r, $r, 270, 90)
$path.AddArc($w - $r, $w - $r, $r, $r, 0, 90); $path.AddArc(0, $w - $r, $r, $r, 90, 90); $path.CloseFigure()
$g.FillPath((New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(47, 75, 214))), $path)
# highlighter stripe
$g.FillRectangle((New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 227, 107))), 46, 168, 164, 30)
$font = New-Object System.Drawing.Font('Georgia', 150, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
$fmt = New-Object System.Drawing.StringFormat; $fmt.Alignment = 'Center'; $fmt.LineAlignment = 'Center'
$g.DrawString('E', $font, [System.Drawing.Brushes]::White, (New-Object System.Drawing.RectangleF(0, 4, $s, $s)), $fmt)
$g.Dispose(); $bmp.Save($png, [System.Drawing.Imaging.ImageFormat]::Png); $bmp.Dispose()

$pngBytes = [System.IO.File]::ReadAllBytes($png)
$ms = New-Object System.IO.MemoryStream; $bw = New-Object System.IO.BinaryWriter $ms
$bw.Write([UInt16]0); $bw.Write([UInt16]1); $bw.Write([UInt16]1)          # ICONDIR
$bw.Write([Byte]0); $bw.Write([Byte]0); $bw.Write([Byte]0); $bw.Write([Byte]0) # 256x256
$bw.Write([UInt16]1); $bw.Write([UInt16]32); $bw.Write([UInt32]$pngBytes.Length); $bw.Write([UInt32]22)
$bw.Write($pngBytes); $bw.Flush()
[System.IO.File]::WriteAllBytes($ico, $ms.ToArray()); $bw.Dispose()

# --- shortcuts ---
$url = 'file:///' + ((Join-Path $root 'index.html') -replace '\\', '/')
$launchArgs = "--app=`"$url`" --window-size=480,900"
$shell = New-Object -ComObject WScript.Shell
foreach ($dir in @([Environment]::GetFolderPath('Desktop'), [Environment]::GetFolderPath('Programs'))) {
  $lnk = $shell.CreateShortcut((Join-Path $dir "$name.lnk"))
  $lnk.TargetPath = $edge
  $lnk.Arguments = $launchArgs
  $lnk.WorkingDirectory = $root
  $lnk.IconLocation = "$ico,0"
  $lnk.Description = 'Daily English practice'
  $lnk.Save()
}
Write-Host "Installed. Open '$name' from the Desktop or the Start menu."

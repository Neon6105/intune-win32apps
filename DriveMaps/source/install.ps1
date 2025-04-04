#==================================================
# Software : Drive Maps (script)
# Action   : Install
# Method   : File
# Updated  : 2025-03-04 (script created)
#==================================================

$MyProgramData = "$env:ProgramData\Neon6105"
$CmdPath = "$MyProgramData\Scripts\drivemaps.cmd"
$IcoPath = "$MyProgramData\Icons\drivemaps.ico"
$LnkPath = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\Drive Maps.lnk"

ForEach ($ItemPath in ($CmdPath, $IcoPath, $LnkPath)) {
  $ParentPath = Split-Path $ItemPath -Parent
  If (!(Test-Path $ParentPath -PathType Container)) { New-Item -Path $ParentPath -ItemType Directory -Force }
}

Copy-Item -Path ".\drivemaps.ico" -Destination $IcoPath -Force
Copy-Item -Path ".\drivemaps.cmd" -Destination $CmdPath -Force

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$LnkPath")
$Shortcut.TargetPath = "$CmdPath"
$Shortcut.WorkingDirectory = "$MyProgramData"
$Shortcut.IconLocation = "$IcoPath"
$Shortcut.Save()

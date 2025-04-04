#==================================================
# Software : Drive Maps (script)
# Action   : Detect
# Method   : File
# Updated  : 2025-03-04 (script created)
#==================================================

$MyProgramData = "$env:ProgramData\Neon6105"
$CmdPath = "$MyProgramData\Scripts\drivemaps.cmd"
$IcoPath = "$MyProgramData\Icons\drivemaps.ico"
$LnkPath = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\Drive Maps.lnk"

ForEach ($ItemPath in ($CmdPath, $IcoPath, $LnkPath)) {
  If (!(Test-Path $ItemPath -PathType Leaf)) {
    Write-Output "Failed to detect file at $ItemPath"
    Exit 1
  }
}
Write-Output "Drive Maps appears to be installed!"
Exit 0

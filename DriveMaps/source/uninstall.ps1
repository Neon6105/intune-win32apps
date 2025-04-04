#==================================================
# Software : Drive Maps (script)
# Action   : Uninstall
# Method   : File
# Updated  : 2025-03-04 (script created)
#==================================================

$MyProgramData = "$env:ProgramData\Neon6105"
$CmdPath = "$MyProgramData\Scripts\drivemaps.cmd"
$IcoPath = "$MyProgramData\Icons\drivemaps.ico"
$LnkPath = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\Drive Maps.lnk"

ForEach ($ItemPath in ($CmdPath, $IcoPath, $LnkPath)) {
  $ParentPath = Split-Path $ItemPath -Parent
  If (Test-Path $ItemPath -PathType Leaf) {   
    Remove-Item -Path $ItemPath -Force
  }
  $ChildItems = (Get-ChildItem "$ParentPath" -Recurse | Measure-Object).Count
  If (($ParentPath -like "$MyProgramData\*") -and ($ChildItems -eq 0)) { Remove-Item $ParentPath }  # Remove empty directories
}

If ((Get-ChildItem -Path $MyProgramData -Recurse | Measure-Object) -eq 0) { Remove-Item "$MyProgramData" }

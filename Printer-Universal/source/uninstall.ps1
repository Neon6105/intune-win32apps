#==================================================
# Software : Printer (universal uninstaller)
# Action   : Uninstall
# Method   : Powershell
# Updated  : 2025-03-05 (script created)
#==================================================

[CmdletBinding()]
Param(
  [Parameter(Mandatory=$FALSE,Position=1)]
  [string]$Name
);
If (!($Name)) { Write-Output "No printer specified."; Exit 1 }

ForEach ($Connection in $Name.Split(",")) {
  # Check if the printer is already uninstalled.
  If(!(Get-Printer -Name "$Connection" -ErrorAction SilentlyContinue)) {
    Write-Output "Printer already uninstalled: $Connection"
    Continue
  }

  # Uninstall the printer
  try {
    Write-Output "Removing printer: $Connection"
    Remove-Printer -Name "$Connection"
  } catch {
    Write-Output "Something went wrong trying to remove $Connection"
    Exit 1
  }
  Write-Output "Uninstall complete for $Connection!"
}

Write-Output "Uninstall complete!"
Exit 0

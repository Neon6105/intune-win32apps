#==================================================
# Software : Printer (universal installer)
# Action   : Install
# Method   : Powershell
# Updated  : 2025-03-05 (script created)
#==================================================

[CmdletBinding()]
Param(
  [Parameter(Mandatory=$FALSE,Position=1)]
  [string]$Printer
);
If (!($Printer)) { Write-Output "No printer specified."; Exit 1 }

ForEach ($Connection in $Printer.Split(",")) {
  # Check if the printer is already installed.
  If (Get-Printer "$Connection" -ErrorAction SilentlyContinue) {
    Write-Output "Printer already installed: $Connection."
    Continue
  }

  # Install the printer (if the print server is available)
  try {
    $PrintServer = $Connection.Split("\")[-2]
    If (Test-Connection $PrintServer -Count 1 -Quiet) {
      Write-Output "Adding printer: $Connection"
      Add-Printer -ConnectionName "$Connection"
    } else {
      Write-Output "Print server is not available: $PrintServer"
      Exit 1
    }
  } catch {
    Write-Output "something went wrong trying to add $Connection"
    Exit 1
  }
  Write-Output "Install complete for $Connection!"

  # Duplicate printer cleanup
  $PrinterName = $Connection.Split("\")[-1]
  $Duplicates = Get-Printer | Where-Object {($_.Name -like "*$PrinterName*") -and ($_.Name -notlike "\\$PrintServer\*")}
  ForEach ($Duplicate in $Duplicates) {
    If ("\\$PrintServer" -like "\\$($Duplicate.ComputerName)*") {
      Write-Output "Removing duplicate connection: $($Duplicate.Name)"
      Remove-Printer -Name $Duplicate.Name -ErrorAction SilentlyContinue
    } else {
      Write-Output "Skipped mismatched connection: $($Duplicate.Name)"
    }
  }
}

Write-Output "Install complete!"
Exit 0

# Universal Connector for Shared Printers

**!! This script does not install missing print drivers.**

## Usage
Upload Printer-Universal.intunewin to Intune then configure the printer details.  
_Replace `printserver.corp.example.com` with the FQDN of your print server._  
_Replace `printer_name` with the name of your printer (Note: This is not necessarily the same as the share name!)_  
  
Install command:  
powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File install.ps1 "\\\\printserver.corp.example.com\\printer_name"  
  
Uninstall command:  
powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File uninstall.ps1 "\\\\printserver.corp.example.com\\printer_name"  
  
Install behavior:  
USER  
  
Detection rules:  
Manually Configured > +Add  
Rule type: Registry  
Key Path: HKCU\Printers\Connections\,,printserver.corp.example.com,printer_name  
Detection method: Key exists  

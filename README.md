# Intune Win32Apps
Custom Win32Apps for use with Microsoft Intune  

Please feel free to contact me for custom Win32Apps, either here or [u/jobunocru](https://www.reddit.com/u/jobunocru/)  
  
## Setup
Edit `build.cmd` to point to your local copy of `IntuneWinAppUtil.exe` which is sourced from [microsoft/Microsoft-Win32-Content-Prep-Tool](https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool)  

## Usage
1. Copy the template and rename the project folder to match the app name  
1. Edit `detect.ps1 `, `source\install.ps1` and `source\uninstall.ps1` using a provided method  
1. As needed, include additional files (such as MSI or EXE installers) in the `./source` directory
1. Add any supporting files (app icons, documentation, etc) into the project folder  
1. Run `build.cmd` (after editing!) to create a .intunewin file  
1. Create the Win32App in Intune and upload the .intunewin file
1. Upload `detect.ps1` as the detection rule (or manually set detection rules in Intune)
1. Set the Install Command to `powershell.exe -ExecutionPolicy Bypass -File install.ps1`  
1. Set the Uninstall Command to `powershell.exe -ExecutionPolicy Bypass -File uninstall.ps1`  

#Requires -Version 5.0

param (
    [switch]$Silent
)

if ([Security.Principal.WindowsIdentity]::GetCurrent().User.Value -eq 'S-1-5-18') {
	Write-Status "This script can't be ran as TrustedInstaller/SYSTEM.
Please relaunch this script under a regular admin account." -Level Critical -Exit
} else {
	if (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
		if ($PSBoundParameters.Count -le 0 -and !$args) {
				Start-Process cmd "/c PowerShell -NoP -EP Bypass -File `"$PSCommandPath`"" -Verb RunAs
				exit
		} else {
			throw "This script must be run as an administrator."
		}
	}
}

Write-Host "This script is for clearing any previous Edge or WebView update blocks.
EdgeRemover version 1.8.1 and below had an option to add update blocks, but that has now been removed.
This is due to the decision to have WebView no longer uninstallable and the policies not doing much.`n" -ForegroundColor Yellow
if (!$Silent) { $null = Read-Host "Press Enter to continue..." }

Write-Output "Clearing Edge policies..."
'HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate', 'HKCU:\SOFTWARE\Policies\Microsoft\EdgeUpdate' | % {
    Remove-Item -Path $_ -Recurse -Force -EA 0
    New-Item -Path $_ -Force | Out-Null
}

$EdgeUpdateDisabled = "$EdgeRemoverReg\EdgeUpdateDisabled"
$EdgeUpdateOrchestrator = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Orchestrator\UScheduler\EdgeUpdate'
if (!(Test-Path $EdgeUpdateOrchestrator) -and (Test-Path $EdgeUpdateDisabled)) {
    Write-Output "Adding EdgeUpdate back to Windows Update..."
    Move-Item -Path $EdgeUpdateDisabled -Destination $EdgeUpdateOrchestrator -Force
}

if (!$Silent) { $null = Read-Host "Done, press Enter to exit..." }
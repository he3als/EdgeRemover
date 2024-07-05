function ExitPause($message = 'Press Enter to exit...') {
    if ($args) {
        Start-Sleep 2
    } else {
        $null = Read-Host $message
    }
    exit 1
}

$ver = $PSVersionTable.PSVersion
if (($null -eq $ver) -or ([double]"$($ver.Major).$($ver.Minor)" -lt "5.1")) {
    Write-Output "This script requires PowerShell 5.1 or above, as well as Windows 10 or 11."
    ExitPause
}
if ([System.Environment]::OSVersion.Version.Major -lt 10) {
    Write-Output "This script requires Windows 10 or 11."
    ExitPause
}

[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

if ($args[0] -eq "-ClearUpdateBlocks") {
    $download = "https://cdn.jsdelivr.net/gh/he3als/EdgeRemover@main/ClearUpdateBlocks.ps1"
} else {
    $download = "https://cdn.jsdelivr.net/gh/he3als/EdgeRemover@latest/RemoveEdge.ps1"
}

$temp = mkdir (Join-Path $([System.IO.Path]::GetTempPath()) $(New-Guid))
$file = "$temp\RemoveEdge.ps1"

Invoke-WebRequest -Uri $download -Out $file -UseBasicParsing
if (!$?) {
    Write-Output "Failed to download the Edge script!"
    ExitPause
}

Start-Process -FilePath "powershell" -Verb RunAs -ArgumentList "-NoP -EP Unrestricted -File `"$file`" $args"
if (!$?) {
    Write-Output "Failed to start the Edge script! $_"
    ExitPause
}

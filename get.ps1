$ver = $PSVersionTable.PSVersion
if ([double]"$($ver.Major).$($ver.Minor)" -lt "5.1") {
    Write-Output "This script requires PowerShell 5.1 or above, as well as Windows 10 or 11."
    Start-Sleep 2
    exit 1
}

[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

if ($args[0] -eq "-ClearUpdateBlocks") {
    $download = "https://cdn.jsdelivr.net/gh/he3als/EdgeRemover@main/ClearUpdateBlocks.ps1"
} else {
    $download = "https://cdn.jsdelivr.net/gh/he3als/EdgeRemover@main/RemoveEdge.ps1"
}

$temp = mkdir (Join-Path $([System.IO.Path]::GetTempPath()) $(New-Guid))
$file = "$temp\RemoveEdge.ps1"

Invoke-WebRequest -Uri $download -Out $file -UseBasicParsing
if (!$?) {
    Write-Output "Failed to download the Edge script!"
    Start-Sleep 2
    exit 1
}

Start-Process -FilePath "powershell" -Verb RunAs -ArgumentList "-NoP -EP Unrestricted -File `"$file`" $args"
if (!$?) {
    Write-Output "Failed to start the Edge script! $_"
    Start-Sleep 2
    exit 1
}
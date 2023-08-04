[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$download = "https://github.com/he3als/EdgeRemover/releases/latest/download/RemoveEdge.ps1"
$file = "$env:temp\RemoveEdge.ps1"

Invoke-WebRequest -Uri $download -Out $file -UseBasicParsing

Start-Process -FilePath "powershell" -Verb RunAs -ArgumentList "-NoP -EP Unrestricted -File `"$file`" $args"
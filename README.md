# EdgeRemover
PowerShell script to remove Microsoft Edge, which is based off of [ave9858's script](https://gist.github.com/ave9858/c3451d9f452389ac7607c99d45edecc6).

**Download:** https://github.com/he3als/EdgeRemover/releases/latest/download/RemoveEdge.ps1

### For quick removal, use either of these commands in Run (Win + R)
```powershell
powershell iex """&{$(irm https://raw.githubusercontent.com/he3als/EdgeRemover/main/get.ps1)} -UninstallAll"""
```
```powershell
powershell iex(irm https://raw.githubusercontent.com/he3als/EdgeRemover/main/get.ps1)
```

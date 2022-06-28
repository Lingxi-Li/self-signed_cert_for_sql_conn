Param(
    [Parameter(Mandatory=$false)][string]$SqlAuthCerFilePath = "sql_auth.cer"
)

$ErrorActionPreference = "Stop"

$null = certutil -addstore "Root" $SqlAuthCerFilePath
Write-Host "Done"

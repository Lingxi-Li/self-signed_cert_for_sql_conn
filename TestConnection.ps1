Param(
    [Parameter(Mandatory=$false)][string]$DataSource = "."
)

$ErrorActionPreference = "Stop"

$ConnectionString = "Data Source=$($DataSource);Integrated Security=True;"
$Connection = New-Object System.Data.SqlClient.SqlConnection($ConnectionString)
$Connection.Open()
if ($Connection.State -eq "Open") {
    Write-Host "Successfully connected with no encryption."
    $Connection.Close()
}
else {
    Write-Host "Failed to connect with no encryption."
}
$Connection.Dispose()

$ConnectionString += "Encrypt=true;"
$Connection = New-Object System.Data.SqlClient.SqlConnection($ConnectionString)
$Connection.Open()
if ($Connection.State -eq "Open") {
    Write-Host "Successfully connected with encryption."
    $Connection.Close()
}
else {
    Write-Host "Failed to connect with encryption."
}
$Connection.Dispose()

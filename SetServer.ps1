Param(
    [Parameter(Mandatory=$false)][string]$SqlInstanceName = "MSSQLSERVER"
)

$ErrorActionPreference = "Stop"

$CertFriendlyName = "SQL Auth Cert"
$CertFileName = "sql_auth.cer"
$CertStoreLocation = "Cert:\LocalMachine\My"

$HostName = [System.Net.Dns]::GetHostByName("localhost").HostName
$IpAddrs = [System.Net.Dns]::GetHostByName($HostName).AddressList
$DnsNames = $HostName, "localhost", ".", "127.0.0.1"
foreach ($IpAddr in $IpAddrs) {
    $DnsNames += $IpAddr.IPAddressToString
}

$Cert = New-SelfSignedCertificate `
    -Provider "Microsoft RSA SChannel Cryptographic Provider" `
    -FriendlyName $CertFriendlyName `
    -Type SSLServerAuthentication `
    -CertStoreLocation $CertStoreLocation `
    -Subject $HostName `
    -DnsName $DnsNames `
    -KeyAlgorithm "RSA" `
    -KeyFriendlyName "$($CertFriendlyName) Private Key" `
    -KeySpec KeyExchange `
    -KeyUsage DigitalSignature, KeyEncipherment, DataEncipherment `
    -KeyLength 2048 `
    -KeyExportPolicy ExportableEncrypted `
    -HashAlgorithm "SHA256" `
    -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.1")
$Cert | Export-Certificate -Type CERT -FilePath $CertFileName

# $Cert = Get-ChildItem -Path $CertStoreLocation | Where-Object { $_.FriendlyName -eq $CertFriendlyName }
$PrivateKey = [System.Security.Cryptography.X509Certificates.RSACertificateExtensions]::GetRSAPrivateKey($Cert)
$PrivateKeyPath = "C:\ProgramData\Microsoft\Crypto\RSA\MachineKeys\$($PrivateKey.Key.UniqueName)"
$Acl = Get-Acl -Path $PrivateKeyPath
$NewRule = New-Object System.Security.AccessControl.FileSystemAccessRule("NT Service\$($SqlInstanceName)", "Read", "Allow")
$Acl.SetAccessRule($NewRule)
$Acl | Set-Acl

$SqlInstanceRegKey = Get-ChildItem -Path "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server" | Where-Object { $_.Name.EndsWith($SqlInstanceName) }
$SuperSocketNetLibRegKeyPath = "$($SqlInstanceRegKey)\MSSQLServer\SuperSocketNetLib".Replace("HKEY_LOCAL_MACHINE", "HKLM:")
Set-ItemProperty -Path $SuperSocketNetLibRegKeyPath -Name "Certificate" -Value $Cert.Thumbprint.ToLowerInvariant() -Force
Restart-Service -Name $SqlInstanceName -Force
Start-Sleep -Seconds 5
Write-Host "Done"

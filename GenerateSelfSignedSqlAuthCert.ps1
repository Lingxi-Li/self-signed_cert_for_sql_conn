[CmdletBinding()]

$HostName = [System.Net.Dns]::GetHostByName("localhost").HostName
$IpAddrs = [System.Net.Dns]::GetHostByName($HostName).AddressList
$DnsNames = $HostName, "localhost", "127.0.0.1"
foreach ($IpAddr in $IpAddrs) {
    $DnsNames += $IpAddr.IPAddressToString
}

$Cert = New-SelfSignedCertificate `
    -Provider "Microsoft RSA SChannel Cryptographic Provider" `
    -FriendlyName "SQL Auth Cert" `
    -Type SSLServerAuthentication `
    -CertStoreLocation "Cert:\LocalMachine\My" `
    -Subject $HostName `
    -DnsName $DnsNames `
    -KeyAlgorithm "RSA" `
    -KeyFriendlyName "SQL Auth Cert Private Key" `
    -KeySpec KeyExchange `
    -KeyUsage DigitalSignature, KeyEncipherment, DataEncipherment `
    -KeyLength 2048 `
    -KeyExportPolicy ExportableEncrypted `
    -HashAlgorithm "SHA256" `
    -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.1")
$Cert | Export-Certificate -Type CERT -FilePath "sql_auth.cer"

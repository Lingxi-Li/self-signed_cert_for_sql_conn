# Set Up Trusted Self-Signed Cert for Encrypted SQL Server Connection

SQL Server has a built-in self-signed cert for encrypted connection. However, there is no official way to export it and have it trusted by client. Follow this guide to create a new self-signed cert, set it up to SQL Server for encrypted connection, and have it trusted by client.

Run [SetServer.ps1](SetServer.ps1) on server machine with admin privilege to

1. generate a self-signed cert with friendly name "SQL Auth Cert" into "Cert:\LocalMachine\My",
1. export the cert into file "sql_auth.cer" under current folder,
1. grant SQL service account read access to cert private key,
1. set the cert to be used for encrypted connection,
1. restart SQL service.

Run [SetClient.ps1](SetClient.ps1) on client machine with admin privilege to trust the cert by importing it to "Cert:\CurrentUser\Root".

Run [TestConnection.ps1](TestConnection.ps1) on client machine to verify setup by establishing both non-encrypted and encrypted connections.

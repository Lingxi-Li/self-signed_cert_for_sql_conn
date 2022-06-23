# Set Up Trusted Self-Signed Cert for Encrypted SQL Server Connection

SQL Server has a built-in self-signed cert for encrypted connection. However, there is no official way to export it and have it trusted by client. Follow this guide to create a new self-signed cert, set it up to SQL Server for encrypted connection, and have it trusted by client.

## Set Up Server

Run GenerateSelfSignedSqlAuthCert.ps1 with admin privilege. It does two things.

- Generates a self-signed cert named "SQL Auth Cert" into "LocalMachine\My".
- Exports into file "sql_auth.cer" under current folder.

Follow steps below to grant SQL Server read access to the cert.

1. Locate the cert in "Manage computer certificates" > "Personal" > "Certificates" > the one with Friendly Name = "SQL Auth Cert".
2. Right-click on the cert > All Tasks > Manage Private Keys.
3. Add SQL Server service account (e.g., "NT Service\MSSQLSERVER") and grant it read permission.

Follow steps below to have SQL Server use the cert for encrypted connection.

1. Open SQL Server Configuration Manager
2. SQL Server Network Configuration > right-click on the item for the target instance (e.g., "Protocols for MSSQLSERVER") > Properties > Certificates tab > select "SQL Auth Cert" from the dropdown list.
3. SQL Server Services > right-click on the item for the target SQL Server instance (e.g., "SQL Server (MSSQLSERVER)") > Restart.

## Set Up Client

Right-click on "sql_auth.cer" > Install Certificate > Current User > Place all certificates in the following store > Trusted Root Certification Authorities

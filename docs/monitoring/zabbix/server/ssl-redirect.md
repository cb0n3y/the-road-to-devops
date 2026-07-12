# SSL and Redirect

Create the certificate via hpc-management and copy the files onto the
server.

Add the following lines to `/etc/httpd/conf/httpd.conf`:

> RewriteEngine on RewriteCond %{HTTPS} off RewriteRule (.\*)
> [https://%{HTTP\_HOST}%{REQUEST\_URI}](https://%%7BHTTP_HOST%7D%%7BREQUEST_URI%7D)
> RedirectMatch ^/$ /zabbix/

Update the paths to the certificate files in
`/etc/httpd/conf.d/ssl.conf`:

> SSLCertificateFile /etc/pki/tls/certs/hpc-zabbix.cert.pem
> SSLCertificateKeyFile /etc/pki/tls/private/hpc-zabbix.key.pem

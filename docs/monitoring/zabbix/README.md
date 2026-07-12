# Zabbix

## Server installation

Zabbix is installed with MariaDB (referred as MySQL) database-backend as
described on the website [Download
Zabbix](https://www.zabbix.com/download). The [official
Installation-documentation](https://www.zabbix.com/documentation/4.0/manual/installation/install_from_packages/rhel_centos)
has additional information.

First, add the repository and install the packages:

    rpm -i https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
    yum install zabbix-server-mysql zabbix-web-mysql zabbix-agent mariadb-server httpd mod_ssl

Next, secure the installation and create the database and the database
user:

    mysql_secure_installation

    mysql -uroot -p
    < enter mysql root password >

    mysql> create database zabbix character set utf8 collate utf8_bin;
    mysql> grant all privileges on zabbix.* to zabbix@localhost identified by '<password>';
    mysql> quit;

    zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p zabbix

Important configuration settings in **/etc/zabbix/zabbix\_server.conf**:

-   `DBName`, `DBUser`, `DBPassword`: credentials for the database

Set the timezone in `/etc/httpd/conf.d/zabbix.conf`:

> php\_value date.timezone Europe/Berlin

Now you can enable and start the services:

    systemctl enable zabbix-server zabbix-agent httpd
    systemctl restart zabbix-server zabbix-agent httpd

Zabbix needs to be configured via the web frontend before it can be
used. Navigate to **http://&lt;hostname&gt;/zabbix** and click your way
through the setup.

## Proxy Installation

The Installation follows basically the same steps as the zabbix-server.

    rpm -i https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
    yum makecache fast
    yum install zabbix-proxy-mysql mariadb-server

    mysql_secure_installation

Next, create the database and the database user:

Important

When running Server and Proxy on the same (database-) host: `DBUser` and
`DBName` must be different!

    mysql -uroot -p
    < enter mysql root password >

    mysql> create database zabbix character set utf8 collate utf8_bin;
    mysql> grant all privileges on zabbix.* to zabbix@localhost identified by '<password>';
    mysql> quit;

    zcat /usr/share/doc/zabbix-proxy-mysql*/schema.sql.gz | mysql -uzabbix -p zabbix

Important configuration settings in `/etc/zabbix/zabbix_proxy.conf`:

-   `ProxyMode`: Passive mode
-   `Server`: IP of server allowed to contact he proxy
-   `ProxyLocalBuffer`: how many hours should values be stored when the
    server does not show up
-   encryption-settings: `TLSConnect`, `TLSAccept`, `TLSPSKIdentity`,
    `TLSPSKFile`
-   `DBName`, `DBUser`, `DBPassword`: credentials for the database

<!-- -->

    systemctl enable zabbix-proxy
    systemctl restart zabbix-proxy

# Proxy Installation

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

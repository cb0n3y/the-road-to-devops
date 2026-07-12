# Tuning Zabbix

## Dimensioning hardware correctly

The basic rule is: The more hosts and items you create, the more the
hardware has to work. The largest load is caused by the database. When
selecting hardware, make sure that it is optimized for operating a
database. Pay special attention to the IO-Wait values of your Zabbix
database. If the database has to wait too often for the hard disk, this
is a sign of insufficient hardware resources.

The Zabbix server daemon, PHP and the web server also need memory. If
memory runs out on the Zabbix server, you can also put the database and
Zabbix server on separate hardware. Below are some tips on how to
increase database performance.

## MySQL-Database tuning

Note

At this point no comprehensive explanation about MySQL tuning can be
given. All the options shown here have to be done in /etc/my.cnf or
/etc/mysql/my.cnf.

## Increase MySQL Bufferpool

With the parameter innodb\_buffer\_pool\_size you specify how much main
memory MySQL may use to buffer operations. Enter 50% of the available
RAM as buffer pool and slowly feel your way up.

    innodb_buffer_pool_size=4G

## Increase MySQL Innodb-Logfil

Before MySQL writes the transactions to the table files on the hard
disk, they are written to the Innodb log file. This log file also
provides a kind of buffer. The larger the log file, the faster the
database can report a transaction as written. Set a value between 512MB
and 1GB depending on the number of database operations.

    systemctl stop mariadb.service
    cp /var/lib/mysql/ib_logfile* ~
    rm /var/lib/mysql/ib_logfile*

In my.cnf or in /etc/mysql/my.cnf again:

    innodb_log_file_size=512

## Reduce disk access

Each transaction is written to the Inno DB log file and, if necessary,
to the doublewrite buffer. The log file is immediately written to the
hard disk. MySQL does not confirm the transaction until the hard disk
has confirmed that all information has been backed up. This ensures the
greatest possible data security. However, the Zabbix server usually does
not store any important data, so that the loss of a measured value has
serious consequences.

    innodb_doublewrite=0
    # dont flush at every commit
    innodb_flush_log_at_trx_commit=2
    # No writes from the log buffer to the log file are performed at transaction commit. Flush every second
    innodb_flush_log_at_trx_commit=0

Note

For more information, please visit [MySQL
Manual](https://dev.mysql.com/doc/refman/5.6/en/innodb-parameters.html#sysvar_innodb_flush_log_at_trx_commit).

## Increase MySQL Buffer-Pool instances

Since MySQL version 5.5 the buffer pool can be divided into regions.
This accelerates simultaneous accesses to memory. Only set
innodb\_buffer\_pool\_instances greater than one if you have assigned at
least 2GB as the Innodb buffer pool.

    innodb_buffer_pool_instances=1

## Use Innodb Plugin

Zabbix uses the table driver Innodb for all tables. Since version 5.1.38
you can use two different "types" of Innodb:

> -   Standard Innodb
> -   Innodb plugin

    #ignore-builtin-innodb
    plugin-load=innodb=ha_innodb_plugin.so
    innodb_file_per_table=1
    innodb_file_format=barracuda

Hint

Since MySQL version 5.5 the Innodb plugin is standard and does not need
to be activated.

## Reduce transaction security

In many cases, you can reduce transaction security in favor of
performance. The most common inserts in the database are the newly
arrived measured values of the items. If such inserts are already
confirmed if they have been written to RAM and not yet to the hard disk,
then this is acceptable in many cases, but brings a higher write speed.

    innodb_doublewrite=0
    innodb_flush_log_at_trx_commit=0
    innodb_support_xa=No

Note

For more information visit [MySQL
Documentation](https://dev.mysql.com/doc/refman/8.0/en/innodb-parameters.html)
or [Zabbix
Forum](https://www.zabbix.com/forum/zabbix-cookbook/12712-performance-tuning-mysql?t=12407).

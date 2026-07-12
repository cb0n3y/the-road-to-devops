# Install and Setup SNMP

## Installation

Zabbix supports snmp per default, but you have to install snmpd so that
zabbix can fulfill its purpose. On your zabbix server install the snmpd
service with:

    yum install -y net-snmp-utils net-snmp net-snmp-devel

## Configuring SNMP

Now make a backup copy of snmpd.conf before making any changes.

    mv /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf.bak

Create a new snmpd.conf file and add the following lines:

    vim snmpd.conf

    ...

    rocommunity  public
    syslocation  "Datencenter, Mein Datencenter"
    syscontact  syscontact@meinedomain

Restart the service:

    systemctl restart snmpd.service

Check if snmp also works:

    snmpwalk -v 2c -c public -O e 127.0.0.1

Warning

Please note that snmp requires more settings to make it safe. This guide
is only a quick start.

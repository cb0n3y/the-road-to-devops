# Functions of Zabbix

The functions of Zabbix are divided into the following main areas:
-   Collect data
-   process data
-   react and trigger actions
-   Make configuration
-   Display data

## Host and Item: Collect Data

Collecting data is always the first step in setting up monitoring. In
Zabbix, data collection is controlled by the so-called items. An item is
a measured quantity (What is to be measured?). The so-called item value
is the measured value.

Items can contain information of any format (type), for example the hard
disk usage in percent, the system time as date (Unix timestamp), a log
entry as text or the CPU usage as floating point value.

All item values are stored in the Zabbix database as a chronological
list with the date and time of the measurement. Zabbix does not use its
own internal database, but an external SQL database such as MySQL.

The Zabbix server collects the data from various sources. Data sources
are available:

> -   Zabbix agent: This is installed on the host to be monitored and
>     directly accesses the characteristics of the operating system.
> -   Simple Check: Tests that the Zabbix server can perform
>     independently, such as ping checks or portscans.
> -   SNMP: The Zabbix server acts as a reading SNMP manager that
>     retrieves data from an SNMP agent on the monitored host or device.
> -   Zabbix Aggregates: Data from multiple sources is merged, for
>     example, added, and then stored as a new item.
> -   IPMI agent installed on the host or device to be monitored. The
>     IPMI daemon is typically provided by the hardware vendor along
>     with the remote management consoles, such as Dell iDRAC or HP iLO.
> -   Database Monitor: The Zabbix server queries databases and stores
>     the results as item values.
> -   External Check: Scripts executed on the Zabbix server whose return
>     values are stored as item values.
> -   Zabbix-Trapper: Data that is sent from the client to the server by
>     the Zabbix sender.
> -   Zabbix-Internal: Evaluations of the internal Zabbix server data
> -   SSH or Telnet: Commands are executed via the integrated SSH or
>     Telnet client from the Zabbix server to remote hosts. The output
>     of the commands is stored as item values.

Items are always bound to hosts. The Zabbix server always gets the order
to measure value X on host Y. Anything that has an IP address or DNS
name can be a host in Zabbix. Hosts and items form a classic one-to-one
relationship. A host can have any number of items. However, an item can
only be assigned to one host.

If, after reading this introduction, you want to start configuring
monitoring immediately, remember this:

> -   Step 1: Create a host. For whom or what should data be collected?
> -   Step 2: Create the items for the hosts. What data is collected?

## Trigger: Process data

As soon as the Zabbix server has collected data, the item values are
available for evaluation. The further processing of the data is done by
so-called triggers. For example, the values of the items are compared
with a threshold value. Triggers are one of the most important core
functions of Zabbix, because only they can trigger an action.

Zabbix offers many functions for evaluating the measurement results.
These include the use of regular expressions and mathematical functions.
Several functions can be combined with the logical operators AND and OR.

After the measured value of a trigger has been evaluated, the trigger
assumes the status TRUE or FALSE. The status TRUE means that there is a
problem. The status of the trigger is stored in the database and waits
there for further processing. The Zabbix triggers are executed similar
to database triggers the moment a new measurement value arrives at the
Zabbix server.

Do not confuse triggers with alarms. The trigger is the trigger for many
subsequent actions. The trigger does not determine which action is
executed. The actions have their own conditions that determine whether
they are executed or not. Therefore, do not search for menus or setting
options in the configuration of the triggers to select which alarm is to
be triggered. When which alarm is triggered is set in the actions.

## Graphs and Screens: Show data

A great strength of Zabbix lies in the multiple ways in which data can
be displayed. The clear display of data was an important goal of the
Zabbix developers right from the start. Accordingly, the visualization
of data is directly integrated into the core of Zabbix. You don't need
any additional tools or add-ons.

## Generate the PSK

On the server to be monitored, run the following command to generate the
psk-key.

    sudo sh -c "openssl rand -hex 48 > /etc/zabbix/zabbix.psk"
    chown zabbix:zabbix /etc/zabbix/zabbix.psk

Now go to /etc/zabbix and copy the content of zabbix.psk.

Add the following values to zabbix\_agent.conf in the TLS-Realeted
Parameters Section.

    ### Option: TLSConnect
    # How the agent should connect to server or proxy. Used for active checks.
    # Only one value can be specified:
    #               unencrypted - connect without encryption
    #               psk         - connect using TLS and a pre-shared key
    #               cert        - connect using TLS and a certificate
    #
    # Mandatory: yes, if TLS certificate or PSK parameters are defined (even for 'unencrypted' connection)
    # Default:
    # TLSConnect=unencrypted
    TLSConnect=psk

    ### Option: TLSAccept
    # What incoming connections to accept.
    # Multiple values can be specified, separated by comma:
    #               unencrypted - accept connections without encryption
    #               psk         - accept connections secured with TLS and a pre-shared key
    #               cert        - accept connections secured with TLS and a certificate
    #
    # Mandatory: yes, if TLS certificate or PSK parameters are defined (even for 'unencrypted' connection)
    # Default:
    # TLSAccept=unencrypted
    TLSAccept=psk

    ### Option: TLSPSKIdentity
    # Unique, case sensitive string used to identify the pre-shared key.
    #
    # Mandatory: no
    # Default:
    # TLSPSKIdentity=
    TLSPSKIdentity=name_to_identify_your_psk

    ### Option: TLSPSKFile
    # Full pathname of a file containing the pre-shared key.
    #
    # Mandatory: no
    # Default:
    # TLSPSKFile=
    TLSPSKFile=/etc/zabbix/zabbix.psk

In Zabbix frontend go to Configure, click on Hosts and select the
desired host. Once there, click on Encription. Select PSK as Connection
to host as well for Connections from host. Enter the psk name you
entered in zabbix\_agent.conf and the content of zabbix.psk. Click on
Update to save the changes. Go back to the server and restart
zabbix-agent.

    systemctl restart zabbix-agent.service
    zabbix_agentd -p

Important

Please consider that there are more options which have to be adjusted to
your needs. The following are only the beginning of the monitoring
process.

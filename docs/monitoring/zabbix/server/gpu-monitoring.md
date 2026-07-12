# Setting up Zabbix on the GPUs servers

## Creating the scripts

Go to `/etc/zabbix` and create a folder called scripts and change into
it. In this folder we will goning to save the scripts for nvidia. Create
a script named get\_gpus\_info.sh:

    mkdir scripts
    nano  get_gpus_info.sh

    #!/bin/bash

    result=$(/usr/bin/nvidia-smi -L)
    first=1

    echo "{"
    echo "\"data\":["

    while IFS= read -r line
    do
      if (( "$first" != "1" ))
        then
          echo ,
    fi
    index=$(echo -n $line | cut -d ":" -f 1 | cut -d " " -f 2)
    gpuuuid=$(echo -n $line | cut -d ":" -f 3 | tr -d ")" | tr -d " ")
    echo -n {"\"{#GPUINDEX}"\":\"$index"\", \"{#GPUUUID}"\":\"$gpuuuid\"}
    if (( "$first" == "1" ))
      then
      #    echo ,
          first=0
    fi
    done < <(printf '%s\n' "$result")

    echo
    echo "]"
    echo "}"

Change the owner and the group of the scripts folder to `zabbix:zabbix`:

> chown -R zabbix:zabbix scripts

Allow zabbix-agent to execure nvidia-smi.

    vim /etc/sudoers

    #
    # Refuse to run if unable to disable echo on the tty.
    #
    # Defaults   !visiblepw

    ....

    ## Same thing without a password
    # %wheel  ALL=(ALL)   NOPASSWD: ALL
    zabbix  ALL=(ALL:ALL) NOPASSWD:/usr/bin/nvidia-smi

## Configure Zabbix Agent

Edit the file `zabbix_agent.conf`

    vim /etc/zabbix/zabbix_agent.conf

The following options need to be changed before starting to send data to
zabbix:

> -   DebugLevel
> -   Server
> -   ListenPort
> -   StartAgents
> -   ServerActive
> -   Hostname
> -   Timeout

**DebugLevel**

    ### option: debuglevel
    # specifies debug level
    # 0 - no debug
    # 1 - critical information
    # 2 - error information
    # 3 - warnings
    # 4 - for debugging (produces lots of information)
    #
    DebugLevel=3

Server

Telling zabbix agent where to establish the connection:

    ##### passive checks related

    ### option: server
    #   list of comma delimited ip addresses (or hostnames) of zabbix servers.
    #   incoming connections will be accepted only from the hosts listed here.
    #   no spaces allowed.
    # if ipv6 support is enabled then '127.0.0.1', '::127.0.0.1', '::ffff:127.0.0.1' are treated equally
    #
    # mandatory: yes
    # default:
    # server=
    Server=Zabbix_Server_IP_or_FQDN

ListenPort

    ### option: listenport
    # agent will listen on this port for connections from the server.
    #
    ListenPort=10050

StartAgents

    ### option: startagents
    # number of pre-forked instances of zabbix_agentd that process passive checks.
    # if set to 0, disables passive checks and the agent will not listen on any tcp port.
    #
    StartAgents=10

Tip

5 StartAgents would be enough. Here we have 10 for the monitoring of the
GPUs to work properly.

ServerActive

    ##### active checks related
    ### option: serveractive
    # list of comma delimited ip:port (or hostname:port) pairs of zabbix servers for active checks.
    # if port is not specified, default port is used.
    # ipv6 addresses must be enclosed in square brackets if port for that host is specified.
    # if port is not specified, square brackets for ipv6 addresses are optional.
    # if this parameter is not specified, active checks are disabled.
    # example: serveractive=127.0.0.1:20051,zabbix.domain,[::1]:30051,::1,[12fc::1]
    #
    ServerActive=Zabbix_Server_IP_or_FQDN

Hostname

The host name of the server to be monitored.

    ### option: hostname
    # unique, case-sensitive hostname.
    # required for active checks and must match hostname as configured on the server.
    # value is acquired from hostnameitem if undefined.
    #
    Hostname=vca-gpu-211-03

TimeOut

    ### option: timeout
    # spend no more than timeout seconds on processing
    #
    Timeout=10

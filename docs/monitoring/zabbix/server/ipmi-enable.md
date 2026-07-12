Enable IPMI
===========


Enable StartIPMIPollers on Zabbix server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Go to the zabbix server in ``/etc/zabbix/zabbix_server.conf``
and change it as shown.

.. code-block:: bash

  vim /etc/zabbix/zabbix_server.conf

  ...

  ############ ADVANCED PARAMETERS ################
  ### Option: StartPollers
  #       Number of pre-forked instances of pollers.
  #
  # Mandatory: no
  # Range: 0-1000
  # Default:
  # StartPollers=5
  StartPollers=5

  ### Option: StartIPMIPollers
  #	  Number of pre-forked instances of IPMI pollers.
  #       The IPMI manager process is automatically started when at least one IPMI poller is started.
  # StartIPMIPollers=0
  StartIPMIPollers=5

  ...

  ### Option: StartPollersUnreachable
  #       Number of pre-forked instances of pollers for unreachable hosts (including IPMI and Java).
  #       At least one poller for unreachable hosts must be running if regular, IPMI or Java pollers
  #       are started.
  #
  # Mandatory: no
  # Range: 0-1000
  # Default:
  # StartPollersUnreachable=1
  StartPollersUnreachable=5


Zabbix services must be restarted:

.. code-block:: bash

  systemctl restart zabbix-*

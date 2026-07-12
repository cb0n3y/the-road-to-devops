# Monitoring CHx80 with zabbix via SNMP

## Create a Group in zabbix

In Zabbix-Frontend go to Configuration and click on
`Configuration --> Host groups
--> Create host group`. Provide your group with a name (e.g. CHx80) and
Update it.

## Create a Template

Make click on `Configuration --> Templates --> Create template`. Provide
your template with a meaningful name (e.g. Template CHx80 SNMP), add the
group to which the template will be applied (the group you have created
before) and click on Update.

## Add Items to your Template

Click on the template you have created before and click on
`Items --> Create item` to create your first item. Enter the name of the
Item (e.g. Temperature). Change the type to the SNMP version you used to
retrieve the data via snmpwalk. If you have retrieved the data via
snmpwalk with version 2c, select SNMPv2 Agent as the item type. Now as a
key you should enter a part of the OID. Let‘s say we have the following
OID: SNMPv2-SMI::enterprises.30518.16.2.1.3.1, our key could look like
this: enterprises.30518.16.2.1.3.1. As SNMP OID enter the OID mentioned
before (SNMPv2-SMI::enterprises.30518.16.2.1.3.1).

The key will be needed later to create the triggers and the OID (Object
Identifier). Pay attention to the correct Type of Information as with
every item. Both snmpwalk and the MIB browser already specify the type
of data delivered by SNMP. For the SNMP community enter
{$SNMP\_COMMUNITY}, because usually the data is retrieved using the
default value public. The Type of Information depends of what kind of
information you are retrieving, with the IOD mentioned before you should
select Numeric (float). Enter the Unit (°C) and the Update interval
(3m).

Under New application enter a name by which all other related items will
be identified, e.g. Temperature. Later when you create a new item that
is related to temperature, just select Temperature and save the changes.
After you have created your first item, you have also created your first
application (Temperature). You can see all the information by clicking
on `Templates --> your
template --> Items`. You can create the Application before you create
the items, anyway during the items creation you can also create an
application.

## Create Graphs in your Template

Click in `your template --> Graphs --> Create graph`. Enter a name for
the created graph, leave all options as they are. In the Item option
click Add in the rectangle to add which data you want to represent in
the graph. You can choose more than one data for it. Click on the big
Add button to save the graph.

## Create Screen

Click on `Monitoring --> Screens --> Create screen`. The field with the
name "Owner" just stay like it is. Enter a name for new screen and click
on add to save it. On the same screen (Screens) you will see all the
screens you have, click on `your screenname --> Constructor to add`,
change or delete any graphs on it."

## Create the Hosts in Zabbix

Now make click `Hosts --> Create Host`. Enter the necessary information
such as name, groups (The group you have created before). Then delete
the Agent interfaces and add a SNMP interface. Enter the IP-Address or
the FQDN of the Host you want to be monitored. On the Monitored by proxy
option select hpc-zabbix-proxy. Click on
`Templates --> Link new templates` and select the Template you have
created before. You should click on the Select button, pickup the
Template and click in the rectangle on "Add" and after that on add to
save your new host.

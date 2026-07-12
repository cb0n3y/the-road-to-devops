# IPMI Monitoring

## Create an IPMI interface

The ipmi interface must first be created in Zabbix Frontend. To do this,
click on **Configuration --&gt; Hosts** and select the host to which you
want to add the interface mentioned above. In `PMI Interface --> Add`
enter the necessary information.

## Create an IPMI Template for your host(s)

In `Configuration --> Templates --> Create template` you can create a
template for IPMI. Name the template (conventionally it always starts
with "Template" for example: *Template Dell Servers HHI*). As group add
the group Template IPMI and choose add to save the changes. Select the
template you just created
(`Configuration --> Templates --> your template`) right now and add some
items.

To get all the information you need to create each item, use ipmitool.

    ipmitool -H <host-ip> -U monitor -I lanplus -L user sensor

This will show you all the sensors supported by the host you want to
monitor via IPMI. Click on the template and then on
`Items --> Create item` to create an item.

> -   Name: item name e.g. System Fan
> -   Type: IPMI
> -   Key: &lt;it is an identification word, e.g System\_Fan&gt;
> -   Type of information: &lt;Numeric (unsigned), Numeric (Float), Text
>     ...&gt;
> -   IPMI sensor: &lt;take the name from the ipmitool output&gt;
> -   Units: &lt;depends on what data you get, e.g Temp = C/F,
>     Fan=RPM&gt;
> -   Update interval: &lt;you can chose between 30s and 1h&gt;
> -   New application: &lt;is just a name to make a better filtering
>     later&gt;

Click on *Add* to save your item. Repeat the same steps to create more
items.

## Add Triggers to your IPMI Template

The triggers are in charge of setting conditions between all the data
that zabbix is able to obtain from the hosts. The triggers alone do
nothing, only when the triggers are put together, a means of
notification and an action is that magic happens. Click on
`Template --> your template --> Triggers --> Create trigger` to create a
trigger.

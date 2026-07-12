# E-Mail Alert

To create an email alert there are 3 steps to follow:

1\. Configure the type of media to be used. In
`Administration --> Media types --> Email` enter the following
information:

    SMTP server: mail.hhi.fraunhofer.de
    SMTP server port: 25
    SMTP helo: hpc-zabbix.fe.hhi.de
    SMTP email: zabbix@hpc-zabbix.fe.hhi.de

    Connection security: STARTTLS
    Authentication: none
    Message format: html
    Enabled: yes

Note

For more information about what types of notification zabbix supports.
[Zabbix](https://www.zabbix.com/integrations).

1.  The type of media to be used to inform administrators must be
    configured for each of them. In
    `Administration --> Users --> User --> Media --> Add` enter the
    following information:

<!-- -->

    Send to: the E-Mail address of the user # you can add more E-Mail Addresses.
    When active: let it as it is
    Use if severity: choose when to be notified.
    Enabled: yes

1.  An action must be defined beforehand. This is configured in
    menuselection:<span class="title-ref">Configuration --&gt; Actions
    --&gt; Create action</span>. Enter a name for the action. Click on
    `Operations --> New` to configure if you want to send an email to a
    specific group and/or a single user. If you want to send an email to
    all Administrators, click `Add --> Send --> User groups`. Select the
    group or groups you want to notify and click on the `` Add'
    at the end of the form and then on :menuselection:`Add `` at the
    bottom of the page.

    If you only want to notify a single user or several users, click
    `Send
    to Users --> Add`, select the user(s) and click on `Add` at the end
    of the form. And as in the previous step, click again on `Add` at
    the bottom of the page to save the changes.

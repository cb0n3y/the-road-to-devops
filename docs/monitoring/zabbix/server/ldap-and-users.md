# LDAP and Users

Go to `Administration --> Authentication --> LDAP settings`. Enter the
well known LDAP settings into the formular. Use **sAMAccountName** as
search attribute. Test the settings and if that is succesful, click on
Update.

Important

LDAP-Users should enter a password (which is only used when switching
back to internal auth)

Next, go to `Administration --> Users`. Create a user by clicking on
Create user in the upper right corner. In the User tab, add the username
as Alias and a password (that will not be used, when the user is
authenticated via LDAP). You also have to select one or more groups for
the new user. In the Permissions tab, set the User type. When all
settings are done, click on Add.

Important

With the next setting, the default admin user will not be able to login
anymore. Make sure, that you created at least one user with admin
permissions, before continuing.

To enable LDAP, go to `Administration --> Authentication -->
Authentication` and change the default authentication to LDAP. Then
click Update.

manual switch back to internal auth

Login to the web-frontend is not possible if the LDAP-setting are
incorrect or the LDAP-server is not reachable. There is no fallback to
other Auth methods like "internal". In this case you may want to switch
back to internal auth.

In this case execute the following command on the zabbix-server to get
the DB-credentials:

    egrep 'DBUser|DBName|DBPassword' /etc/zabbix/zabbix_server.conf

Login to database and change "authentication\_type" in table "config" to
"0" (Internal):

    mysql -u zabbix -p

    USE zabbix;
    UPDATE config SET authentication_type = 0;

    # 0 : Internal
    # 1 : LDAP
    # 2 : HTTP

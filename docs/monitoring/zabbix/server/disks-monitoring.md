# HDDs/SSDs/NVMEs

## SMARTCTL

All you need to do is to download the following files to your PC and
follow the instructions.

\# Configuring the download of files
-   Allow zabbix to execute smartctl as root
    `zbx_smartctl <files/disks/smartctl/zbx_smartctl>`
-   Userparameter:
    `userparameter_smart.conf <files/disks/smartctl/userparameter_smartctl.conf>`
-   Discovery Script:
    `smartctl-disks-discovery <files/disks/smartctl/smartctl-disks-discovery.pl>`

Run ansible.

    ansible-playbook -i hosts -u <username> remote_script_paste.yml

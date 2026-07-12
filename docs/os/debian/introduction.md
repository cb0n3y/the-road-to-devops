# First Steps

In this small tutorial I will try to show in a simple way how to install
Debian in a stable way, without unnecessary programs and with a low
resource consumption desktop like xfce. In other words, it's about
getting a small, slim and stable basic system on which you can build.

If you want the system to be as tidy as possible without any bells and
whistles, you should only install a server version without GUI in the
beginning. The best requirement is a new Linux installation. First
install a standard server setup of the desired distribution.

For Debian:

Go to the Debian main page and [download](https://www.debian.org/CD/)
the latest Debian iso. When the download process is completed, insert an
usb device on your computer. Be sure to select the correct usb:

    root@7a1n0:/home/cb0n3y/Downloads# lsblk
    NAME              MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
    sda                 8:0    0 238.5G  0 disk
    ├─sda1              8:1    0   533M  0 part  /boot
    ├─sda2              8:2    0     1K  0 part
    └─sda5              8:5    0   238G  0 part
      └─sda5_crypt    254:0    0   238G  0 crypt
        ├─fx0-root    254:1    0   980M  0 lvm   /
        ├─fx0-tmp     254:2    0   1.9G  0 lvm   /tmp
        ├─fx0-var     254:3    0   9.3G  0 lvm   /var
        ├─fx0-opt     254:4    0   3.8G  0 lvm   /opt
        ├─fx0-usr     254:5    0  37.3G  0 lvm   /usr
        └─fx0-home    254:6    0 184.7G  0 lvm   /home
    ....
    sdj                 8:144  1   7.5G  0 disk
    ├─sdj1              8:145  1   7.5G  0 part
    └─sdj2              8:146  1    64M  0 part

In my case i\`ll use */dev/sdj1*. Navegate to the download folder and
execute:

    root@7a1n0:/home/cb0n3y/Downloads# dd bs=4M if=debian-10.0.0-amd64-DVD-1.iso of=/dev/sdj1 status=progress & sync

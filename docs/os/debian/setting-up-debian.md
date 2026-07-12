# Configuring Debian


!!! warning "Scope"
    This guide covers configuring a desktop Debian install on x86
    hardware (GRUB, XFCE desktop environment, NetworkManager with GUI
    applet). It does not apply to headless Raspberry Pi OS setups used
    in the homelab.

Your pc or laptop has already restarted, enter the password to access
the encrypted disk and login with your credentials. Debian doesn't have
the sudo package installed by default, so the first thing we'll do is
switch to root:

    dkm@1k4ru5:~$ su -
    root@1k4ru5:/home/dkm#

## Change your source.list

The first thing we'll do is change the sources.list of our operating
system. sources.list can be found at /etc/apt/. Delete all and paste
this in sources.list

    #------------------------------------------------------------------------------#
    OFFICIAL DEBIAN REPOS
    #------------------------------------------------------------------------------#
    Debian Main Repos
    deb http://ftp.de.debian.org/debian/ stable main contrib non-free
    deb-src http://ftp.de.debian.org/debian/ stable main contrib non-free
    deb http://ftp.de.debian.org/debian/ stable-updates main contrib non-free
    deb-src http://ftp.de.debian.org/debian/ stable-updates main contrib non-free

!!! note "`stable` vs versioned suite"
    Using `stable` instead of a codename (e.g. `bookworm`) means your
    system will follow whatever Debian currently calls stable — including
    major version upgrades when a new release happens. If you want to
    pin to a specific release, use the codename instead.

## Update and upgrade your system

```console
root@1k4ru5:/home/dkm# apt update && apt -y full-upgrade
```

## Install sudo and add your user to sudoers

We need to install the sudo package so we don't have to work with the
root account all the time.

```console
root@1k4ru5:/home/dkm# apt -y install sudo
```

Now we need to add our user to the list of users with high rights. For
this we use the following command:

```console
root@1k4ru5:/home/dkm# gpasswd -a dkm sudo
```

If this doesn't work, edit the content of `/etc/sudoers` and add your
user as follows:

    # User privilege specification
    root  ALL=(ALL:ALL) ALL
    dkm   ALL=(ALL:ALL) ALL

Just type `logout` on your terminal and login again. Now you can work
with sudo and administrate your system.

## Install a Desktop Environment

As I have written before, in this tutorial we will install XFCE as
desktop environment. Why do I install XFCE? Well,

- is available from the official sources,
- has a classic look,
- is fast and resource-saving,
- as well as very stable and future-proof, as it is very mature and
  is regularly further developed,
- uses the GTK+ toolkit.

To install xfce4:

```console
root@1k4ru5:/home/dkm# apt-get install xfce4 xfce4-goodies gnome-icon-theme
```

## Graphical login with the display manager

If you want to start directly into the desktop environment (GUI), you
can use a display manager. The display manager provides a login screen
for different users.

```console
root@1k4ru5:/home/dkm# apt-get install lightdm lightdm-gtk-greeter
```

The start behaviour (e.g. whether the graphical login should be started
directly) can be adjusted at any time in `/etc/default/grub`:

```console
root@1k4ru5:/home/dkm# vim /etc/default/grub
```

    # Here is the existing entry:
    GRUB_CMDLINE_LINUX_DEFAULT=""
    # Change it to:
    GRUB_CMDLINE_LINUX_DEFAULT="text"
    # Parameter explanation:
    # An empty entry “” means the graphical login is started directly.
    # The entry “text” means the terminal (console) is started after login.

Afterwards you have to update the grub settings:

```console
root@1k4ru5:/home/dkm# update-grub
```

The settings are only applied after a restart:

```console
root@1k4ru5:/home/dkm# reboot
```

## Network configuration via network manager

One way is to use the network manager to change the network settings.
The Network Manager is used to make network settings using a program
interface. If you want to adjust the network settings, it is recommended
to install the network manager afterwards:

```console
root@1k4ru5:/home/dkm# apt-get install network-manager network-manager-gnome
```

!!! note "`network-manager-gnome` in XFCE"
    This package is GNOME-branded but works fine in XFCE, since both
    share the GTK+ toolkit. It's not a copy-paste mistake — it's the
    standard applet used across most GTK-based desktop environments.

Afterwards you have to edit the following configuration file:

```console
root@1k4ru5:/home/dkm# vim /etc/NetworkManager/NetworkManager.conf
```

    [ifupdown]
    managed=true

In order for the NetworkManager to appear in the taskbar tray you have
to edit the following file:

```console
root@1k4ru5:/home/dkm# vim /etc/xdg/autostart/nm-applet.desktop
```

    ...
    Exec= change [nm-applet] in [dbus-launch nm-applet]

# Secure Installation

!!! warning "Scope"
    This guide applies to a traditional Debian install via the
    `debian-installer` TUI (laptop/VM/x86 server with local disk).
    It does **not** apply to Raspberry Pi OS, which uses image
    flashing instead of an interactive installer. For Pi-specific
    disk encryption, see [Raspberry Pi disk encryption](#) (TBD).


Follow the installation process until you reach the partitioning method
part and select *manual*. Select the HDD or SSD on which you want to
install debian and hit enter to create a new empty partition table,
select yes and hit enter. Now you will have something like:

    > pri/log 120.0 GB    FREE SPACE

In this tutorial the disk will be encrypted for better privacy and
partitioned as follows:

> -   **/boot**
> -   **/**
> -   **swap** \[Optional\]
> -   **/var**
> -   **/usr**
> -   **/tmp**
> -   **/opt**
> -   **/home**


## Create the boot partition

On the FREE SPACE
`Continue --> Create a new partiton --> New partition size:
550 MB --> Continue --> Primary --> Continue --> Location for the new partition:
Beginning --> Continue -->  Use as: ext4, Mount point: /boot --> Done setting up
the partition`.

## Create an Encrypted LVM

Select the rest *FREE SPACE* and
`Continue --> Create a new partition --> New
partition size: <the rest> --> Continue --> Logical --> Continue --> Use as:
physical volume for encryption --> Continue --> Done setting up the partition`.

Now select `Configure encrypted volumes`. You will be asked to confirm,
you want to continue with the process. Select
`yes --> Continue --> Encryption configuration
actions: Create encrypted volumes --> Continue --> with the arrows move up and down
to select the partition where you want to create your encrypted volume (actually
the one, which is not 550 MB) and select it with the Space key --> Continue -->
Finish`. You will be asked again to confirm, you want to erase the hole
partition for more privacy. The decision about this is all up to you,
i\`d suggest to erase the complete partition: `yes --> Continue`.

Once the wiping process is ready, you will be asked to enter a password
to encrypt the partition. Consider a password with lowercase letters,
capital letters, numbers, and special symbols to increase the difficulty
of a brute-force attack. Select "Configure the logical Volume Manager"
to create all the other partitions within the encrypted partition.
Another question will be shown to you: Write the changes to the disk and
configure LVM?, select *yes -->; Continue -->; Create volume group
-->; Continue -->; enter a name for your encrypted volume: e.g. edx0
-->; Device for the new volume group: select the one with the highest
capacity*

*Create logical volume -->; Continue -->; Logical volume name: root
-->; Continue -->; Logical volume size: 1024 MB -->; Continue*\*.
If you want to have a swap partition, now would be the right time to do
so. If you don't want a swap, follow the same steps as for creating the
root partition with the following parameters:

!!! note "Root partition size"
    The `root` (`/`) logical volume is intentionally small (1024 MB / 1GB).
    This is not an error — since `/var`, `/usr`, `/opt`, and `/tmp` are
    split into their own logical volumes, `/` only needs to hold the bare
    minimum of the base system. This fine-grained partitioning scheme is
    a deliberate design choice, not an oversight.

> -   **/var**: 10 GB
> -   **/usr**: 40 GB
> -   **/tmp**: 1 GB
> -   **/opt**: 4 GB
> -   **/home**: the rest

When you have created the last partition, select finish to finish. It's
time to assign each of the created partitions a mount point. Go to:

    LVM VG edx0, LV home - 60.0 GB Linux device-mapper (linear)
    > #1  60.0 GB

*Continue -->; Use as: Ext4 journaling file system -->; Continue
-->; Mount point: select /home - user home directories -->; Continue
-->; Done setting up the partition*. Perform this step with all
remaining partitions, just change the mount points. Select *Finish
partition and write changes to disk* to write the changes made to the
disk.

!!! tip "Hint"
    In case you have not created a swap, you will be asked if you want
    to return to the partitioning menu — select no and continue.

Select *yes* to confirm that all the changes should be written to the
disk. When the menu is shown: *Choose software to install*, deselect all
and continue. Select where to install the GRUB boot loader and continue.
The Debian operating system installation is done.

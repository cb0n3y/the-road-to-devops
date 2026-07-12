# Debian

> 📦 Reference — written for x86 hardware (laptop/server) using the
> traditional `debian-installer` TUI. Partially applicable to
> Raspberry Pi OS as a Debian derivative, but not a 1:1 guide for it
> (see notes per page).

## Contents

- [Introduction](./introduction.md)
- [Secure installation](./secure-installation.md) — encrypted LVM
  partitioning via the manual installer. x86-only, does not apply to
  Raspberry Pi OS (image-based install).
- [Configuring Debian](./setting-up-debian.md) — post-install base
  config: sudo, sources.list, desktop environment (XFCE), display
  manager, NetworkManager. x86 desktop-oriented.

## Environment

Originally written and tested on:

- **Laptop**: Intel i5 dual-core, 12GB RAM, SSD

## Relevance to the homelab

Raspberry Pi OS is a Debian derivative, so some concepts here transfer
(package management via `apt`, `sources.list` structure, general
Debian conventions), but the installation and configuration mechanics
differ significantly:

| | Debian x86 (this section) | Raspberry Pi OS |
|---|---|---|
| Install method | Interactive `debian-installer` TUI | Image flashing (`rpi-imager`/`dd`) |
| Disk encryption | LVM + LUKS during install | Manual LUKS setup post-flash |
| Desktop environment | XFCE + LightDM (this guide) | Usually headless in this homelab |
| Bootloader | GRUB | Raspberry Pi firmware/bootloader |

A dedicated `raspberry-pi-os/` section will cover the Pi-specific
equivalents once documented.
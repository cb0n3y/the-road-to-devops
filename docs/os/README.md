# Operating Systems

Notes and setup guides for the operating systems used across my
infrastructure and homelab — from base installation to hardening and
configuration.

## Distros

| Distro | Status | Description |
|---|---|---|
| [Debian](./debian/README.md) | 📦 Reference | x86 desktop install notes (secure/encrypted install, base config, desktop environment). Partially applicable to Raspberry Pi OS as a Debian derivative. |

## Context

Most of the content here was originally written for x86 hardware
(laptops/servers) using the traditional `debian-installer` TUI. The
homelab itself runs on **Raspberry Pi OS** (a Debian derivative) using
image flashing rather than an interactive installer, so not everything
here applies directly — guides are labeled where the scope differs.

## Roadmap

- [x] Migrate Debian x86 install/config notes (historical reference)
- [ ] Document Raspberry Pi OS setup (flashing, headless config, SSH)
- [ ] Raspberry Pi OS hardening checklist
- [ ] Disk encryption on Raspberry Pi (LUKS, post-flash)

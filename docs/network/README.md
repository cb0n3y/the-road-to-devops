# Network

## Overview

Networking is one of the fundamental pillars of DevOps. Every infrastructure, whether on-premises, cloud, or hybrid, depends on reliable networking services for communication between applications, servers, containers, and users.

This section contains practical guides and labs covering common networking services and tools used in modern infrastructures.

The goal is to understand **how things work**, **how to deploy them**, and **how to troubleshoot them**.

---

## Topics

### DNS

The Domain Name System (DNS) translates human-readable names into IP addresses. Every infrastructure depends on DNS for service discovery.

Current guides:

* **dnsmasq**

  * Lightweight DNS forwarder
  * Local DNS cache
  * Internal DNS server
  * DHCP integration
  * Static hostname resolution

---

## Learning Path

Recommended order:

1. Understand how DNS works.
2. Deploy an internal DNS server using **dnsmasq**.
3. Configure clients to use the internal resolver.
4. Add custom internal records.
5. Learn DNS troubleshooting.
6. Integrate DNS with virtualization or Kubernetes environments.

---

## Common Networking Commands

Check DNS resolution:

```bash
dig google.com

dig myserver.lab

nslookup myserver.lab
```

Query a specific DNS server:

```bash
dig @192.168.1.10 git.lab
```

View configured DNS servers:

```bash
cat /etc/resolv.conf
```

Check network interfaces:

```bash
ip addr
```

Display routing table:

```bash
ip route
```

Check listening DNS services:

```bash
ss -lntup | grep :53
```

---

## Best Practices

* Prefer internal DNS over editing `/etc/hosts`.
* Keep DNS records documented.
* Use descriptive hostnames.
* Separate internal and public DNS.
* Enable DNS caching when appropriate.
* Keep configurations under version control.

---

## Troubleshooting Checklist

When DNS is not working:

* Is the DNS service running?
* Is port 53 listening?
* Can clients reach the server?
* Are firewall rules allowing DNS traffic?
* Is `/etc/resolv.conf` pointing to the correct resolver?
* Does `dig` return the expected answer?
* Are logs reporting configuration errors?

---

## References

* RFC 1034 - Domain Names
* RFC 1035 - Domain Name System
* dnsmasq documentation

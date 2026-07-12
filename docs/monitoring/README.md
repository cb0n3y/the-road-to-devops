# Monitoring

This section documents the monitoring and observability tools used in my
homelab, both the active stack and historical references from previous
projects/jobs.

## Active stack

| Tool | Status | Description |
|---|---|---|
| [Prometheus](./prometheus/README.md) | 🚧 In progress | Metrics collection (time-series) |
| [Grafana](./grafana/README.md) | 🚧 In progress | Visualization and dashboards |

## Historical reference

| Tool | Status | Description |
|---|---|---|
| [Zabbix](./zabbix/README.md) | 📦 Archived | Setup used in a previous job (RHEL/CentOS). Kept as reference only, not actively used in this homelab. |

## Context

The active homelab stack is **Prometheus + Grafana**, running on a
Raspberry Pi 5 cluster. The Zabbix documentation is kept because it's
still useful as a reference for monitoring patterns (alerting, templates,
server/agent architecture), even though the concrete implementation
(RHEL + MySQL) doesn't apply to the current environment.

## Roadmap

- [x] Document Zabbix setup (historical)
- [ ] Install Prometheus on Raspberry Pi 5
- [ ] Install Grafana on Raspberry Pi 5
- [ ] Exporters: `node_exporter`, `fritzbox_exporter`, `nextdns_exporter`
- [ ] Initial dashboards (FritzBox, NextDNS)
- [ ] Alerting rules + Alertmanager

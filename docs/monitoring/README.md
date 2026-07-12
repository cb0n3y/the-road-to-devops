# Monitoring

Esta sección documenta las herramientas de monitorización y observabilidad
usadas en mi homelab, tanto las actuales como las de referencia histórica
de proyectos/trabajos anteriores.

## Stack activo

| Herramienta | Estado | Descripción |
|---|---|---|
| [Prometheus](./prometheus/README.md) | 🚧 En construcción | Recolección de métricas (time-series) |
| [Grafana](./grafana/README.md) | 🚧 En construcción | Visualización y dashboards |

## Referencia histórica

| Herramienta | Estado | Descripción |
|---|---|---|
| [Zabbix](./zabbix/README.md) | 📦 Archivado | Setup usado en un puesto de trabajo anterior (RHEL/CentOS). Se mantiene como referencia, no está en uso activo en este homelab. |

## Contexto

El stack activo del homelab es **Prometheus + Grafana**, corriendo sobre un
clúster de Raspberry Pi 5. La documentación de Zabbix se conserva porque
sigue siendo útil como referencia de patrones de monitorización (alerting,
templates, arquitectura server/agent), aunque la implementación concreta
(RHEL + MySQL) no aplica al entorno actual.

## Roadmap

- [x] Documentar setup de Zabbix (histórico)
- [ ] Instalar Prometheus en Raspberry Pi 5
- [ ] Instalar Grafana en Raspberry Pi 5
- [ ] Exporters: `node_exporter`, `fritzbox_exporter`, `nextdns_exporter`
- [ ] Dashboards iniciales (FritzBox, NextDNS)
- [ ] Alerting rules + Alertmanager
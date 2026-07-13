#!/usr/bin/env bash
set -e

dnf install -y kibana logstash

# Kibana
sed -i 's/^#server.host:.*/server.host: "0.0.0.0"/' /etc/kibana/kibana.yml
sed -i "s|^#elasticsearch.hosts:.*|elasticsearch.hosts: [\"http://localhost:9200\"]|" /etc/kibana/kibana.yml

firewall-cmd --add-port=5601/tcp --permanent 2>/dev/null || true
firewall-cmd --add-port=5044/tcp --permanent 2>/dev/null || true
firewall-cmd --reload 2>/dev/null || true

systemctl enable --now kibana
systemctl enable --now logstash

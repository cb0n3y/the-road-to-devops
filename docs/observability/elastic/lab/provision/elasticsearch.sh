#!/usr/bin/env bash
set -e

NODE_NAME="$1"
SEED_HOSTS="$2"   # "dev-elk01,dev-elk02,dev-elk03"

# Repo oficial de Elastic
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
cat > /etc/yum.repos.d/elastic.repo <<EOF
[elasticsearch]
name=Elastic repository
baseurl=https://artifacts.elastic.co/packages/8.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

dnf install -y elasticsearch

# Test: configure SELinux to allow Elasticsearch to run
mkdir -p /var/log/elasticsearch
chown elasticsearch:elasticsearch /var/log/elasticsearch

restorecon -Rv /usr/share/elasticsearch
restorecon -Rv /var/log/elasticsearch
restorecon -Rv /etc/elasticsearch
restorecon -Rv /var/lib/elasticsearch

systemctl restart elasticsearch
systemctl status elasticsearch

CONF=/etc/elasticsearch/elasticsearch.yml

cat > "$CONF" <<EOF
cluster.name: dev-elk-cluster
node.name: ${NODE_NAME}
network.host: 0.0.0.0
discovery.seed_hosts: [${SEED_HOSTS//,/, }]
cluster.initial_master_nodes: [${SEED_HOSTS//,/, }]
xpack.security.enabled: false
xpack.security.enrollment.enabled: false
xpack.security.http.ssl.enabled: false
xpack.security.transport.ssl.enabled: false
EOF

# Desactivar seguridad/TLS para simplificar el entorno de dev
# sed -i 's/xpack.security.enabled: true/xpack.security.enabled: false/' "$CONF" || \
#   echo "xpack.security.enabled: false" >> "$CONF"

firewall-cmd --add-port=9200/tcp --permanent 2>/dev/null || true
firewall-cmd --add-port=9300/tcp --permanent 2>/dev/null || true
firewall-cmd --reload 2>/dev/null || true

systemctl daemon-reload
systemctl enable --now elasticsearch

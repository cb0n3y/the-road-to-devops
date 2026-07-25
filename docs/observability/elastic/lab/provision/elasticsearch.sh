#!/usr/bin/env bash
set -e

NODE_NAME="$1"
SEED_HOSTS="$2"   # "dev-elk01,dev-elk02,dev-elk03"

# --- Repo oficial de Elastic ---
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

# --- Directorios de datos y logs, ANTES de arrancar nada ---
# (Error 2 y 3 del troubleshooting: faltaba crear/dar permisos a data y logs
#  antes del primer arranque del servicio)
mkdir -p /var/lib/elasticsearch /var/log/elasticsearch
chown -R elasticsearch:elasticsearch /var/lib/elasticsearch /var/log/elasticsearch

ln -sf /var/lib/elasticsearch /usr/share/elasticsearch/data
ln -sf /var/log/elasticsearch /usr/share/elasticsearch/logs
chown -h elasticsearch:elasticsearch /usr/share/elasticsearch/data /usr/share/elasticsearch/logs

restorecon -Rv /usr/share/elasticsearch
restorecon -Rv /var/log/elasticsearch
restorecon -Rv /var/lib/elasticsearch
restorecon -Rv /etc/elasticsearch

# --- Config final, ANTES del primer arranque ---
# (Error 1 y Error 4 del troubleshooting: si el servicio arranca antes de que
#  exista esta config, ES activa auto-configuración de seguridad/TLS, y un
#  simple `enable --now` sobre un servicio ya activo NO recarga el yml)
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

# --- Firewall ---
firewall-cmd --add-port=9200/tcp --permanent 2>/dev/null || true
firewall-cmd --add-port=9300/tcp --permanent 2>/dev/null || true
firewall-cmd --reload 2>/dev/null || true

# --- Un único arranque, ya con todo en su lugar ---
systemctl daemon-reload
systemctl enable --now elasticsearch

# Espera activa a que responda, útil para no encadenar provisioners
# (kibana_logstash.sh) contra un ES que todavía está iniciando
for i in $(seq 1 30); do
  if curl -s -o /dev/null http://localhost:9200; then
    echo "Elasticsearch respondiendo en el nodo ${NODE_NAME}."
    break
  fi
  echo "Esperando a Elasticsearch... (${i}/30)"
  sleep 2
done

systemctl status elasticsearch --no-pager

# Troubleshooting — Cluster ELK (dev-elk01/02/03)

Notas de los errores encontrados durante el provisioning inicial del cluster,
con los comandos de diagnóstico y las causas raíz. Sirve como referencia si
se vuelve a hacer `vagrant destroy && vagrant up` y algo falla parecido.

---

## Error 1 — Elasticsearch no arranca: auto-configuración de seguridad (TLS/enrollment)

**Síntoma:** el servicio fallaba al iniciar en el primer `vagrant up`.

**Causa:** Elasticsearch 8.x, si no encuentra `xpack.security.enabled: false`
explícito en `elasticsearch.yml` en el momento del *primer arranque*, dispara
su auto-configuración de seguridad (genera certificados TLS, habilita
enrollment, exige password de `elastic`). El script no tenía esas líneas
todavía cuando el paquete instaló y arrancó el servicio por primera vez.

**Fix:** agregar al `elasticsearch.yml` antes del primer arranque:

```yaml
xpack.security.enabled: false
xpack.security.enrollment.enabled: false
xpack.security.http.ssl.enabled: false
xpack.security.transport.ssl.enabled: false
```

---

## Error 2 — `exit code 78`: no puede crear el directorio de logs

**Comando que lo mostró:**
```bash
sudo systemctl status elasticsearch.service
```

**Log relevante:**
```
Process: 16928 ExecStart=/usr/share/elasticsearch/bin/systemd-entrypoint -p ${PID_DIR}/elasticsearch.pid --quiet (code=exited, status=78)
Jul 13 16:35:17 dev-elk01 systemd-entrypoint[16928]: ERROR: Unable to create logs dir [/usr/share/elasticsearch/logs], with exit code 78
```

**Causa:** `/usr/share/elasticsearch/logs` es (o debería ser) un symlink hacia
`/var/log/elasticsearch`. El symlink no existía o el proceso no tenía permiso
para crearlo — probablemente por SELinux o por orden de ejecución (el
`restorecon` corrió antes de que el paquete terminara de dejar todo en su
lugar esperado).

**Diagnóstico:**
```bash
sudo ls -la /usr/share/elasticsearch/logs
ls -ld /var/log/elasticsearch
getenforce
```

**Fix:**
```bash
sudo mkdir -p /var/log/elasticsearch
sudo chown -R elasticsearch:elasticsearch /var/log/elasticsearch
sudo ln -sf /var/log/elasticsearch /usr/share/elasticsearch/logs
sudo chown -h elasticsearch:elasticsearch /usr/share/elasticsearch/logs
sudo restorecon -Rv /var/log/elasticsearch /usr/share/elasticsearch
```

---

## Error 3 — `exit code 1`: `AccessDeniedException` en el directorio de datos

**Log relevante:**
```
[ERROR][o.e.b.Elasticsearch] [dev-elk01] fatal exception while booting Elasticsearch
org.elasticsearch.ElasticsearchException: Failed to bind service
Caused by: java.nio.file.AccessDeniedException: /usr/share/elasticsearch/data
    at java.base/sun.nio.fs.UnixFileSystemProvider.createDirectory(...)
    at org.elasticsearch.env.NodeEnvironment.<init>(NodeEnvironment.java:281)
```

**Causa:** mismo problema que el Error 2, pero con el directorio de datos
(`/usr/share/elasticsearch/data` → `/var/lib/elasticsearch`). El script solo
creaba y ajustaba permisos del directorio de **logs**, no del de **data**.

**Diagnóstico:**
```bash
sudo ls -la /usr/share/elasticsearch/ | grep -E "data|logs"
sudo ls -ld /var/lib/elasticsearch
```

**Fix:**
```bash
sudo mkdir -p /var/lib/elasticsearch
sudo chown -R elasticsearch:elasticsearch /var/lib/elasticsearch
sudo ln -sf /var/lib/elasticsearch /usr/share/elasticsearch/data
sudo chown -h elasticsearch:elasticsearch /usr/share/elasticsearch/data
sudo restorecon -Rv /var/lib/elasticsearch /usr/share/elasticsearch
```

---

## Error 4 — El puerto 9200 responde pero cierra la conexión (`empty reply from server`)

**Síntoma:**
```bash
curl -v localhost:9200
# Empty reply from server
# curl: (52) Empty reply from server
```

**Log relevante (se repite en loop):**
```
[WARN ][o.e.h.n.Netty4HttpServerTransport] [dev-elk01] received plaintext http
traffic on an https channel, closing connection Netty4HttpChannel{...}
```

**Causa raíz (la importante — bug del script, no solo de la VM):**
`/etc/elasticsearch/elasticsearch.yml` en disco decía
`xpack.security.enabled: false`, pero el **proceso corriendo** había arrancado
con seguridad y TLS activados. El archivo y el proceso vivo estaban
desincronizados porque el script hacía, en este orden:

1. `dnf install elasticsearch` (el paquete auto-arranca / queda listo para arrancar con la config por defecto → seguridad ON)
2. `systemctl restart elasticsearch` ← **arranca con la config vieja/default**
3. *Recién acá* se sobreescribía `elasticsearch.yml` con `xpack.security.enabled: false`
4. `systemctl enable --now elasticsearch` ← como el servicio ya estaba activo, esto **no lo reinicia**, solo lo habilita en boot. La config nueva nunca se cargó.

Elasticsearch solo lee `elasticsearch.yml` al arrancar el proceso, nunca en caliente.

**Diagnóstico:**
```bash
sudo grep -i "xpack.security" /etc/elasticsearch/elasticsearch.yml   # decía false
sudo ls -la /etc/elasticsearch/certs/                                 # pero había certs TLS generados
curl -sk https://localhost:9200 -u elastic                            # esto SÍ respondía (con auth)
```

**Fix aplicado en caliente:**
```bash
sudo systemctl restart elasticsearch
curl -s localhost:9200   # ahora responde en texto plano, sin auth
```

**Fix real (de fondo):** corregir el orden del script de provisioning —
escribir el `.yml` final **antes** del único arranque del servicio. Ver
`provision/elasticsearch.sh` corregido.

---

## Resumen — reglas para no repetir estos errores

1. Crear y dar ownership a **ambos** directorios (`data` y `logs`, con sus
   symlinks) antes de tocar el servicio.
2. Escribir el `elasticsearch.yml` definitivo **antes** del primer arranque.
   Nunca reinstalar → arrancar → reconfigurar → arrancar de nuevo.
3. Arrancar el servicio **una sola vez**, al final, con `systemctl enable --now`.
4. `restorecon -Rv` sobre `/usr/share/elasticsearch`, `/var/lib/elasticsearch`
   y `/var/log/elasticsearch` si SELinux está en `Enforcing`.
5. Si algo queda en un estado raro, no asumir que `systemctl restart` sin
   antes revisar `journalctl -xeu elasticsearch` — el exit code (78 vs 1)
   indica en qué capa está el problema (78 = filesystem/permisos antes de
   iniciar la JVM; 1 = falló durante el boot de Elasticsearch mismo).

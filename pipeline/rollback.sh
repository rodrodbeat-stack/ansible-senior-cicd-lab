#!/bin/bash
set -e
cd /root/ansible-senior

for ENV in dev qa prod; do
  if [ -f "backups/$ENV.html" ]; then
    cp "backups/$ENV.html" "/var/www/$ENV/index.html"
    echo "Recuperado: $ENV"
  else
    echo "No existe backup de $ENV"
  fi
done

nginx -t
systemctl reload nginx

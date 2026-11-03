#!/bin/bash
set -e
cd /root/ansible-senior

echo "VALIDANDO ANSIBLE"
ansible-playbook -i inventory/hosts.ini site.yml --syntax-check

echo "VALIDANDO NGINX"
nginx -t

echo "DESPLEGANDO DEV"
ansible-playbook -i inventory/hosts.ini site.yml --limit dev
curl -fsS http://localhost:8081 >/dev/null

echo "DESPLEGANDO QA"
ansible-playbook -i inventory/hosts.ini site.yml --limit qa
curl -fsS http://localhost:8082 >/dev/null

echo "DEV Y QA OK"

read -r -p "¿Autorizar despliegue PROD? (si/no): " APPROVAL

if [[ "$APPROVAL" == "si" ]]; then
  ansible-playbook -i inventory/hosts.ini site.yml --limit prod
  curl -fsS http://localhost:8083
  echo "PROD DESPLEGADO"
else
  echo "PROD NO MODIFICADO"
fi

#!/bin/sh
SCRIPT_DIR=$(cd $(dirname $0);pwd)
BASE_DIR=$(cd $(dirname $0)/../;pwd)

for service in gblan-nginx gblan-mkcert gblan-gitbucket gblan-sshd gblan-dns gblan-share; do
  echo "clean ${service}"
  if [ -e ${BASE_DIR}/${service}/script/clean.sh ]; then
    sh ${BASE_DIR}/${service}/script/clean.sh
  fi
done

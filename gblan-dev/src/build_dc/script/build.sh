#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0);pwd)
BASE_DIR=$(cd $(dirname $0)/../;pwd)

for service in gblan-share gblan-dns gblan-sshd gblan-gitbucket gblan-mkcert gblan-nginx; do
  echo "build ${service}"
  if [ -e ${BASE_DIR}/${service}/script/build.sh ]; then
    sh ${BASE_DIR}/${service}/script/build.sh
  fi
done

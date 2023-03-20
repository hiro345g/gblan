#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0);pwd)
BUILD_DIR=$(cd $(dirname $0)/../build;pwd)
SAMPLE_DIR=$(cd $(dirname $0)/../sample;pwd)

for f in Corefile gblan_example_jp_hosts; do
  if [ ! -e ${BUILD_DIR}/${f} ]; then
    cp ${SAMPLE_DIR}/${f} ${BUILD_DIR}/;
  fi
done

docker compose -f ${BUILD_DIR}/docker-compose.yml build --no-cache

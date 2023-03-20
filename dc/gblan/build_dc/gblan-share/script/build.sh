#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0);pwd)
BUILD_DIR=$(cd $(dirname $0)/../build;pwd)
SERVICE_NAME=gblan
NETWORK_NAME=${SERVICE_NAME}-net
NETWORK_SUBNET=192.168.50.0
NETWORK_GATEWAY=192.168.50.1

## Docker ボリュームの作成
docker compose -f ${BUILD_DIR}/docker-compose.yml run --rm ${SERVICE_NAME}-share-build \
    echo "${SERVICE_NAME}-share-data init"

## Docker ネットワークの作成
docker network ls --filter "name=${NETWORK_NAME}" | grep ${NETWORK_NAME}
if [ $? -ne 0 ]; then
    docker network create --subnet ${NETWORK_SUBNET}/24 --gateway ${NETWORK_GATEWAY} ${NETWORK_NAME}
else
    echo "${NETWORK_NAME} network already exists"
fi

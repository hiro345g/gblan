#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0);pwd)
BUILD_DIR=$(cd $(dirname $0)/../../;pwd)
SERVICE_NAME=gblan-dev
NETWORK_NAME=${SERVICE_NAME}-net

# ボリュームの削除
volume_list=${SERVICE_NAME}-share-data
for v in ${volume_list}; do
    docker volume ls --filter "name=${v}" | grep ${v}
    if [ $? -eq 0 ]; then
        echo -n "volume remove ${v}: "
        docker volume remove ${v}
    else
        echo "volume ${v} already removed."
    fi
done

# ネットワークの削除
docker network ls --filter "name=${NETWORK_NAME}" | grep ${NETWORK_NAME}
if [ $? -eq 0 ]; then
    echo -n "network remove ${NETWORK_NAME}: "
    docker network remove ${NETWORK_NAME}
else
    echo "network ${NETWORK_NAME} already removed."
fi

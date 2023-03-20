#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0);pwd)
BUILD_DIR=$(cd $(dirname $0)/../build;pwd)
TAG_NAME=$(cat ${BUILD_DIR}/docker-compose.yml|grep image|awk '{print $2}')

# イメージの削除
docker image ls ${TAG_NAME} |grep -v "TAG"
if [ $? -eq 0 ]; then
    echo "docker image rm ${TAG_NAME}"
    docker image rm ${TAG_NAME}
fi

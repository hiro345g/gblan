#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0);pwd)
BUILD_DIR=$(cd $(dirname $0)/../;pwd)
TAG_NAME=$(cat ${BUILD_DIR}/docker-compose.yml|grep image|awk '{print $2}')

# ボリュームの削除
volume_list='gblan-dev-mkcert-root gblan-dev-mkcert-keys-data gblan-dev-mkcert-ws-data'
for v in ${volume_list}; do
    docker volume ls --filter "name=${v}" | grep ${v}
    if [ $? -eq 0 ]; then
        echo -n "volume remove ${v}: "
        docker volume remove ${v}
    else
        echo "volume ${v} already removed."
    fi
done

# イメージの削除
docker image ls ${TAG_NAME} |grep -v "TAG"
if [ $? -eq 0 ]; then
    echo "docker image rm ${TAG_NAME}"
    docker image rm ${TAG_NAME}
fi

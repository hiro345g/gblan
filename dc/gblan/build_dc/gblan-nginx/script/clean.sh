#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0);pwd)
BUILD_DIR=$(cd $(dirname $0)/../../;pwd)
SERVICE_NAME=gblan
NETWORK_NAME=${SERVICE_NAME}-net

# ボリュームの削除
volume_list='gblan-nginx-keys-data gblan-nginx-html-data gblan-nginx-templates-data'
for v in ${volume_list}; do
    docker volume ls --filter "name=${v}" | grep ${v}
    if [ $? -eq 0 ]; then
        echo -n "volume remove ${v}: "
        docker volume remove ${v}
    else
        echo "volume ${v} already removed."
    fi
done

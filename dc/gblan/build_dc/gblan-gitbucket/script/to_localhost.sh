#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0);pwd)
DEV_DIR=$(cd $(dirname $0)/..;pwd)
SAMPLE_DIR=$(cd $(dirname $0)/../sample;pwd)

# 起動
docker compose -f ${DEV_DIR}/docker-compose.yml up -d

# コンテナー起動のチェック
echo "check gblan-gitbucket-build"
until docker compose -f ${BUILD_DIR}/docker-compose.yml logs |grep "oejs.Server:main: Started"; do
    >&2 echo "sleeping"
    sleep 5
done

# gitbucket.localhost.conf のコピー
docker compose -p gblan cp ${SAMPLE_DIR}/gitbucket.localhost.conf gblan-gitbucket-build:/gitbucket/gitbucket.conf

# コンテナーの停止
docker compose -f ${BUILD_DIR}/docker-compose.yml down

#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0);pwd)
BUILD_DIR=$(cd $(dirname $0)/../build;pwd)
SAMPLE_DIR=$(cd $(dirname $0)/../sample;pwd)

# gblan-dev-gitbucket-data ボリューム初期化のために起動
docker compose -f ${BUILD_DIR}/docker-compose.yml up -d

# コンテナー起動のチェック
echo "check gblan-dev-gitbucket-build"
until docker compose -f ${BUILD_DIR}/docker-compose.yml logs |grep "oejs.Server:main: Started"; do
    >&2 echo "sleeping"
    sleep 5
done

# プラグインのダウンロード対応
docker compose -p gblan-dev cp ${SCRIPT_DIR}/download_plugin.sh gblan-dev-gitbucket-build:/download_plugin.sh
docker compose -p gblan-dev exec gblan-dev-gitbucket-build sh /download_plugin.sh

# gitbucket.conf、database.conf のコピー。用意されていない場合はサンプルを使用
if [ ! -e  ${BUILD_DIR}/gitbucket.conf ]; then
    cp ${SAMPLE_DIR}/gitbucket.conf ${BUILD_DIR}/
fi
docker compose -p gblan-dev cp ${BUILD_DIR}/gitbucket.conf gblan-dev-gitbucket-build:/gitbucket/
if [ ! -e  ${BUILD_DIR}/database.conf ]; then
    cp ${SAMPLE_DIR}/database.conf ${BUILD_DIR}/
fi
docker compose -p gblan-dev cp ${BUILD_DIR}/database.conf gblan-dev-gitbucket-build:/gitbucket/

# コンテナーの停止
docker compose -f ${BUILD_DIR}/docker-compose.yml down

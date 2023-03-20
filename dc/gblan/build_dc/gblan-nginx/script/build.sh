#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0);pwd)
BUILD_DIR=$(cd $(dirname $0)/../build;pwd)
SAMPLE_DIR=$(cd $(dirname $0)/../sample;pwd)

# 証明書作成用コンテナーの起動
docker compose -f ${BUILD_DIR}/ssl/docker-compose.yml up -d

# 証明書作成用コンテナーの起動チェック
echo "check gblan-mkcert-ssl"
until docker compose -f ${BUILD_DIR}/ssl/docker-compose.yml logs | grep "gblan-mkcert"; do
    >&2 echo "sleeping"
    sleep 5
done

# 証明書の用意と gblan-share-data ボリュームへの保管
docker compose -p gblan exec gblan-mkcert-ssl sh /script/gen.sh dev.gblan.example.jp
docker compose -p gblan exec gblan-mkcert-ssl sh /script/gen.sh www.gblan.example.jp
docker compose -p gblan exec gblan-mkcert-ssl cp -r /mkcert-keys /share/

# 証明書作成用コンテナーの削除
docker compose -p gblan down

# gblan-nginx用 ボリューム初期化のために起動
docker compose -f ${BUILD_DIR}/docker-compose.yml up -d

# コンテナー起動のチェック
echo "check gblan-nginx-build"
until docker compose -f ${BUILD_DIR}/docker-compose.yml logs |grep "start worker processes"; do
    >&2 echo "sleeping"
    sleep 5
done

# gblan-share-data ボリュームから証明書のコピー
docker compose -p gblan exec gblan-nginx-build sh -c 'if [ ! -e /etc/nginx/keys ]; then mkdir /etc/nginx/keys; fi'
docker compose -p gblan exec gblan-nginx-build sh -c 'cd /share/mkcert-keys; tar cf - certs private|tar xf - -C /etc/nginx/keys'

# htdocs, templates のコピー。用意されていない場合はサンプルを使用
if [ ! -e  ${BUILD_DIR}/html ]; then
    cp -r ${SAMPLE_DIR}/html ${BUILD_DIR}/
fi
docker compose -p gblan cp ${BUILD_DIR}/html gblan-nginx-build:/usr/share/nginx/
if [ ! -e  ${BUILD_DIR}/templates ]; then
    cp -r ${SAMPLE_DIR}/templates ${BUILD_DIR}/
fi
docker compose -p gblan cp ${BUILD_DIR}/templates gblan-nginx-build:/etc/nginx/

# コンテナーの停止
docker compose -f ${BUILD_DIR}/docker-compose.yml down

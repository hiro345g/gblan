#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0);pwd)
BUILD_DIR=$(cd $(dirname $0)/../build;pwd)
SAMPLE_DIR=$(cd $(dirname $0)/../sample;pwd)

docker compose -f ${BUILD_DIR}/docker-compose.yml build --no-cache

# gblan-sshd-etc-ssh-data、gblan-sshd-home-data ボリューム初期化のために起動
docker compose -f ${BUILD_DIR}/docker-compose.yml up -d

# コンテナー起動のチェック
echo "check gblan-sshd-build"
until docker compose -f ${BUILD_DIR}/docker-compose.yml logs |grep "Server listening on"; do
    >&2 echo "sleeping"
    sleep 5
done

# sshd_config を gblan-sshd-etc-ssh-data ボリュームへコピー。用意されていない場合はサンプルを使用
if [ ! -e  ${BUILD_DIR}/sshd_config ]; then
    cp ${SAMPLE_DIR}/sshd_config ${BUILD_DIR}/
fi
docker compose -p gblan cp ${BUILD_DIR}/sshd_config gblan-sshd-build:/etc/ssh/

# コンテナーの停止
docker compose -f ${BUILD_DIR}/docker-compose.yml down

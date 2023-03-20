#!/bin/sh
#
# 単純に存在しているファイルのみバックアップ
#

BACKUP_DIR=/share/gblan-mkcert-data
CA_DIR=/root/.local/share/

# CA_DIR がない場合は作成
if [ ! -e ${CA_DIR} ]; then
    mkdir -p ${CA_DIR}
fi

# リストア。
cp -a ${BACKUP_DIR}/gblan-mkcert-data/* /mkcert-keys/
cp -a ${BACKUP_DIR}/ca ${CA_DIR}/mkcert
cp -a ${BACKUP_DIR}/ca/rootCA.pem /mkcert-keys/certs/rootCA.pem

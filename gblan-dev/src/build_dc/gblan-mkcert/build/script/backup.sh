#!/bin/sh
#
# 単純に存在しているファイルのみバックアップ
#

BACKUP_DIR=/share/gblan-dev-mkcert-data

# BACKUP_DIR がない場合は作成
if [ ! -e ${BACKUP_DIR} ]; then
    mkdir -p ${BACKUP_DIR}
fi

# 現在のものはすべて削除
for d in mkcert-keys ca; do
    if [ -e ${BACKUP_DIR}/${d} ]; then
        rm -fr rm -fr ${BACKUP_DIR}/${d}
    fi
done

# バックアップ
cp -r /mkcert-keys ${BACKUP_DIR}/
cp -r /root/.local/share/mkcert ${BACKUP_DIR}/ca

# ca/rootCA.pem と同じファイルなので下記ファイルは削除
if [ -e ${BACKUP_DIR}/mkcert-keys/certs/rootCA.pem ]; then
    rm ${BACKUP_DIR}/mkcert-keys/certs/rootCA.pem
fi

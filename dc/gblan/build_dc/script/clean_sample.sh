#!/bin/sh
SCRIPT_DIR=$(cd $(dirname $0);pwd)
BASE_DIR=$(cd $(dirname $0)/../;pwd)

list=$(cat << EOS
gblan-dns/build/Corefile
gblan-dns/build/gblan_example_jp_hosts
gblan-gitbucket/build/database.conf
gblan-gitbucket/build/gitbucket.conf
gblan-nginx/build/html/
gblan-nginx/build/templates/
gblan-sshd/build/sshd_config
gblan-util/docker-compose.yml
EOS
)

for target in ${list}; do
    if [ -e ${BASE_DIR}/${target} ]; then
        echo ${BASE_DIR}/${target}
        rm -fr ${BASE_DIR}/${target}
    fi
done

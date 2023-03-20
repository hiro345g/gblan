#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0);pwd)
BUILD_DC_DIRNAME=build_dc
SRC_DIR=$(cd ${SCRIPT_DIR}/../../;pwd)
BASE_DIR=$(cd ${SCRIPT_DIR}/../../..;pwd)
DIST_DIR=${BASE_DIR}/dist;
DEPLOY_DIR=$(cd ${SCRIPT_DIR}/../../../../dc;pwd)

cd ${BASE_DIR}
sh ${SCRIPT_DIR}/create_dist.sh
mv dist gblan
tar cf - gblan | tar xf - -C ${DEPLOY_DIR}/
rm -fr gblan/

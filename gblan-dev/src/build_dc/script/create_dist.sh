#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0);pwd)
BUILD_DC_DIRNAME=build_dc
SRC_DIR=$(cd ${SCRIPT_DIR}/../../;pwd)
BASE_DIR=$(cd ${SCRIPT_DIR}/../../..;pwd)
DIST_DIR=${BASE_DIR}/dist;

if [ ! -e ${DIST_DIR} ]; then mkdir ${DIST_DIR}; fi
if [ ! -e ${DIST_DIR}/${BUILD_DC_DIRNAME} ]; then mkdir ${DIST_DIR}/${BUILD_DC_DIRNAME}; fi

for f in sample.env docker-compose.yml; do
    cp ${SRC_DIR}/${f} ${DIST_DIR}/
done
cp -r ${SRC_DIR}/${BUILD_DC_DIRNAME} ${DIST_DIR}/

for f in $(find ${DIST_DIR}/${BUILD_DC_DIRNAME} -name "*.sh" -type f -print); do
    echo "gblan-dev:gblan ${f}"
    sed -i 's/gblan-dev/gblan/g' ${f}
done
for f in $(find ${DIST_DIR}/${BUILD_DC_DIRNAME}/${d} -name "*.yml" -type f -print); do
    echo "gblan-dev:gblan ${f}"
    sed -i 's/gblan-dev/gblan/g' ${f}
done
for f in $(find ${DIST_DIR}/${BUILD_DC_DIRNAME}/${d} -name "*.conf" -type f -print); do
    echo "gblan-dev:gblan ${f}"
    sed -i 's/gblan-dev/gblan/g' ${f}
done
for f in $(find ${DIST_DIR}/${BUILD_DC_DIRNAME} -name "*.template" -type f -print); do
    echo "gblan-dev:gblan ${f}"
    sed -i 's/gblan-dev/gblan/g' ${f}
done
for f in $(find ${DIST_DIR}/${BUILD_DC_DIRNAME} -name "*.md" -type f -print); do
    echo "gblan-dev:gblan ${f}"
    sed -i 's/gblan-dev/gblan/g' ${f}
done

echo "gblan-dev:gblan, 192.168.51:192.168.50 ${DIST_DIR}/docker-compose.yml"
cat ${SRC_DIR}/docker-compose.yml \
    | sed 's/gblan-dev/gblan/g' \
    | sed 's/192.168.51/192.168.50/g' \
    > ${DIST_DIR}/docker-compose.yml

echo "gblan-dev:gblan, 192.168.51:192.168.50 ${DIST_DIR}/${BUILD_DC_DIRNAME}/gblan-share/script/build.sh"
cat ${SRC_DIR}/${BUILD_DC_DIRNAME}/gblan-share/script/build.sh \
    | sed 's/gblan-dev/gblan/g' \
    | sed 's/192.168.51/192.168.50/g' \
    > ${DIST_DIR}/${BUILD_DC_DIRNAME}/gblan-share/script/build.sh

echo "gblan-dev:gblan, 192.168.51:192.168.50 ${DIST_DIR}/${BUILD_DC_DIRNAME}/gblan-dns/sample/gblan_example_jp_hosts"
cat ${SRC_DIR}/${BUILD_DC_DIRNAME}/gblan-dns/sample/gblan_example_jp_hosts \
    | sed 's/gblan-dev/gblan/g' \
    | sed 's/192.168.51/192.168.50/g' \
    > ${DIST_DIR}/${BUILD_DC_DIRNAME}/gblan-dns/sample/gblan_example_jp_hosts

echo 'clean_sample'
sh ${SRC_DIR}/${BUILD_DC_DIRNAME}/script/clean_sample.sh

echo 'rm ${DIST_DIR}/${BUILD_DC_DIRNAME}/script/{create_dist.sh,deploy.sh}'
rm ${DIST_DIR}/${BUILD_DC_DIRNAME}/script/create_dist.sh
rm ${DIST_DIR}/${BUILD_DC_DIRNAME}/script/deploy.sh

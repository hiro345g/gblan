#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0);pwd)
BUILD_DIR=$(cd $(dirname $0)/../build;pwd)

docker compose -f ${BUILD_DIR}/docker-compose.yml build --no-cache

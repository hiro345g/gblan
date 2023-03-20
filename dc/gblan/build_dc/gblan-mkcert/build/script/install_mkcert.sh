#!/bin/sh

if [ "x${VERSION}" = "x" ]; then VERSION=v1.4.4; fi
if [ "x${ARCH}" = "x" ]; then ARCH=linux-amd64; fi
if [ "x${URL}" = "x" ]; then
    URL="https://github.com/FiloSottile/mkcert/releases/download"
    URL=${URL}/${VERSION}/mkcert-${VERSION}-${ARCH}
fi

export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y \
        libnss3-tools \
        curl \
        git \
    && rm -rf /var/lib/apt/lists/* \
    && cd ${HOME} \
    && curl -s --output ${HOME}/mkcert -L ${URL} \
    && chmod 755 ${HOME}/mkcert

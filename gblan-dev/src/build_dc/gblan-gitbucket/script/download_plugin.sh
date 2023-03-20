#!/bin/sh

CI_PLUGIN_VERSION=1.11.0
NETWORK_PLUGIN_VERSION=1.9.2
PLUGIN_DIR=/gitbucket/plugins

/usr/bin/curl -s -O -L https://github.com/takezoe/gitbucket-ci-plugin/releases/download/${CI_PLUGIN_VERSION}/gitbucket-ci-plugin-${CI_PLUGIN_VERSION}.jar
/usr/bin/curl -s -O -L https://github.com/mrkm4ntr/gitbucket-network-plugin/releases/download/${NETWORK_PLUGIN_VERSION}/gitbucket-network-plugin_2.13-${NETWORK_PLUGIN_VERSION}.jar

mv *.jar ${PLUGIN_DIR}/

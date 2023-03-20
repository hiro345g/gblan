FROM ubuntu:22.04

ARG USER_UID=1000
ARG USER_NAME=gblan
ARG USER_PASS=pass001
ARG GROUP_NAME=gblan
ARG USER_GID=1000

COPY entrypoint.sh /

RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && apt-get install -y ssh git \
    && mkdir -p /run/sshd \
    && groupadd -g ${USER_GID} ${GROUP_NAME} \
    && useradd -m -s /usr/bin/bash -u ${USER_UID} -g ${USER_GID} ${USER_NAME} \
    && echo -n "${USER_NAME}:${USER_PASS}" | chpasswd \
    && chmod 755 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 22

#!/bin/sh
/usr/bin/ssh-keygen -A
exec /usr/sbin/sshd -D -e "$@"

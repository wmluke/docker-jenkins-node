#!/bin/sh

/etc/init.d/postgresql start
/usr/sbin/sshd -D

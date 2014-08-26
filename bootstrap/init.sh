#!/bin/sh

chown -R jenkins:jenkins /home/jenkins/.ssh
/etc/init.d/postgresql start
/usr/sbin/sshd -D

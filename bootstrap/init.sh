#!/bin/sh

chown -R jenkins:jenkins /home/jenkins
/etc/init.d/postgresql start
/usr/sbin/sshd -D

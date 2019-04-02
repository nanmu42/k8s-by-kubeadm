#!/usr/bin/env bash
# 将 master.localdomain 换为合适的值
echo "master.localdomain" > /etc/hostname
echo "127.0.0.1   master.localdomain" >> /etc/hosts
echo "::1   master.localdomain" >> /etc/hosts
# 不重启的情况下使修改生效
sysctl kernel.hostname=master.localdomain
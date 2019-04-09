#!/usr/bin/env bash

# 以一般用户运行下列命令，配置主节点所在实例的kubectl
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
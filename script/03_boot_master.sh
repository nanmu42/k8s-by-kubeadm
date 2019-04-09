#!/usr/bin/env bash
# Pass bridged IPv4 traffic to iptables’ chains. This is a requirement for some CNI plugins to work
sysctl net.bridge.bridge-nf-call-iptables=1

# flannel 要求指定该 pod-network-cidr
# 指定 image-repository 以使用国内镜像
kubeadm init --pod-network-cidr=10.244.0.0/16 --image-repository registry.cn-hangzhou.aliyuncs.com/google_containers

# 等待片刻，让系统准备好
echo 'sleep a while for k8s to get ready...'
sleep 15
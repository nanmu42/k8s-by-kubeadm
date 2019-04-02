#!/usr/bin/env bash
# 使用阿里云镜像
apt-get update && apt-get install -y apt-transport-https
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add - 
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF

apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

# 配置命令自动完成
echo "source <(kubectl completion bash)">> ~/.bashrc
echo "source <(kubeadm completion bash)">> ~/.bashrc

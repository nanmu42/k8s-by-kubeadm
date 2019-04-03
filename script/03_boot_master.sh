#!/usr/bin/env bash
# Pass bridged IPv4 traffic to iptables’ chains. This is a requirement for some CNI plugins to work
sysctl net.bridge.bridge-nf-call-iptables=1

# flannel 要求指定该 pod-network-cidr
# 指定 image-repository 以使用国内镜像
kubeadm init --pod-network-cidr=10.244.0.0/16 --image-repository registry.cn-hangzhou.aliyuncs.com/google_containers

# 等待片刻，让系统准备好
echo 'sleep a while for k8s to get ready...'
sleep 15

# （可选）让主节点上也能运行pod
# 这会提高资源利用率，代价是会降低主节点的安全性
kubectl taint nodes --all node-role.kubernetes.io/master-

# 部署 flannel 作为 CNI
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/a70459be0084506e4ec919aa1c114638878db11b/Documentation/kube-flannel.yml
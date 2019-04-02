# k8s by kubeadm

本教程简要阐述了使用kubeadm在国内网络环境搭建单主k8s集群的方法。

欢迎各种形式的建议、勘误及贡献。

# 开始搭建

## 先决条件

### 实例

* 一个或更多运行Ubuntu 16.04+/CentOS 7/Debian 9，2 GB以上内存，2核以上CPU的实例；
* 实例之间有网络联通；
* 确保每个实例有唯一的`hostname`, `MAC address`以及`product_uuid`（这个条件一般都能满足）：

```bash
# 查询MAC地址
ip link

# 查询 product_uuid
sudo cat /sys/class/dmi/id/product_uuid
```

### hostname

实例的`hostname`需要满足[DNS-1123](https://tools.ietf.org/html/rfc1123)规范：

* 字符集：数字、小写字母、`.`、`-`
* 以小写字母开头和结尾

正则表达式为：

```regexp
[a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*
```

修改`hostname`方式如下（`script/01_change_hostname.sh`）：

```bash
# 将 master.localdomain 换为合适的值
echo "master.localdomain" > /etc/hostname 
echo "127.0.0.1   master.localdomain" >> /etc/hosts
echo "::1   master.localdomain" >> /etc/hosts
# 不重启的情况下使修改生效
sysctl kernel.hostname=master.localdomain
```

### 禁用Swap

`kubelet`要求宿主实例的交换空间（Swap）禁用以正常工作。

```bash
# 查看实例的swap设备
# 如果没有输出，说明没有启用swap，可略过余下步骤
cat /proc/swaps

# 关闭swap
swapoff -a

# 清理相应的注册项
nano /etc/fstab
```

## 设置安全组

云上实例需要放行安全组中的下列指定TCP入方向（这里假设安全组的出方向TCP/UDP全部放行）：

* 主节点（Master）
  * 6443
  * 2379-2380
  * 10250-10252
* 从节点（Worker）
  * 10250
  * 30000-32767

以上为Kubernetes本身需要开放的端口。

**注意**，网络插件（CNI，容器网络接口）另有需要开放的端口，本教程使用Flannel（`vxlan`模式）作为CNI，需要额外放行下列入方向端口：

* UDP 8472

## 安装容器运行时

本教程使用Docker作为容器运行时，请参阅[这里](https://docs.docker.com/v17.12/install/#server)进行安装。

## 安装kubeadm, kubelet 和 kubectl

由于一些原因，官方源无法在国内使用，这里使用国内镜像进行安装：

* Ubuntu（`script/02_install_kubeadm_ubuntu.sh`）

```bash
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
```

* CentOS（`script/02_install_kubeadm_centos.sh`）

```bash
# 使用阿里云镜像
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
setenforce 0
yum install -y kubelet kubeadm kubectl
systemctl enable kubelet && systemctl start kubelet

# 配置命令自动完成
echo "source <(kubectl completion bash)">> ~/.bashrc
echo "source <(kubeadm completion bash)">> ~/.bashrc
```

## 启动主节点

选定一个实例作为主节点，运行下列命令（`script/03_boot_master.sh`）：

```bash
# Pass bridged IPv4 traffic to iptables’ chains. This is a requirement for some CNI plugins to work
sysctl net.bridge.bridge-nf-call-iptables=1

# flannel 要求指定该 pod-network-cidr
# 指定 image-repository 以使用国内镜像
kubeadm init --pod-network-cidr=10.244.0.0/16 --image-repository registry.cn-hangzhou.aliyuncs.com/google_containers

# （可选）让主节点上也能运行pod
# 这会提高资源利用率，代价是会降低主节点的安全性
kubectl taint nodes --all node-role.kubernetes.io/master-

# 部署 flannel 作为 CNI
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/a70459be0084506e4ec919aa1c114638878db11b/Documentation/kube-flannel.yml
```

## 启动从节点



# 参考文献

* https://kubernetes.io/docs/setup/independent/install-kubeadm/#check-required-ports
* https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/
* https://serverfault.com/questions/684771/best-way-to-disable-swap-in-linux
* https://github.com/coreos/flannel/blob/master/Documentation/backends.md#recommended-backends

# License

MIT License

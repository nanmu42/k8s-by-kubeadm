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

* 实例的交换空间（Swap）禁用

# License

MIT License

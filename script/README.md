# 便利脚本

希望这个文件夹内的脚本能够为你的部署和实验工作提供一些便利，脚本已经编号，请按编号从小到大运行，每个编号只应该运行一次。

部分脚本（`01`, `02`, `03`）需要使用root权限运行：

```bash
sudo bash ./script/03_boot_master.sh
```

部分脚本（`04`, `05`）请使用一般用户权限运行：

```bash
bash ./script/04_deploy_flannel.sh
```

建议在使用脚本之前先通读项目根目录的`README.md`，避免翻车。

如果遇到问题，可以先查阅[常见问题和解决方案]((https://github.com/nanmu42/k8s-by-kubeadm/issues?utf8=%E2%9C%93&q=label%3AQA+))。

注意：`script/01_change_hostname.sh`需要按你的实际需求做一些修改。
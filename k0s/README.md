# k0s - Kubernetes for everywhere

[k0s](https://k0sproject.io) is a lightwight open-source Kubernetes Distribution with all batteries included. It can be installed on cloud instances like the ones we've created in Hetzner but also on a single Raspberry Pi, a cluster of Pi's or bare-metal servers.

## Getting Started

1. ssh to the first Master Node we've created earlier (if you did not copied the address, shown in the terminal output, don't panic: you can find the IP address in `terraform.tfstate.backup`)
2. Download the latest version:
``` bash
curl -sSLf https://get.k0s.sh | sudo sh
```
3. Create a configuration file:
``` bash
k0s default-config > k0s.yaml
```
4. Modify `k0s.yaml` as needed, e.g. to add a [SAN](https://docs.k0sproject.io/v1.22.1+k0s.0/high-availability/?h=san#configuration-using-k0syaml-for-each-controller). This can be a Hetzner Cloud LoadBalancer, so you can access the cluster from the internet with kubectl or [Lens](https://k8slens.dev/). 
5. Provision the first controller:
``` bash
sudo k0s install controller -c k0s.yaml
```
6. Start the k0s service:
``` bash
sudo k0s start
```
7. Create tokens for the other master and the worker nodes:
``` bash
k0s token create --role=controller --expiry=1h > master-token-file
k0s token create --role=worker --expiry=1h > worker-token-file
```
8. ssh to the other two master nodes and add them to the cluster:
``` bash
# Download binaries
curl -sSLf https://get.k0s.sh | sudo sh
# Run installation
sudo k0s install controller --token-file /path/to/token/file
# Start service
sudo k0s start
```
9. ssh to the each worker node and add them to the cluster:
``` bash
# Download binaries
curl -sSLf https://get.k0s.sh | sudo sh
# Run installation
sudo k0s install worker --token-file /path/to/token/file
# Start service
sudo k0s start
```
Done. You now got Kubernetes cluster with 3 master nodes and 4 worker nodes. 

> The volumes attached to the worker nodes can be used for [local-volume-provisioning](https://kubernetes.io/blog/2019/04/04/kubernetes-1.14-local-persistent-volumes-ga/). Hetzner Cloud offers a [CSI (container storage interface) driver](https://github.com/hetznercloud/csi-driver) too, so you can dynamically create persistent volumes in your Kubernetes Cluster, using volumes in your Hetzner Cloud project. 
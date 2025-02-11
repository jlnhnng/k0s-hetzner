# Production-grade Kubernetes Cluster Provisioning in Hetzner Cloud with Terraform and k0sctl

![GitHub forks](https://img.shields.io/github/forks/jlnhnng/k0s-hetzner?style=social)
![GitHub Repo stars](https://img.shields.io/github/stars/jlnhnng/k0s-hetzner?style=social)

The purpose of this repo is to share a simple way to provision Infrastructure in Hetzner Cloud via Terraform for a Kubernetes Cluster. The resources will be used to create a [k0s Cluster](https://k0sproject.io/).

Hetzner Cloud is a great cloud provider which offers a truly great service with a good performance/cost ratio. With Hetzner's Cloud Controller Manager and CSI driver it's possible to automatically provision load balancers and persistent volumes very easily.

This config will create 7 servers, within a private network, for a Kubernetes Cluster: 
- 3 Master Nodes with each 2 vCPUs and 4 GB RAM (CX21)
- 3 Worker Nodes with each 2 vCPUs, 8 GB RAM (CX31)
- 1 Private Network (10.0.0.0/8) with 1 Subnet (10.250.0.0/24)

### Prerequesites
- Hetzner Cloud Account: [Referal Link](https://hetzner.cloud/?ref=n2kb4hM7PmYQ)
- Create a Hetzner Cloud API Key: [How-To](https://docs.hetzner.cloud/#getting-started)
- Add your SSH Key in your Hetzner Cloud Project: [How-To](https://community.hetzner.com/tutorials/add-ssh-key-to-your-hetzner-cloud#step-2---add-the-ssh-key-to-your-hetzner-cloud-console)
- Terraform CLI: [How-To](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- k0sctl [How-to](https://github.com/k0sproject/k0sctl#installation)

### Prepare environment
With the following steps we will create the resources mentioned above:
1. Clone this repo
2. Modify `terraform.tfvars`, add your API Key and at least the your SSH Fingerprint.
3. Add SSH Key to `cloudinit/cloud-init.yaml.cfg` (line 13)
4. Change the username in `cloudinit/cloud-init.yaml.cfg` (line 8 and 30)
5. Change the username in `k0sctl.tpl.yaml` (line 10 and 21)
6. Run `terraform init` and check if everything looks good
7. Run `terraform plan` and check if everything looks good
8. Run `terraform apply` and give it approx. 2 minutes

> You can add more customizations in the cloud-init file if needed

## k0s - Zero Friction Kubernetes
Now that you got all resources ready, we can install a k0s cluster within a few minutes to create a production grade Kubernetes cluster. 

[k0s](https://k0sproject.io) is a lightwight open-source Kubernetes Distribution with all batteries included. It can be installed on cloud instances like the ones we've created in Hetzner but also in public clouds, on bare-metal servers, on a single Raspberry Pi or a cluster of Pi's.

### Getting Started with k0s

With k0sctl the installation of a production-grade cluster is completly automated, as well as Day 2 operations like scaling or upgrading the cluster. 

To run k0sctl we first need to download it. In this instruction I will use homebrew:

``` bash
brew install k0sproject/tap/k0sctl
```

> Note: Please check the [k0sctl readme](https://github.com/k0sproject/k0sctl?tab=readme-ov-file#installation) for other installation methods. 

Given a configuration file that defines the desired cluster state, k0sctl connects to the listed hosts, checks their current state, and configures them as needed to form a k0s cluster.

```
k0sctl apply --config k0s/k0sctl.yaml
```

You now have a Kubernetes cluster with 3 master nodes and 3 worker nodes. 

### Hetzner Cloud Integration

Hetzner Cloud offers useful integration tooling for Kubernetes and Hetzner Cloud Projects. 

Let's start with adding our API Key to the YAML file `hetzner/hcloud-secret.yaml` for the secret, so the Cloud Controller Manager and the Container Storage Interface Driver can connect with our Hetzner Cloud Project. After this change we need to apply the YAML to our k0s cluster:

``` bash
# Grab kubeconfig file from previously created cluster
k0sctl kubeconfig  --config k0sctl.yaml > kubeconfig

# Apply hcloud secret manifest
kubectl apply -f 'hetzner/hcloud-secret.yaml' --kubeconfig kubeconfig
```

#### Hetzner Cloud CCM

Hetzner Cloud offers a [Kubernetes Cloud Controller Manager for Hetzner Cloud](https://github.com/hetznercloud/hcloud-cloud-controller-manager). This CCM is useful if we want to create Loadbalancer Services, Zones in Kubernetes, use private networks of Hetzner for Pods or make Kubernetes more aware of the nodes in a Hetzner Cloud Project.

``` bash
# Add Hetzner Cloud helm chart repository
helm repo add hcloud https://charts.hetzner.cloud
helm repo update hcloud

# Install the latest version of the hcloud ccm chart.
helm install hccm hcloud/hcloud-cloud-controller-manager --set networking.enabled=true -n kube-system
```

#### Hetzner Cloud CSI

Hetzner Cloud offers a [CSI (container storage interface) driver](https://github.com/hetznercloud/csi-driver), so you can dynamically create persistent volumes in your Kubernetes Cluster, using volumes in your Hetzner Cloud project.

For k0s there needs to be some small changes since kubelet is in a different directory with k0s.

``` bash
# Install the latest version of the csi-driver chart.
helm install hcloud-csi hcloud/hcloud-csi -n kube-system --set node.kubeletDir=/var/lib/k0s/kubelet
```

Done. You now have a fully functional and production grade Kubernetes cluster with 3 master nodes, 3 worker nodes and the ability to create services with type loadbalancer and stateful application in your cluster with persistent volumes from Hetzner Cloud.

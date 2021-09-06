# Simple Kubernetes Cluster Provisioning in Hetzner Cloud with Terraform and k0s

The purpose of this repo is to share a simple way to provision Infrastructure in Hetzner Cloud via Terraform for a Kubernetes Cluster. The resources can be used to create e.g. a [k0s Cluster](https://k0sproject.io/).

This config will create 7 servers, within a private network, for a Kubernetes Cluster: 
- 3 Master Nodes with each 4 vCPUs and 16 GB RAM
- 4 Worker Nodes with each 8 vCPUs, 32 GB RAM and 4 Volumes (each 55 GB) attached
- 1 Network (10.0.0.0/8) with 1 Subnet (10.240.0.0/24)

## Prerequesites
- Hetzner Cloud Account:
- Create a Hetzner Cloud API Key:
- Register your SSH Key in Hetzner Cloud Project:
- Terraform CLI: https://learn.hashicorp.com/tutorials/terraform/install-cli

## Getting Started
1. Clone this repo
2. Modify `terraform.tfvars` and add you API Key
3. Add SSH Fingerprint to `hcloud.tf` (line 8)
4. Add SSH Key to `cloudinit/cloud-init.yaml.cfg` (line 13)
5. Change the username in `cloudinit/cloud-init.yaml.cfg` (line 8 and 30)
6. Run `terraform plan` and check if everything looks good
7. Run `terraform apply` and give it approx. 2 minutes

> You can add more customizations in the cloud-init file if needed

## k0s
Now that you got all resources ready, we can simply install a k0s cluster within minutes. [How?]()
help:
	@echo "Commands :"
	@echo " - clean: remove all generated files and ssh known_hosts"
	@echo " - tfvars: create a new configuration file"
	@echo " - provision: provision infrastructure in hcloud"
	@echo " - k0s: install k0s cluster on provisioned infrastructure"
	@echo " - kubeconfg: generate kubeconfig"
	@echo " - destroy: destroy infrastructure in hcloud"
	@echo " - hcloud-ccm: install and configure hcloud Cloud Controller Manager in cluster"

all: clean provision k0s hcloud-ccm

clean:
	rm -f ~/.ssh/known_hosts
	rm -rf var/*

k0sctl:
	sudo wget --quiet https://github.com/k0sproject/k0sctl/releases/download/v0.16.0/k0sctl-linux-x64 -O /usr/local/bin/k0sctl
	sudo chmod +x /usr/local/bin/k0sctl

tfvars:
	-diff -s --color example.tfvars-dist "$$USER.tfvars"
	cp -i example.tfvars-dist "$$USER.tfvars"

provision:
	terraform apply -auto-approve -var-file="$$USER.tfvars"

k0s: k0sctl
	k0sctl apply --config var/k0sctl.yaml

destroy:
	terraform destroy -auto-approve -var-file="$$USER.tfvars"

kubeconfig:
	sudo rm -rf $$HOME/.kube
	mkdir -p $$HOME/.kube
	k0sctl kubeconfig  --config var/k0sctl.yaml > $$HOME/.kube/config
	sudo chown 600 $$HOME/.kube/config

hcloud-ccm: kubeconfig
	kubectl apply -f var/hetzner/hcloud-secret.yaml

	helm repo add hcloud https://charts.hetzner.cloud
	helm repo update hcloud
	helm install hcloud-csi hcloud/hcloud-csi -n kube-system --set node.kubeletDir=/var/lib/k0s/kubelet --set node.hostNetwork=true

	helm repo add hcloud https://charts.hetzner.cloud
	helm repo update hcloud
	helm install hccm hcloud/hcloud-cloud-controller-manager -n kube-system --set networking.enabled=true

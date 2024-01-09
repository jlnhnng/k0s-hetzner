help:
	@echo "Commands :"
	@echo " - apply: provision infrastructure in hcloud"
	@echo " - kubeconfg: generate kubeconfig"
	@echo " - destroy: destroy infrastructure in hcloud"
	@echo " - proxy: proxies k8s API to port 8001"

apply:
	rm -f ~/.ssh/known_hosts
	terraform -chdir=./stacks/tambouille/main apply -auto-approve -var-file="$$USER.tfvars"

destroy:
	terraform -chdir=./stacks/tambouille/main destroy -auto-approve -var-file="$$USER.tfvars"

kubeconfig:
	sudo rm -rf $$HOME/.kube
	mkdir -p $$HOME/.kube
	terraform -chdir=./stacks/tambouille/main output --raw kubeconfig > $$HOME/.kube/tambouille_config
	sudo chown 600 $$HOME/.kube/tambouille_config

proxy: kubeconfig
	kubectl --kubeconfig $$HOME/.kube/tambouille_config proxy
output "kubeconfig" {
  value = k0sctl_config.cluster.kube_yaml
  sensitive = true
}

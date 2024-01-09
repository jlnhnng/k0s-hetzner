output "kubeconfig" {
  value = module.marmite.kubeconfig
  sensitive = true
}

output "kubeconfig" {
  sensitive = true
  value     = talos_cluster_kubeconfig.kubeconfig.kube_config
}

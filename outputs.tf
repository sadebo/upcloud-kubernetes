output "cluster_id" {
  description = "The ID of the UKS cluster"
  value       = upcloud_kubernetes_cluster.this.id
}

output "kubeconfig_path" {
  description = "Path to generated kubeconfig file"
  value       = local_file.kubeconfig.filename
}

#
# This file defines the outputs for the UpCloud Kubernetes module.
# Outputs are values that can be accessed by the parent (root) module.
#

# The unique identifier of the created Kubernetes cluster.
output "cluster_id" {
  description = "The unique identifier of the created Kubernetes cluster."
  value       = upcloud_kubernetes_cluster.dev_cluster.id
}

# The kubeconfig content for connecting to the cluster.
# This value is a sensitive string and should be handled with care.

# Also output kubeconfig if you want to save/use it.
output "kubeconfig" {
  description = "The kubeconfig content for connecting to the cluster."
  value       = data.upcloud_kubernetes_cluster.dev_cluster.kubeconfig
  sensitive   = true
}
# output "kubeconfig" {
#   value     = data.upcloud_kubernetes_cluster.dev_cluster.kubeconfig
#   sensitive = true
# }
# output "argocd_server" {
#   description = "ArgoCD server LoadBalancer endpoint"
#   value       = helm_release.argocd.status
# }

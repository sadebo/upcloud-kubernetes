# #
# # This file defines the outputs for the UpCloud Kubernetes module.
# # Outputs are values that can be accessed by the parent (root) module.
# #

# # The unique identifier of the created Kubernetes cluster.
# output "cluster_id" {
#   description = "The unique identifier of the created Kubernetes cluster."
#   value       = upcloud_kubernetes_cluster.example_cluster.id
# }

# # The kubeconfig content for connecting to the cluster.
# # This value is a sensitive string and should be handled with care.
# output "kubeconfig" {
#   description = "The kubeconfig content for connecting to the cluster."
#   value       = data.upcloud_kubernetes_cluster.example_cluster.kubeconfig
#   sensitive   = true
# }

# # The public IP address of the Traefik LoadBalancer service.
# output "traefik_load_balancer_ip" {
#   description = "The public IP address of the Traefik LoadBalancer service."
#   value = helm_release.traefik.status.load_balancer_ip
# }

output "traefik_loadbalancer_ip" {
  value = try(data.kubernetes_service.traefik.status[0].load_balancer[0].ingress[0].ip, "")
}
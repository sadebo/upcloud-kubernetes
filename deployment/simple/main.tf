terraform {
  required_providers {
    upcloud = {
      source  = "UpCloudLtd/upcloud"
      version = ">= 2.12.0"
    }
  }
}

provider "upcloud" {
  username = var.upcloud_username
  password = var.upcloud_password
}

module "upcloud_k8s" {
  source = "../.." # path to module root
  zone              = "de-fra1"

  node_count        = 2
  node_plan         = "2xCPU-4GB"
  # storage_size      = 50
  
  cluster_name = "production-k8s-cluster"
  cluster_plan = "prod-lg"
  control_plane_ip_filter = ["203.0.113.0/24"] # Example: only allow access from a specific IP range

  # Node group variables
  node_group_name = "compute-nodes"
  # node_count = 3
  # node_plan = "4xCPU-8GB"

# Helm chart variables
  traefik_helm_chart_version = "25.0.0"
  cert_manager_helm_chart_version = "1.15.0"
  # letsencrypt_email = "admin@example.com"
}

# output "cluster_id" {
#   description = "Cluster ID"
#   value       = module.upcloud_k8s.cluster_id
# }

# output "kubeconfig_path" {
#   description = "Path to kubeconfig"
#   value       = module.upcloud_k8s.kubeconfig_path
# }

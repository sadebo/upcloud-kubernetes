#
# UpCloud Kubernetes Cluster with Cert-Manager + Traefik
#

# Create a network for the Kubernetes cluster
resource "upcloud_network" "k8s_network" {
  name = var.network_name
  zone = var.zone
  ip_network {
    address = var.network_cidr
    dhcp    = true
    family  = "IPv4"
  }
}

# Create the UpCloud Managed Kubernetes cluster
resource "upcloud_kubernetes_cluster" "dev_cluster" {
  name                    = var.cluster_name
  zone                    = upcloud_network.k8s_network.zone
  network                 = upcloud_network.k8s_network.id
  # control_plane_ip_filter = var.control_plane_ip_filter
# 
  # Trial accounts can only use development plans
  plan = "dev-md"
}

# Create a node group for the cluster
resource "upcloud_kubernetes_node_group" "example_node_group" {
  cluster    = upcloud_kubernetes_cluster.dev_cluster.id
  name       = var.node_group_name
  node_count = var.node_count
  anti_affinity = false

  plan = "4xCPU-8GB"
}


# Fetch kubeconfig (raw YAML string)
data "upcloud_kubernetes_cluster" "dev_cluster" {
  id = upcloud_kubernetes_cluster.dev_cluster.id
}

# Prefer remote state if available
# locals {
#   kubeconfig = var.kubeconfig != "" ? var.kubeconfig : data.terraform_remote_state.infra.outputs.kubeconfig
# }



# Write kubeconfig to local file
# resource "local_file" "kubeconfig" {
#   content  = data.upcloud_kubernetes_cluster.dev_cluster.kubeconfig
#   filename = "${path.module}/kubeconfig.yaml"
# }

# provider "kubernetes" {
#   config_path = local_file.kubeconfig.filename
# }

# provider "helm" {
#   kubernetes {
#     config_path = local_file.kubeconfig.filename
#   }
# }



# --------------------------
# Install ArgoCD
# --------------------------
# resource "helm_release" "argocd" {
#   name       = "argocd"
#   repository = "https://argoproj.github.io/argo-helm"
#   chart      = "argo-cd"
#   version    = "6.8.0"

#   namespace        = "argocd"
#   create_namespace = true

#   values = [<<EOF
# server:
#   service:
#     type: LoadBalancer
# EOF
#   ]
# }

# --------------------------
# Bootstrap Root App (GitOps)
# --------------------------
# resource "kubernetes_manifest" "root_app" {
#   manifest = yamldecode(templatefile("${path.module}/templates/root-app.yaml.tmpl", {
#     repo_url        = var.repo_url
#     target_revision = var.repo_branch
#     path            = var.repo_path
#   }))
# }
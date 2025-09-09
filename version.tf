terraform {
  required_version = ">= 1.5.0"

  required_providers {
    upcloud = {
      source  = "UpCloudLtd/upcloud"
      version = ">= 2.12.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.29.0"
    }
    helm = {
      source  = "hashicorp/helm"
      # version = ">= 2.12.1"
      version = "~> 2.11.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.4.0"
    }
  }
}

# terraform {
#   required_version = ">= 1.5.0"

#   required_providers {
#     upcloud = {
#       source  = "UpCloudLtd/upcloud"
#       version = ">= 2.12.0"
#     }
#     kubernetes = {
#       source  = "hashicorp/kubernetes"
#       version = ">= 2.22.0"
#     }
#     helm = {
#       source  = "hashicorp/helm"
#       version = ">= 2.12.1"
#     }
#     local = {
#       source  = "hashicorp/local"
#       version = ">= 2.4.0"
#     }
#   }
# }

# provider "upcloud" {
#   username = var.upcloud_username
#   password = var.upcloud_password
# }

# 👇 This was missing
locals {
  kubeconfig_data = yamldecode(data.upcloud_kubernetes_cluster.example_cluster.kubeconfig)
}


provider "kubernetes" {
  host                   = local.kubeconfig_data.clusters[0].cluster.server
  cluster_ca_certificate = local.kubeconfig_data.clusters[0].cluster["certificate-authority-data"]
  client_certificate     = local.kubeconfig_data.users[0].user["client-certificate-data"]
  client_key             = local.kubeconfig_data.users[0].user["client-key-data"]
}

provider "helm" {
  kubernetes {
    host                   = local.kubeconfig_data.clusters[0].cluster.server
    cluster_ca_certificate = local.kubeconfig_data.clusters[0].cluster["certificate-authority-data"]
    client_certificate     = local.kubeconfig_data.users[0].user["client-certificate-data"]
    client_key             = local.kubeconfig_data.users[0].user["client-key-data"]
  }
}


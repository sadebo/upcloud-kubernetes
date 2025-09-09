terraform {
  required_providers {
    upcloud = {
      source  = "UpCloudLtd/upcloud"
      version = ">= 2.12.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.12.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.22.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.4.0"
    }
  }
}

provider "upcloud" {
  username = var.upcloud_username
  password = var.upcloud_password
}

provider "kubernetes" {
  config_path = local_file.kubeconfig.filename
}

provider "helm" {
  kubernetes {
    config_path = local_file.kubeconfig.filename
  }
}

# Create the network (as per example)
resource "upcloud_network" "example" {
  name = "${var.cluster_name}-net"
  zone = var.zone
}

# Create the UKS cluster
resource "upcloud_kubernetes_cluster" "example" {
  name    = var.cluster_name
  zone    = var.zone
  network = upcloud_network.example.id

  node_group {
    title = "worker-group"
    count = var.node_count
    plan  = var.node_plan

    storage {
      size = var.storage_size
    }
  }
}

# Write kubeconfig to a local file
resource "local_file" "kubeconfig" {
  content  = upcloud_kubernetes_cluster.example.kubeconfig
  filename = "${path.module}/kubeconfig.yaml"
}

# Install cert-manager
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true

  version = "v1.15.3"

  set {
    name  = "installCRDs"
    value = "true"
  }
}

# Install Traefik
resource "helm_release" "traefik" {
  name             = "traefik"
  repository       = "https://traefik.github.io/charts"
  chart            = "traefik"
  namespace        = "traefik"
  create_namespace = true

  version = "v27.0.2"

  values = [
    file("${path.module}/traefik-values.yaml")
  ]
}

# Let’s Encrypt ClusterIssuers
resource "kubernetes_manifest" "letsencrypt_clusterissuer" {
  manifest = yamldecode(templatefile("${path.module}/cluster-issuer.yaml", {
    letsencrypt_email = var.letsencrypt_email
  }))
}

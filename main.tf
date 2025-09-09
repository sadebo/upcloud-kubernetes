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
  }
}

provider "upcloud" {
  username = var.upcloud_username
  password = var.upcloud_password
}

# -------------------------
# NETWORK
# -------------------------
resource "upcloud_network" "uks_net" {
  name = "${var.cluster_name}-net"
  zone = var.zone
}

# -------------------------
# KUBERNETES CLUSTER
# -------------------------
resource "upcloud_kubernetes_cluster" "this" {
  name    = var.cluster_name
  zone    = var.zone
  network = upcloud_network.uks_net.id

  node_group {
    title = "worker-group"
    count = var.node_count
    plan  = var.node_plan

    storage {
      size = var.storage_size
    }
  }
}

# Write kubeconfig locally
resource "local_file" "kubeconfig" {
  content  = upcloud_kubernetes_cluster.this.kubeconfig
  filename = "${path.module}/kubeconfig.yaml"
}

# -------------------------
# KUBERNETES + HELM PROVIDERS
# -------------------------
provider "kubernetes" {
  config_path = local_file.kubeconfig.filename
}

provider "helm" {
  kubernetes {
    config_path = local_file.kubeconfig.filename
  }
}

# -------------------------
# CERT-MANAGER
# -------------------------
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  create_namespace = true

  version = "v1.15.3"

  set {
    name  = "installCRDs"
    value = "true"
  }
}

# -------------------------
# TRAEFIK
# -------------------------
resource "helm_release" "traefik" {
  name       = "traefik"
  repository = "https://traefik.github.io/charts"
  chart      = "traefik"
  namespace  = "traefik"
  create_namespace = true

  version = "v27.0.2"

  values = [
    file("${path.module}/traefik-values.yaml")
  ]
}

# -------------------------
# LET'S ENCRYPT CLUSTERISSUER
# -------------------------
resource "kubernetes_manifest" "letsencrypt_clusterissuer" {
  manifest = yamldecode(file("${path.module}/cluster-issuer.yaml"))
}

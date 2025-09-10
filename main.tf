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
resource "upcloud_kubernetes_cluster" "example_cluster" {
  name                    = var.cluster_name
  zone                    = upcloud_network.k8s_network.zone
  network                 = upcloud_network.k8s_network.id
  control_plane_ip_filter = var.control_plane_ip_filter

  # Trial accounts can only use development plans
  plan = "dev-md"
}

# Create a node group for the cluster
resource "upcloud_kubernetes_node_group" "example_node_group" {
  cluster    = upcloud_kubernetes_cluster.example_cluster.id
  name       = var.node_group_name
  node_count = var.node_count
  anti_affinity = false

  plan = "2xCPU-4GB"
}

# Fetch cluster kubeconfig details
data "upcloud_kubernetes_cluster" "example_cluster" {
  id = upcloud_kubernetes_cluster.example_cluster.id
}

# Deploy Cert-Manager
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = var.cert_manager_helm_chart_version
  namespace        = "cert-manager"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }

  depends_on = [upcloud_kubernetes_cluster.example_cluster]
}

# Deploy Traefik
resource "helm_release" "traefik" {
  name             = "traefik"
  repository       = "https://helm.traefik.io/traefik"
  chart            = "traefik"
  version          = var.traefik_helm_chart_version
  namespace        = "traefik"
  create_namespace = true

  values = [
    yamlencode({
      service = {
        enabled = true
        type    = "LoadBalancer"
      }
    })
  ]

  depends_on = [upcloud_kubernetes_cluster.example_cluster]
}

# data "upcloud_kubernetes_cluster" "example_cluster" {
#   id = upcloud_kubernetes_cluster.example_cluster.id
# }
# Query the Traefik service
data "kubernetes_service" "traefik" {
  # provider = kubernetes.upcloud

  metadata {
    name      = "traefik"
    namespace = "traefik"
  }

  depends_on = [helm_release.traefik]
}

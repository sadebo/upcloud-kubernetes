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
  source = "../../infra" # path to module root
  zone              = "de-fra1"
  repo_url = "https://github.com/sadebo/gitops-repo.git"
  node_count        = 3
  node_plan         = "DEV-2xCPU-8GB"
  repo_branch           = "main"
  # storage_size      = 50
  
  cluster_name = "lab-k8s-cluster"
  cluster_plan = "lab-lg"
  # control_plane_ip_filter = ["71.244.133.48"] # Example: only allow access from a specific IP range

  # Node group variables
  node_group_name = "compute-nodes"
  # node_count = 3
  # node_plan = "4xCPU-8GB"

# Helm chart variables
  # traefik_helm_chart_version = "25.0.0"
  # cert_manager_helm_chart_version = "1.15.0"
  # letsencrypt_email = "admin@example.com"
}

# Save kubeconfig from module output

resource "local_file" "kubeconfig" {
  content  = module.upcloud_k8s.kubeconfig
  filename = "${path.module}/kubeconfig.yaml"
}

provider "kubernetes" {
  config_path = local_file.kubeconfig.filename
}

provider "helm" {
  kubernetes {
    config_path = local_file.kubeconfig.filename
  }
}


# Deploy Cert-Manager
# resource "helm_release" "cert_manager" {
#   name             = "cert-manager"
#   repository       = "https://charts.jetstack.io"
#   chart            = "cert-manager"
#   version          = var.cert_manager_helm_chart_version
#   namespace        = "cert-manager"
#   create_namespace = true

#   set {
#     name  = "installCRDs"
#     value = "true"
#   }

#   depends_on = [local_file.kubeconfig]
# }

# # Deploy Traefik
# resource "helm_release" "traefik" {
#   name             = "traefik"
#   repository       = "https://helm.traefik.io/traefik"
#   chart            = "traefik"
#   version          = var.traefik_helm_chart_version
#   namespace        = "traefik"
#   create_namespace = true

#   values = [
#     yamlencode({
#       service = {
#         enabled = true
#         type    = "LoadBalancer"
#       }
#     })
#   ]

#   depends_on = [local_file.kubeconfig]
# }

# # data "upcloud_kubernetes_cluster" "example_cluster" {
# #   id = upcloud_kubernetes_cluster.dev_cluster.id
# # }
# # Query the Traefik service
# data "kubernetes_service" "traefik" {
#   # provider = kubernetes.upcloud

#   metadata {
#     name      = "traefik"
#     namespace = "traefik"
#   }

#   depends_on = [helm_release.traefik]
# }
# --------------------------
# Install ArgoCD
# --------------------------
resource "helm_release" "argocd" {
  depends_on = [local_file.kubeconfig]
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "6.8.0"

  namespace        = "argocd"
  create_namespace = true

  values = [<<EOF
server:
  service:
    type: LoadBalancer
EOF
  ]
}

# --------------------------
# Bootstrap ArgoCD App: Ingress Controller
# --------------------------
resource "kubernetes_manifest" "argocd_app_ingress" {
  manifest = yamldecode(file("${path.module}/argocd-apps/ingress-controller-app.yaml"))
  depends_on = [helm_release.argocd]
}
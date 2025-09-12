# Install ArgoCD only
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "6.8.0"

  namespace        = "argocd"
  create_namespace = true

  values = [<<EOF
server:
  service:
    type: ClusterIP
  ingress:
    enabled: true
    ingressClassName: ${var.ingress_class}
    hosts:
      - argocd.${var.domain}
    tls:
      - secretName: argocd-tls
        hosts:
          - argocd.${var.domain}
EOF
  ]
}

# resource "kubernetes_secret" "repo_github" {
#   metadata {
#     name      = "repo-github"
#     namespace = "argocd"
#     labels = {
#       "argocd.argoproj.io/secret-type" = "repository"
#     }
#   }

#   data = {
#     url           = var.repo_url
#     sshPrivateKey = var.repo_ssh_private_key
#   }

#   type = "Opaque"

#   depends_on = [helm_release.argocd]
# }

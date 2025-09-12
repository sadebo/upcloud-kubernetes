variable "repo_url" {
  description = "GitOps repo URL"
  type        = string
}

variable "repo_branch" {
  description = "Git branch ArgoCD will track"
  type        = string
  default     = "main"
}

variable "repo_path" {
  description = "Path inside Git repo (apps/, overlays/, etc.)"
  type        = string
  default     = "apps"
}

variable "domain" {
  description = "Base domain for ingress (e.g. example.com)"
  type        = string
}

variable "ingress_class" {
  description = "Ingress class (nginx, traefik, istio, etc.)"
  type        = string
  default     = "nginx"
}


variable "kubeconfig" {
  description = "Kubeconfig YAML from infra module"
  type        = string
}

# variable "repo_ssh_private_key" {
#   description = "Private SSH key for accessing GitHub repo"
#   type        = string
#   sensitive   = true
# }
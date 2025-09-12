#
# This file defines the input variables for the UpCloud Kubernetes module.
#

# General configuration variables
variable "zone" {
  description = "The UpCloud zone where the resources will be created."
  type        = string
  default     = "de-fra1"
}

# Network variables
variable "network_name" {
  description = "The name for the network."
  type        = string
  default     = "k8s-cluster-network"
}

variable "network_cidr" {
  description = "The IP network address in CIDR format."
  type        = string
  default     = "172.16.1.0/24"
}

# Cluster variables
variable "cluster_name" {
  description = "The name of the Kubernetes cluster."
  type        = string
  default     = "my-awesome-k8s-cluster"
}

variable "cluster_plan" {
  description = "Cluster plan (used if not trial)"
  type        = string
  default     = "2xCPU-4GB"
}

variable "node_plan" {
  description = "Node group plan (used if not trial)"
  type        = string
  default     = "2xCPU-4GB"
}

# variable "control_plane_ip_filter" {
#   description = "IP addresses or IP ranges in CIDR format allowed to access the control plane."
#   type        = set(string)
#   default     = ["71.244.133.48"]
# }

# Node group variables
variable "node_group_name" {
  description = "The name of the node group."
  type        = string
  default     = "worker-nodes"
}

variable "node_count" {
  description = "The number of nodes to provision in the node group."
  type        = number
  default     = 2
}

# Helm chart variables
variable "traefik_helm_chart_version" {
  description = "The version of the Traefik Helm chart to deploy."
  type        = string
  default     = "25.0.0" # Use a recent stable version
}

variable "cert_manager_helm_chart_version" {
  description = "The version of the Cert-Manager Helm chart to deploy."
  type        = string
  default     = "1.15.0" # Use a recent stable version
}

variable "is_trial" {
  description = "Whether this is a trial account (forces use of development plans)"
  type        = bool
  default     = true
}

# variable "anti_affinity_enabled" {
#   description = "Whether to enforce strict anti-affinity (true/false)"
#   type        = bool
#   default     = false
# }

# GitOps repo info
variable "repo_url" {
  type = string
}

variable "repo_branch" {
  type    = string
  default = "main"
}

variable "repo_path" {
  type    = string
  default = "apps"
}

variable "kubeconfig" {
  description = "Kubeconfig YAML from infra"
  type        = string
  default     = ""
}
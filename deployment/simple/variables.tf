variable "upcloud_username" {
  description = "UpCloud API username"
  type        = string
  sensitive   = true
}

variable "upcloud_password" {
  description = "UpCloud API password"
  type        = string
  sensitive   = true
}

variable "is_trial" {
  description = "Whether this is a trial account (forces use of development plans)"
  type        = bool
  default     = true
}

# variable "cert_manager_helm_chart_version" {
#   description = "The version of the Cert-Manager Helm chart to deploy."
#   type        = string
#   default     = "1.15.0" # Use a recent stable version
# }

# # Helm chart variables
# variable "traefik_helm_chart_version" {
#   description = "The version of the Traefik Helm chart to deploy."
#   type        = string
#   default     = "25.0.0" # Use a recent stable version
# }

variable "upcloud_username" {}
variable "upcloud_password" {}

variable "cluster_name" {
  default = "uks-cluster"
}

variable "zone" {
  default = "de-fra1"
}

variable "node_count" {
  default = 3
}

variable "node_plan" {
  default = "2xCPU-4GB"
}

variable "storage_size" {
  default = 50
}

variable "letsencrypt_email" {
  description = "Email for Let's Encrypt registration"
}

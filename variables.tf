variable "upcloud_username" {
  type      = string
  sensitive = true
}

variable "upcloud_password" {
  type      = string
  sensitive = true
}

variable "cluster_name" {
  type    = string
  default = "uks-cluster"
}

variable "zone" {
  type    = string
  default = "de-fra1"
}

variable "node_count" {
  type    = number
  default = 3
}

variable "node_plan" {
  type    = string
  default = "2xCPU-4GB"
}

variable "storage_size" {
  type    = number
  default = 50
}

variable "letsencrypt_email" {
  type = string
}

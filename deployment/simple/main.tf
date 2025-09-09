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
  source = "../.." # path to the module root

  upcloud_username  = var.upcloud_username
  upcloud_password  = var.upcloud_password
  cluster_name      = "example-uks"
  zone              = "de-fra1"
  node_count        = 2
  node_plan         = "2xCPU-4GB"
  storage_size      = 50
  letsencrypt_email = "admin@example.com"
}

output "cluster_id" {
  value = module.upcloud_k8s.cluster_id
}

output "kubeconfig_path" {
  value = module.upcloud_k8s.kubeconfig_path
}

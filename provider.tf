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

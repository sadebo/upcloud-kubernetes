# upcloud-kubernetes# 🌐 UpCloud Kubernetes Terraform Module

This Terraform module provisions a **Managed Kubernetes Service (UKS) cluster** on **UpCloud**, and automatically bootstraps:

- ✅ Kubernetes cluster (via **UKS**)  
- ✅ Cert-Manager (with CRDs)  
- ✅ Traefik Ingress Controller (LoadBalancer)  
- ✅ Let’s Encrypt **ClusterIssuers** (staging + production)  
- ✅ Local `kubeconfig.yaml` written for kubectl access  

---

## 📦 Module Structure

upcloud-k8s/
├── main.tf # Core module logic
├── variables.tf # Input variables
├── outputs.tf # Outputs
├── traefik-values.yaml # Traefik Helm values
├── cluster-issuer.yaml # Let’s Encrypt ClusterIssuers
└── README.md # This file


---

## 🚀 Usage

```hcl
module "upcloud_k8s" {
  source = "./upcloud-k8s"

  upcloud_username  = var.upcloud_username
  upcloud_password  = var.upcloud_password

  cluster_name      = "my-uks"
  zone              = "de-fra1"

  node_count        = 3
  node_plan         = "2xCPU-4GB"
  storage_size      = 50

  letsencrypt_email = "admin@example.com"
}
# Run:
terraform init
terraform apply


| Output            | Description                  |
| ----------------- | ---------------------------- |
| `cluster_id`      | ID of the UKS cluster        |
| `kubeconfig_path` | Path to generated kubeconfig |

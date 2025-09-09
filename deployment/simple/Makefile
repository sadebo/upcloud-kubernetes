# Makefile for managing UpCloud Kubernetes cluster with Terraform

# Default environment variables
TF_DIR       ?= .
TF_PLAN_FILE ?= plan.tfplan
TRIAL        ?= true

# Colors for pretty output
GREEN=\033[0;32m
YELLOW=\033[1;33m
NC=\033[0m

# Helper: pass trial flag to terraform
TF_VARS=-var "is_trial=$(TRIAL)"

.PHONY: init validate plan apply destroy output kubeconfig traefik-ip clean deploy

## Initialize Terraform
init:
	@echo "$(YELLOW)==> Initializing Terraform...$(NC)"
	cd $(TF_DIR) && terraform init

## Validate Terraform configs
validate:
	@echo "$(YELLOW)==> Validating Terraform configs...$(NC)"
	cd $(TF_DIR) && terraform validate

## Create a Terraform plan
plan:
	@echo "$(YELLOW)==> Generating Terraform plan (trial=$(TRIAL))...$(NC)"
	cd $(TF_DIR) && terraform plan $(TF_VARS) -out=$(TF_PLAN_FILE)

## Apply the last Terraform plan
apply:
	@echo "$(YELLOW)==> Applying Terraform changes...$(NC)"
	cd $(TF_DIR) && terraform apply $(TF_PLAN_FILE)

## Destroy all resources
destroy:
	@echo "$(YELLOW)==> Destroying Terraform-managed resources (trial=$(TRIAL))...$(NC)"
	cd $(TF_DIR) && terraform destroy -auto-approve $(TF_VARS)

## Show all outputs
output:
	@echo "$(YELLOW)==> Terraform Outputs:$(NC)"
	cd $(TF_DIR) && terraform output

## Get kubeconfig for kubectl access
kubeconfig:
	@echo "$(YELLOW)==> Writing kubeconfig to ./kubeconfig.yaml$(NC)"
	cd $(TF_DIR) && terraform output -raw kubeconfig > ./kubeconfig.yaml
	@echo "$(GREEN)Run: export KUBECONFIG=$$(pwd)/kubeconfig.yaml$(NC)"

## Get Traefik LoadBalancer address
traefik-ip:
	@echo "$(YELLOW)==> Fetching Traefik LoadBalancer address...$(NC)"
	cd $(TF_DIR) && terraform output traefik_load_balancer_address

## Clean up plan files and kubeconfig
clean:
	@echo "$(YELLOW)==> Cleaning local files...$(NC)"
	rm -f $(TF_PLAN_FILE) kubeconfig.yaml

## Full deploy: init -> plan -> apply -> kubeconfig -> traefik-ip
deploy: init plan apply kubeconfig traefik-ip
	@echo "$(GREEN)==> Deployment complete!$(NC)"

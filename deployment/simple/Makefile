# Root Makefile for UpCloud K8s + ArgoCD GitOps
# include config.mk
# export
TF_DIR=.
INFRA_DIR=$(TF_DIR)/infra
BOOTSTRAP_DIR=$(TF_DIR)/bootstrap
KUBECONFIG_FILE=$(BOOTSTRAP_DIR)/kubeconfig.yaml

# --- INFRA STAGE ---

infra-init:
	cd $(INFRA_DIR) && terraform init

infra-plan:
	cd $(INFRA_DIR) && terraform plan

infra-apply:
	cd $(INFRA_DIR) && terraform apply -auto-approve \
	&& terraform -chdir=$(INFRA_DIR) output -raw kubeconfig > $(KUBECONFIG_FILE)

infra-destroy:
	cd $(INFRA_DIR) && terraform destroy -auto-approve

# --- BOOTSTRAP STAGE ---

bootstrap-init:
	cd $(BOOTSTRAP_DIR) && terraform init

bootstrap-plan:
	cd $(BOOTSTRAP_DIR) && terraform plan \
	-var kubeconfig="$$(cat $(KUBECONFIG_FILE))" \
	-var repo_url="git@github.com:your-org/gitops-repo.git"

bootstrap-apply:
	cd $(BOOTSTRAP_DIR) && terraform apply -auto-approve \
	-var kubeconfig="$$(cat $(KUBECONFIG_FILE))" \
	-var repo_url="git@github.com:your-org/gitops-repo.git"

bootstrap-destroy:
	cd $(BOOTSTRAP_DIR) && terraform destroy -auto-approve \
	-var kubeconfig="$$(cat $(KUBECONFIG_FILE))" \
	-var repo_url="git@github.com:your-org/gitops-repo.git"

# --- SHORTCUTS ---

infra: infra-init infra-apply
bootstrap: bootstrap-init bootstrap-apply
destroy: bootstrap-destroy infra-destroy

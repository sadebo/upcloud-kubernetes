# INFRA_DIR := infra
# BOOTSTRAP_DIR := bootstrap
# KUBECONFIG_FILE := $(BOOTSTRAP_DIR)/kubeconfig.yaml
# KUBECONFIG_FILE := $(BOOTSTRAP_DIR)/kubeconfig.yaml

ROOT_DIR := $(shell pwd)
INFRA_DIR := $(ROOT_DIR)/infra
BOOTSTRAP_DIR := $(ROOT_DIR)/bootstrap
KUBECONFIG_FILE := $(BOOTSTRAP_DIR)/kubeconfig.yaml
CLOUDFLARE_DIR := $(ROOT_DIR)/cloudflare

# Load configs
include config.mk
export
ifneq (,$(wildcard .env))
    include .env
    export
endif


# Default to dev if ENV is not passed
ENV ?= dev

infra-init:
	cd $(INFRA_DIR) && terraform init

infra-plan:
	cd $(INFRA_DIR) && terraform plan -var-file=$(ENV).tfvars

infra-apply:
	cd $(INFRA_DIR) && terraform apply -auto-approve -var-file=$(ENV).tfvars \
	&& terraform -chdir=$(INFRA_DIR) output -raw kubeconfig > kubeconfig.yaml \
	&& cp $(INFRA_DIR)/kubeconfig.yaml $(BOOTSTRAP_DIR)/kubeconfig.yaml

infra-destroy:
	cd $(INFRA_DIR) && terraform destroy -auto-approve -var-file=$(ENV).tfvars

bootstrap-init:
	cd $(BOOTSTRAP_DIR) && terraform init

bootstrap-plan:
	cd $(BOOTSTRAP_DIR) && terraform plan -var-file=$(ENV).tfvars \
	-var kubeconfig="$$(cat $(KUBECONFIG_FILE))"

bootstrap-apply:
	cd $(BOOTSTRAP_DIR) && terraform apply -auto-approve -var-file=$(ENV).tfvars \
	-var kubeconfig="$$(cat $(KUBECONFIG_FILE))"

bootstrap-destroy:
	cd $(BOOTSTRAP_DIR) && terraform destroy -auto-approve -var-file=$(ENV).tfvars \
	-var kubeconfig="$$(cat $(KUBECONFIG_FILE))"

infra: infra-init infra-apply
bootstrap: bootstrap-init bootstrap-apply
destroy: bootstrap-destroy infra-destroy
.PHONY: infra-init infra-plan infra-apply infra-destroy \
	bootstrap-init bootstrap-plan bootstrap-apply bootstrap-destroy \
	infra bootstrap destroy


cf-init:
	cd $(CLOUDFLARE_DIR) && terraform init

cf-plan:
	cd $(CLOUDFLARE_DIR) && terraform plan \
	-var cloudflare_api_token=$(CLOUDFLARE_API_TOKEN) \
	-var cloudflare_zone_id=$(CF_ZONE_ID) \
	-var app_subdomain=$(APP_SUBDOMAIN) \
	-var lb_hostname=$(LB_HOSTNAME)

cf-apply:
	cd $(CLOUDFLARE_DIR) && terraform apply -auto-approve \
	-var cloudflare_api_token=$(CLOUDFLARE_API_TOKEN) \
	-var cloudflare_zone_id=$(CF_ZONE_ID) \
	-var app_subdomain=$(APP_SUBDOMAIN) \
	-var lb_hostname=$(LB_HOSTNAME)

cf-destroy:
	cd $(CLOUDFLARE_DIR) && terraform destroy -auto-approve \
	-var cloudflare_api_token=$(CLOUDFLARE_API_TOKEN) \
	-var cloudflare_zone_id=$(CF_ZONE_ID) \
	-var app_subdomain=$(APP_SUBDOMAIN) \
	-var lb_hostname=$(LB_HOSTNAME)
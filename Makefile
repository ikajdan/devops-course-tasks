TERRAFORM=terraform -chdir=infra

.PHONY: all init plan apply destroy format check validate

all: check validate init plan

init:
	@echo "Initializing Terraform…"
	$(TERRAFORM) init

plan:
	@echo "Planning Terraform changes…"
	$(TERRAFORM) plan

apply:
	@echo "Applying Terraform changes…"
	$(TERRAFORM) apply -auto-approve

destroy:
	@echo "Destroying Terraform resources…"
	$(TERRAFORM) destroy -auto-approve

format:
	@echo "Formatting Terraform files…"
	$(TERRAFORM) fmt -recursive

check:
	@echo "Checking Terraform formatting…"
	$(TERRAFORM) fmt -check -recursive

validate:
	@echo "Validating Terraform configuration…"
	$(TERRAFORM) validate

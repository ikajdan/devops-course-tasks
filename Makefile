.PHONY: all init plan apply destroy format validate

all: format validate init plan

init:
	@echo "Initializing Terraform…"
	terraform init

plan:
	@echo "Planning Terraform changes…"
	terraform plan

apply:
	@echo "Applying Terraform changes…"
	terraform apply -auto-approve

destroy:
	@echo "Destroying Terraform resources…"
	terraform destroy -auto-approve

format:
	@echo "Checking Terraform formatting…"
	terraform fmt -check -recursive

validate:
	@echo "Validating Terraform configuration…"
	terraform validate

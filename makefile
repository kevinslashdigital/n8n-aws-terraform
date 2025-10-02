AWS_REGION ?= ap-southeast-1
ENV ?= dev
AWS_PROFILE ?= n8x-profile
VARS_FILE ?= $(ENV).terraform.tfvars

init:
	cd envs/$(ENV) && terraform init -backend-config=backend.hcl

plan:
	cd envs/$(ENV) && terraform plan -var="environment=$(ENV)" -var="profile=$(AWS_PROFILE)"

apply:
	cd envs/$(ENV) && terraform apply -auto-approve -var="environment=$(ENV)" -var="profile=$(AWS_PROFILE)"

destroy:
	cd envs/$(ENV) && terraform destroy -auto-approve -var="environment=$(ENV)" -var="profile=$(AWS_PROFILE)"

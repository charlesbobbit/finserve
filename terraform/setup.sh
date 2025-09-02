#!/bin/bash
set -e

echo "Initializing Terraform and validating environments..."

terraform init

# Create workspaces
terraform workspace new staging 2>/dev/null || true
terraform workspace new prod 2>/dev/null || true

terraform validate

# Plan both environments
terraform workspace select staging
terraform plan -var-file="environments/staging/terraform.tfvars" -out=staging.tfplan

terraform workspace select prod
terraform plan -var-file="environments/prod/terraform.tfvars" -out=prod.tfplan

echo "Setup complete. Plans ready for both environments."

# Apply staging
read -p "Apply staging environment? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    terraform workspace select staging
    terraform apply staging.tfplan
    echo "Staging deployed: $(terraform output -raw vm_public_ip)"
fi 
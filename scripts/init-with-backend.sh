#!/bin/bash

# Complete script to initialize Terraform with dynamic backend from bootstrap
# Usage: ./scripts/init-with-backend.sh <environment>

set -e

ENVIRONMENT=${1:-prod}
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_DIR="$PROJECT_ROOT/envs/$ENVIRONMENT"

echo "🚀 Initializing Terraform for environment: $ENVIRONMENT"

# Generate backend configuration
echo "📡 Step 1: Generating backend configuration..."
"$PROJECT_ROOT/scripts/generate-backend-config.sh" "$ENVIRONMENT"

# Change to environment directory
cd "$ENV_DIR"

# Initialize Terraform with backend config
echo "🔧 Step 2: Initializing Terraform..."
terraform init -backend-config=backend.hcl

echo "✅ Terraform initialized successfully!"
echo ""
echo "📋 Next steps:"
echo "   terraform plan"
echo "   terraform apply"

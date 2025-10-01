#!/bin/bash

# Script to update backend configuration with bucket name from bootstrap output
# Usage: ./scripts/update-backend.sh <environment>

set -e

ENVIRONMENT=${1:-prod}
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BOOTSTRAP_DIR="$PROJECT_ROOT/bootstrap"
ENV_DIR="$PROJECT_ROOT/envs/$ENVIRONMENT"

echo "🔍 Getting bucket name from bootstrap state..."

# Check if bootstrap directory exists
if [ ! -d "$BOOTSTRAP_DIR" ]; then
    echo "❌ Bootstrap directory not found: $BOOTSTRAP_DIR"
    exit 1
fi

# Check if environment directory exists
if [ ! -d "$ENV_DIR" ]; then
    echo "❌ Environment directory not found: $ENV_DIR"
    exit 1
fi

# Get bucket name from bootstrap output
cd "$BOOTSTRAP_DIR"
BUCKET_NAME=$(terraform output -raw state_bucket_name 2>/dev/null)

if [ -z "$BUCKET_NAME" ]; then
    echo "❌ Could not get bucket name from bootstrap state"
    echo "   Make sure bootstrap has been applied and outputs are available"
    exit 1
fi

echo "✅ Found bucket name: $BUCKET_NAME"

# Get lock table name from bootstrap output
LOCK_TABLE=$(terraform output -raw lock_table_name 2>/dev/null)

if [ -z "$LOCK_TABLE" ]; then
    echo "❌ Could not get lock table name from bootstrap state"
    exit 1
fi

echo "✅ Found lock table: $LOCK_TABLE"

# Update backend.tf file
BACKEND_FILE="$ENV_DIR/backend.tf"

if [ ! -f "$BACKEND_FILE" ]; then
    echo "📝 Creating new backend.tf file..."
    cat > "$BACKEND_FILE" << EOF
terraform {
  backend "s3" {
    bucket         = "$BUCKET_NAME"
    key            = "envs/$ENVIRONMENT/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "$LOCK_TABLE"
    encrypt        = true
    profile        = "n8n"
  }
}
EOF
else
    echo "📝 Updating existing backend.tf file..."
    # Use sed to update the bucket and table names
    sed -i.bak \
        -e "s/bucket[[:space:]]*=[[:space:]]*\"[^\"]*\"/bucket         = \"$BUCKET_NAME\"/" \
        -e "s/dynamodb_table[[:space:]]*=[[:space:]]*\"[^\"]*\"/dynamodb_table = \"$LOCK_TABLE\"/" \
        -e "s/key[[:space:]]*=[[:space:]]*\"[^\"]*\"/key            = \"envs\/$ENVIRONMENT\/terraform.tfstate\"/" \
        "$BACKEND_FILE"
    
    # Remove backup file
    rm -f "$BACKEND_FILE.bak"
fi

echo "✅ Backend configuration updated successfully!"
echo ""
echo "📋 Backend configuration:"
echo "   Bucket: $BUCKET_NAME"
echo "   Key: envs/$ENVIRONMENT/terraform.tfstate"
echo "   Lock Table: $LOCK_TABLE"
echo ""
echo "🚀 Next steps:"
echo "   1. cd envs/$ENVIRONMENT"
echo "   2. terraform init"
echo "   3. terraform plan"
echo "   4. terraform apply"

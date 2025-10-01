#!/bin/bash

# Script to generate backend configuration from bootstrap outputs
# Usage: ./scripts/generate-backend-config.sh <environment>

set -e

ENVIRONMENT=${1:-prod}
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BOOTSTRAP_DIR="$PROJECT_ROOT/bootstrap"
ENV_DIR="$PROJECT_ROOT/envs/$ENVIRONMENT"

echo "🔍 Generating backend config for environment: $ENVIRONMENT"

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

# Get values from bootstrap output
cd "$BOOTSTRAP_DIR"

echo "📡 Getting bootstrap outputs..."

BUCKET_NAME=$(terraform output -raw state_bucket_name 2>/dev/null)
if [ -z "$BUCKET_NAME" ]; then
    echo "❌ Could not get bucket name from bootstrap state"
    echo "   Make sure bootstrap has been applied: cd bootstrap && terraform apply"
    exit 1
fi

LOCK_TABLE=$(terraform output -raw lock_table_name 2>/dev/null)
if [ -z "$LOCK_TABLE" ]; then
    echo "❌ Could not get lock table name from bootstrap state"
    exit 1
fi

echo "✅ Bucket: $BUCKET_NAME"
echo "✅ Lock Table: $LOCK_TABLE"

# Generate backend.hcl file
BACKEND_CONFIG_FILE="$ENV_DIR/backend.hcl"

echo "📝 Generating $BACKEND_CONFIG_FILE..."

cat > "$BACKEND_CONFIG_FILE" << EOF
# Generated from bootstrap outputs
# Bucket: $BUCKET_NAME
# Lock Table: $LOCK_TABLE
# Generated at: $(date)

bucket         = "$BUCKET_NAME"
dynamodb_table = "$LOCK_TABLE"
EOF

echo "✅ Backend configuration generated successfully!"
echo ""
echo "📋 Usage:"
echo "   cd envs/$ENVIRONMENT"
echo "   terraform init -backend-config=backend.hcl"
echo ""
echo "🔄 Or use the helper script:"
echo "   ./scripts/init-with-backend.sh $ENVIRONMENT"

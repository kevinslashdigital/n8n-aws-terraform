# n8n AWS Terraform Infrastructure

This repository contains Terraform configurations to deploy n8n (workflow automation platform) infrastructure on AWS.

## Project Structure

```
├── bootstrap/          # Terraform state management setup
│   ├── main.tf        # S3 bucket and DynamoDB table for state
│   ├── variables.tf   # Bootstrap configuration variables
│   └── terraform.tf   # Provider and version requirements
├── envs/              # Environment-specific configurations
├── modules/           # Reusable Terraform modules
└── main.tf           # Main infrastructure configuration
```

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.2
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- AWS account with necessary permissions

## AWS Profile Configuration

This project uses the AWS profile `n8n` by default. Ensure your AWS credentials are configured:

```bash
aws configure --profile n8n
```

Or update the `profile` variable in `bootstrap/variables.tf` to match your AWS profile name.

## Quick Start

### 1. Bootstrap Terraform State Management

First, set up the S3 bucket and DynamoDB table for Terraform state management:

```bash
cd bootstrap/
terraform init
terraform plan -var="profile=xx-profile"
terraform apply -var="profile=xx-profile"
```

This creates:
- **S3 Bucket**: `n8n-tf-state` - Stores Terraform state files
- **DynamoDB Table**: `n8n-tf-locks` - Handles state locking

### 2. Initialize Backend with Dynamic Configuration

After the bootstrap is complete, use the automated script to configure and initialize the backend:

```bash
# Automatically generates backend config from bootstrap outputs and initializes Terraform
./scripts/init-with-backend.sh prod
```

This script will:
- Extract the S3 bucket name and DynamoDB table from bootstrap outputs
- Generate a `backend.hcl` configuration file
- Initialize Terraform with the correct backend settings

**Alternative manual steps:**
```bash
# Generate backend configuration
./scripts/generate-backend-config.sh prod

# Initialize manually
cd envs/prod
terraform init -backend-config=backend.hcl
```

### 3. Deploy Main Infrastructure

```bash
cd envs/prod  # Navigate to your environment
terraform plan -var="profile=xx-profile"
terraform apply -var="profile=xx-profile"


make plan AWS_PROFILE=chaseflow ENV=prod
```

### 4. Update Backend Configuration

```bash
# Update backend configuration
cd envs/prod && terraform init -reconfigure -backend-config=backend.hcl
```

## Configuration

### Bootstrap Variables

Located in `bootstrap/variables.tf`:

| Variable | Default | Description |
|----------|---------|-------------|
| `region` | `ap-southeast-1` | AWS region for resources |
| `profile` | `n8n` | AWS CLI profile to use |
| `state_bucket` | `n8n-tf-state` | S3 bucket name for Terraform state |
| `lock_table` | `n8n-tf-locks` | DynamoDB table for state locking |

### Customization

To customize the configuration:

1. **Change AWS Region**: Update the `region` variable in `bootstrap/variables.tf`
2. **Change AWS Profile**: Update the `profile` variable in `bootstrap/variables.tf`
3. **Change Resource Names**: Update `state_bucket` and `lock_table` variables

## Commands

### Format Code
```bash
terraform fmt -recursive
```

### Validate Configuration
```bash
terraform validate
```

### Plan Changes
```bash
terraform plan
```

### Apply Changes
```bash
terraform apply
```

### Destroy Infrastructure
```bash
terraform destroy
```

## Security Best Practices

- ✅ S3 bucket versioning enabled for state files
- ✅ DynamoDB table for state locking prevents concurrent modifications
- ✅ Uses AWS profiles instead of hardcoded credentials
- ✅ Terraform state stored remotely in S3

## Troubleshooting

### Common Issues

1. **AWS Credentials**: Ensure your AWS profile is configured correctly
   ```bash
   aws sts get-caller-identity --profile n8n
   ```

2. **S3 Bucket Already Exists**: If the bucket name is taken, update `state_bucket` in `bootstrap/variables.tf`

3. **Permission Errors**: Ensure your AWS user/role has permissions for:
   - S3 bucket creation and management
   - DynamoDB table creation and management
   - EC2, VPC, and other AWS services (for main infrastructure)

### State Management

- **State Location**: `s3://n8n-tf-state/n8n/terraform.tfstate`
- **Lock Table**: `n8n-tf-locks` in DynamoDB
- **Backup**: S3 versioning automatically creates backups of state files

## Contributing

1. Format code before committing: `terraform fmt -recursive`
2. Validate configuration: `terraform validate`
3. Test changes in a separate environment first

## License

[Add your license information here]

## Support

For issues related to:
- **Terraform**: Check the [Terraform documentation](https://www.terraform.io/docs)
- **AWS**: Refer to [AWS documentation](https://docs.aws.amazon.com/)
- **n8n**: Visit [n8n documentation](https://docs.n8n.io/)

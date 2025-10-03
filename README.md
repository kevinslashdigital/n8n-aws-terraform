# n8n AWS Terraform Infrastructure

This repository contains Terraform configurations to deploy n8n (workflow automation platform) infrastructure on AWS using a modular, multi-environment approach.

## Architecture Overview

The infrastructure deploys:

- **VPC** with public/private subnets across multiple AZs
- **Application Load Balancer** with SSL/TLS termination
- **ECS Fargate** service running n8n container
- **RDS PostgreSQL** database with SSL encryption
- **Systems Manager** for secure parameter storage
- **CloudWatch** for logging and monitoring

## Project Structure

```
├── bootstrap/          # Terraform state management setup
│   ├── main.tf        # S3 bucket and DynamoDB table for state
│   ├── variables.tf   # Bootstrap configuration variables
│   └── terraform.tf   # Provider and version requirements
├── envs/              # Environment-specific configurations
│   └── prod/          # Production environment
│       ├── main.tf    # Main infrastructure configuration
│       ├── variables.tf # Variable definitions
│       ├── outputs.tf # Output values
│       ├── secret.tf  # SSM parameters for secrets
│       └── *.terraform.tfvars # Environment variables (gitignored)
├── modules/           # Reusable Terraform modules
│   ├── networking/    # VPC, subnets, routing
│   ├── alb/          # Application Load Balancer
│   ├── ecs/          # ECS cluster and service
│   └── rds/          # PostgreSQL database
└── Makefile          # Automation commands
```

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.2
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- AWS account with necessary permissions

## Quick Start

### 1. Clone and Configure

```bash
git clone <repository-url>
cd n8n-aws-terraform
```

### 2. Set Up Environment Variables

Create your environment-specific variables file:

```bash
cp envs/prod/terraform.tfvars.example envs/prod/prod.terraform.tfvars
```

### 3. Bootstrap Terraform State Management (First Time Only)

```bash
cd bootstrap/
terraform init
terraform plan -var="profile=your-aws-profile"
terraform apply -var="profile=your-aws-profile"
cd ..
```

### 4. Initialize Backend

```bash
./scripts/init-with-backend.sh prod
cd envs/prod
# Automatically generates backend config from bootstrap outputs and initializes Terraform
make init ENV=prod
```

### 5. Deploy Infrastructure

Using Makefile (recommended):

```bash
# Plan deployment
make plan AWS_PROFILE=your-aws-profile ENV=prod

# Apply deployment
make apply AWS_PROFILE=your-aws-profile ENV=prod
```

## Accessing n8n

After deployment, you can access n8n via:

```bash
# Get the access URL
terraform output n8n_url

# Or use the ALB directly
terraform output alb_dns_name
```

**Default Access:**
- **URL**: Output from `n8n_url` (with custom domain) or `alb_dns_name`
- **Authentication**: Configure via environment variables in `prod.terraform.tfvars`

## Database Access

To connect to the RDS database for administration:

### 1. Create a Bastion Host
Deploy an EC2 instance in a public subnet with the bastion security group that allows RDS access.

### 2. SSH Tunnel
```bash
ssh -i "your-key.pem" -L 5432:prod-n8n-db.1234567890.ap-southeast-1.rds.amazonaws.com:5432 ec2-user@bastion-host-ip
```

### 3. Connect to Database

- **Host**: `localhost` (via tunnel)
- **Port**: `5432`
- **Database**: `n8n`
- **Username**: `n8n_user`
- **Password**: From SSM Parameter Store

## Makefile Commands

```bash
# Initialize environment
make init AWS_PROFILE=your-profile ENV=prod

# Plan changes
make plan AWS_PROFILE=your-profile ENV=prod

# Apply changes
make apply AWS_PROFILE=your-profile ENV=prod

# Destroy infrastructure
make destroy AWS_PROFILE=your-profile ENV=prod
```

## Security Best Practices

- ✅ **Private Subnets**: RDS and ECS tasks run in private subnets
- ✅ **Security Groups**: Restrictive ingress rules, only necessary ports open
- ✅ **SSL/TLS**: Database connections use SSL encryption
- ✅ **Secrets Management**: Sensitive data stored in AWS Systems Manager
- ✅ **State Security**: Terraform state stored remotely with locking
- ✅ **Network Isolation**: Multi-AZ deployment with proper routing

## Troubleshooting

### Common Issues

1. **Database Connection Timeout**
   - Ensure bastion host is in the same VPC as RDS
   - Check security group rules allow bastion → RDS access
   - Verify SSH tunnel is active

2. **n8n Container Fails to Start**
   - Check ECS service logs: `aws logs get-log-events --log-group-name "/ecs/prod-n8n"`
   - Verify database connectivity and SSL configuration
   - Check SSM parameters are correctly set

3. **SSL Certificate Issues**
   - Ensure certificate ARN is valid and in the same region
   - Verify domain name matches certificate
   - Check DNS configuration for custom domain

4. **Permission Errors**
   - Ensure AWS user/role has permissions for:
     - ECS, VPC, RDS, ALB, Route53, ACM
     - Systems Manager Parameter Store
     - CloudWatch Logs

### Useful Commands

```bash
# Check ECS service status
aws ecs describe-services --cluster prod-n8n-cluster --services prod-n8n-service

# View application logs
aws logs tail /ecs/prod-n8n --follow

# Get database endpoint
aws rds describe-db-instances --db-instance-identifier prod-n8n-db

# Check ALB health
aws elbv2 describe-target-health --target-group-arn <target-group-arn>
```

## Cost Optimization

- **RDS**: Use `db.t3.micro` for development, `db.t3.small+` for production
- **ECS**: Adjust CPU/memory based on actual usage
- **ALB**: Consider using NLB for lower costs if SSL termination isn't needed
- **NAT Gateway**: Costs ~$45/month per AZ, consider single AZ for dev environments

## Contributing

1. Format code before committing: `terraform fmt -recursive`
2. Validate configuration: `terraform validate`
3. Test changes in a separate environment first
4. Update documentation for any new variables or outputs

## License

[Add your license information here]

## Support

For issues related to:

- **Terraform**: Check the [Terraform documentation](https://www.terraform.io/docs)
- **AWS**: Refer to [AWS documentation](https://docs.aws.amazon.com/)
- **n8n**: Visit [n8n documentation](https://docs.n8n.io/)

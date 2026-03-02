# n8n Development Environment

This development environment is optimized for cost savings by placing ECS tasks in public subnets, eliminating the need for expensive NAT gateways.

## 🏗️ Architecture Overview

### Cost-Optimized Design
- **Single AZ deployment** - Reduces infrastructure costs
- **ECS in public subnets** - No NAT gateway required
- **Public IP assignment** - Direct internet access for containers
- **Reduced resources** - 256 CPU / 512MB memory
- **Minimal backup retention** - 1 day instead of 7

### Security Considerations
⚠️ **Important**: This configuration is designed for development only. For production:
- Use private subnets with NAT gateways
- Implement proper network segmentation
- Restrict security group access
- Enable deletion protection

## 💰 Cost Savings

Compared to production setup:
- **NAT Gateway**: -$87.79/month (eliminated)
- **Elastic IPs**: -$7.44/month (eliminated)
- **ECS Resources**: -$9.19/month (reduced CPU/memory)
- **Database Storage**: -$1.15/month (reduced from 20GB to 10GB)
- **Backup Storage**: -$1.62/month (1 day vs 7 days retention)

**Total Monthly Savings: ~$107/month (66% reduction)**

## 🚀 Deployment Instructions

### Prerequisites
1. AWS CLI configured with appropriate credentials
2. Terraform >= 1.2 installed
3. S3 bucket for Terraform state (configured in `backend.tf`)

### Step 1: Configure Variables
```bash
cd envs/dev
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your specific values:
```hcl
# Required variables
db_password           = "your-secure-dev-password"
n8n_encryption_key    = "your-32-character-encryption-key"
n8n_basic_auth_password = "your-basic-auth-password"

# Optional: Restrict access (recommended)
allowed_cidr_blocks   = ["YOUR_IP/32"]  # Replace with your IP
```

### Step 2: Initialize Terraform
```bash
terraform init
```

### Step 3: Plan Deployment
```bash
terraform plan
```

### Step 4: Deploy
```bash
terraform apply
```

### Step 5: Access n8n
After deployment, get the ALB DNS name:
```bash
terraform output n8n_url
```

Access n8n at the provided URL using:
- **Username**: admin (or your configured value)
- **Password**: Your configured basic auth password

## 🔧 Configuration Details

### Network Configuration
- **VPC CIDR**: `10.1.0.0/16` (different from prod to avoid conflicts)
- **Public Subnet**: `10.1.1.0/24` in `ap-southeast-1a`
- **NAT Gateway**: Disabled
- **ECS Tasks**: Deployed in public subnet with public IPs

### Resource Specifications
- **ECS CPU**: 256 units (0.25 vCPU)
- **ECS Memory**: 512 MB
- **RDS Instance**: db.t3.micro
- **RDS Storage**: 10 GB (vs 20 GB in prod)
- **Backup Retention**: 1 day (vs 7 days in prod)

### Security Groups
The ECS security group allows:
- Inbound traffic from ALB on port 5678
- All outbound traffic (required for container image pulls and external API calls)

## 🛠️ Management Commands

### View Resources
```bash
# List all resources
terraform state list

# Show specific resource
terraform show module.ecs.aws_ecs_service.main
```

### Update Configuration
```bash
# After modifying variables
terraform plan
terraform apply
```

### Destroy Environment
```bash
# WARNING: This will delete all resources
terraform destroy
```

## 📊 Monitoring

### CloudWatch Logs
ECS logs are available in CloudWatch:
- Log Group: `/ecs/dev-n8n`
- Retention: 7 days (configurable)

### ECS Service Monitoring
```bash
# Check service status
aws ecs describe-services --cluster dev-n8n-cluster --services dev-n8n-service

# View running tasks
aws ecs list-tasks --cluster dev-n8n-cluster --service-name dev-n8n-service
```

## 🔒 Security Best Practices

Even for development, consider these security measures:

1. **Restrict Access**:
   ```hcl
   allowed_cidr_blocks = ["YOUR_IP/32"]
   ```

2. **Use Strong Passwords**:
   - Database password: 16+ characters
   - Basic auth password: 12+ characters
   - Encryption key: Exactly 32 characters

3. **Regular Updates**:
   - Keep n8n image updated
   - Monitor for security advisories

4. **Network Monitoring**:
   - Review CloudWatch logs regularly
   - Monitor unusual network activity

## 🚨 Troubleshooting

### Common Issues

1. **ECS Tasks Not Starting**:
   ```bash
   # Check ECS service events
   aws ecs describe-services --cluster dev-n8n-cluster --services dev-n8n-service
   
   # Check task logs
   aws logs get-log-events --log-group-name /ecs/dev-n8n --log-stream-name ecs/n8n/TASK_ID
   ```

2. **Database Connection Issues**:
   - Verify security groups allow ECS → RDS communication
   - Check database endpoint in ECS environment variables

3. **ALB Health Check Failures**:
   - Ensure n8n is listening on port 5678
   - Check ECS task health in AWS console

### Useful Commands
```bash
# Get ALB DNS name
terraform output alb_dns_name

# Get database endpoint
terraform output database_endpoint

# Check ECS cluster
aws ecs describe-clusters --clusters dev-n8n-cluster
```

## 📝 Notes

- This environment uses public subnets for cost optimization
- Database is also in public subnet (dev only - not recommended for prod)
- No SSL certificate configured (HTTP only)
- Basic authentication is enabled by default
- Deletion protection is disabled for easy cleanup

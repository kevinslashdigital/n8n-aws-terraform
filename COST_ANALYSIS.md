# n8n AWS Infrastructure Cost Analysis

This document provides a detailed cost breakdown and optimization strategies for the n8n AWS infrastructure deployed in **ap-southeast-1 (Singapore)**.

## Current Infrastructure Overview

The n8n deployment consists of:
- **VPC** with public/private subnets across 2 AZs
- **ECS Fargate** service (0.5 vCPU, 1GB RAM)
- **Application Load Balancer** with SSL termination
- **RDS PostgreSQL** (db.t3.micro, 20GB storage)
- **NAT Gateways** for high availability (2 AZs)
- **CloudWatch** logging and monitoring

## Monthly Cost Breakdown

### 🔧 Compute Services

| Service | Configuration | Unit Cost | Monthly Hours | Monthly Cost |
|---------|---------------|-----------|---------------|--------------|
| **ECS Fargate** | 0.5 vCPU | $0.04048/vCPU-hour | 744 | $15.06 |
| **ECS Fargate** | 1GB Memory | $0.004445/GB-hour | 744 | $3.31 |
| **Application Load Balancer** | Standard ALB | $0.0225/hour | 744 | $16.74 |
| **ALB Load Balancer Capacity Units** | ~22.5 LCUs/hour | $0.008/LCU-hour | 16,740 | $5.58 |
| | | | **Subtotal** | **$40.69** |

### 🗄️ Database & Storage

| Service | Configuration | Unit Cost | Usage | Monthly Cost |
|---------|---------------|-----------|-------|--------------|
| **RDS PostgreSQL** | db.t3.micro | $0.018/hour | 744 hours | $13.39 |
| **RDS Storage** | 20GB gp2 | $0.115/GB-month | 20GB | $2.30 |
| **RDS Backup Storage** | 7 days retention | $0.095/GB-month | ~20GB | $1.90 |
| | | | **Subtotal** | **$17.59** |

### 🌐 Networking

| Service | Configuration | Unit Cost | Usage | Monthly Cost |
|---------|---------------|-----------|-------|--------------|
| **NAT Gateway** | 2 gateways | $0.059/hour each | 1,488 hours | $87.79 |
| **NAT Gateway Data** | Processing | $0.059/GB | ~100GB | $5.90 |
| **Elastic IP** | 2 EIPs | $0.005/hour each | 1,488 hours | $7.44 |
| | | | **Subtotal** | **$101.13** |

### 📊 Monitoring & Management

| Service | Configuration | Unit Cost | Usage | Monthly Cost |
|---------|---------------|-----------|-------|--------------|
| **CloudWatch Logs** | Ingestion | $0.67/GB | ~3GB | $2.01 |
| **CloudWatch Logs** | Storage | $0.0336/GB | ~10GB | $0.34 |
| **Systems Manager** | Parameter Store | Free tier | <10,000 params | $0.00 |
| | | | **Subtotal** | **$2.35** |

---

## 💰 Total Monthly Cost Summary

| **Category** | **Monthly Cost** | **Percentage** |
|--------------|------------------|----------------|
| **Compute (ECS + ALB)** | $40.69 | 25% |
| **Database (RDS)** | $17.59 | 11% |
| **Networking (NAT + EIP)** | $101.13 | 62% |
| **Monitoring** | $2.35 | 2% |
| **TOTAL** | **$161.76** | **100%** |

> **Key Insight**: Networking costs (NAT Gateways) represent 62% of the total infrastructure cost.

## Cost Optimization Strategies

### 🎯 High Impact Optimizations

#### 1. Single AZ Deployment (Development)
**Savings: ~$50/month (31% reduction)**

```hcl
# In variables.tf
variable "enable_nat_gateway" {
  default = false  # For development
}

variable "single_nat_gateway" {
  default = true   # Use only one NAT gateway
}
```

**Impact:**
- Reduces from 2 to 1 NAT Gateway: -$43.90/month
- Reduces from 2 to 1 Elastic IP: -$3.72/month
- **Total Savings: $47.62/month**

#### 2. ECS Resource Optimization
**Savings: ~$8/month (5% reduction)**

```hcl
# Reduce ECS resources for development
variable "n8n_cpu" {
  default = 256  # Down from 512
}

variable "n8n_memory" {
  default = 512  # Down from 1024
}
```

**Impact:**
- CPU cost reduction: -$7.53/month
- Memory cost reduction: -$1.66/month
- **Total Savings: $9.19/month**

### 🎯 Medium Impact Optimizations

#### 3. Database Optimization
**Savings: ~$3/month (2% reduction)**

```hcl
# For development environments
variable "db_backup_retention_period" {
  default = 1  # Down from 7 days
}

variable "db_allocated_storage" {
  default = 10  # Down from 20GB if sufficient
}
```

**Impact:**
- Backup storage: -$1.62/month
- Storage cost: -$1.15/month
- **Total Savings: $2.77/month**

#### 4. CloudWatch Log Retention
**Savings: ~$1/month (1% reduction)**

```hcl
# Reduce log retention for development
resource "aws_cloudwatch_log_group" "main" {
  retention_in_days = 7  # Down from 30 days
}
```

### 🎯 Alternative Architectures

#### Option A: Network Load Balancer
**Savings: ~$15/month**

- Replace ALB with NLB if SSL termination isn't required at load balancer level
- NLB costs ~$16/month vs ALB ~$22/month

#### Option B: VPC Endpoints (Advanced)
**Savings: ~$20/month**

- Add VPC endpoints for S3, ECR, CloudWatch
- Reduce NAT Gateway data processing costs
- Initial setup: ~$7/month per endpoint

## Environment-Specific Cost Estimates

### Development Environment
**Optimized Configuration:**
- Single AZ deployment
- Reduced ECS resources (256 CPU, 512MB)
- Minimal backup retention
- Shorter log retention

| Category | Cost |
|----------|------|
| Compute | $25.00 |
| Database | $12.00 |
| Networking | $50.00 |
| Monitoring | $1.50 |
| **TOTAL** | **$88.50** |

### Staging Environment
**Balanced Configuration:**
- Single AZ with higher resources
- Standard backup retention
- Production-like configuration

| Category | Cost |
|----------|------|
| Compute | $35.00 |
| Database | $15.00 |
| Networking | $50.00 |
| Monitoring | $2.00 |
| **TOTAL** | **$102.00** |

### Production Environment
**Current Configuration:**
- Multi-AZ for high availability
- Full redundancy and backup
- Enhanced monitoring

| Category | Cost |
|----------|------|
| Compute | $40.69 |
| Database | $17.59 |
| Networking | $101.13 |
| Monitoring | $2.35 |
| **TOTAL** | **$161.76** |

## Cost Monitoring & Alerts

### AWS Cost Explorer Queries

```bash
# Monthly cost by service
aws ce get-cost-and-usage \
  --time-period Start=2025-09-01,End=2025-10-01 \
  --granularity MONTHLY \
  --metrics BlendedCost \
  --group-by Type=DIMENSION,Key=SERVICE

# Daily costs for current month
aws ce get-cost-and-usage \
  --time-period Start=2025-10-01,End=2025-10-31 \
  --granularity DAILY \
  --metrics BlendedCost

# Cost by resource tags
aws ce get-cost-and-usage \
  --time-period Start=2025-10-01,End=2025-10-31 \
  --granularity MONTHLY \
  --metrics BlendedCost \
  --group-by Type=DIMENSION,Key=RESOURCE_ID
```

### Recommended Cost Alerts

1. **Monthly Budget Alert**: $200/month threshold
2. **Daily Spike Alert**: >$10/day increase
3. **NAT Gateway Alert**: >$120/month (indicates high data transfer)

### Cost Optimization Checklist

- [ ] **Review NAT Gateway usage** - Consider single AZ for non-production
- [ ] **Right-size ECS tasks** - Monitor CPU/memory utilization
- [ ] **Optimize RDS storage** - Use gp3 instead of gp2 for larger databases
- [ ] **Implement log retention policies** - Reduce CloudWatch storage costs
- [ ] **Monitor data transfer** - Identify high NAT Gateway usage
- [ ] **Use Reserved Instances** - For predictable RDS workloads (>1 year)
- [ ] **Implement auto-scaling** - Scale down during off-hours

## Annual Cost Projections

### Current Production Setup
- **Monthly**: $161.76
- **Annual**: $1,941.12

### Optimized Development Setup
- **Monthly**: $88.50
- **Annual**: $1,062.00
- **Annual Savings**: $879.12 (45% reduction)

### Hybrid Approach (Prod + Dev)
- **Production**: $161.76/month
- **Development**: $88.50/month
- **Total**: $250.26/month
- **Annual**: $3,003.12

## Recommendations

### Immediate Actions (Next 30 days)
1. **Implement single AZ for development** - Save $50/month
2. **Right-size ECS resources** - Save $9/month
3. **Set up cost alerts** - Prevent cost overruns

### Medium-term Actions (Next 90 days)
1. **Evaluate NLB vs ALB** - Potential $15/month savings
2. **Implement VPC endpoints** - Reduce data transfer costs
3. **Consider Reserved Instances** - For long-term RDS usage

### Long-term Strategy
1. **Multi-environment optimization** - Separate dev/staging/prod costs
2. **Automated scaling policies** - Reduce costs during off-hours
3. **Regular cost reviews** - Monthly optimization assessments

---

*Last updated: October 2025*
*Prices based on AWS ap-southeast-1 (Singapore) region*

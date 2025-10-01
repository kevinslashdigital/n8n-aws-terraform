# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.networking.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = module.networking.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.networking.private_subnet_ids
}

# Database Outputs
output "db_endpoint" {
  description = "RDS instance endpoint"
  value       = module.database.db_instance_endpoint
}

output "db_port" {
  description = "RDS instance port"
  value       = module.database.db_instance_port
}

output "db_identifier" {
  description = "RDS instance identifier"
  value       = module.database.db_instance_identifier
}

# Load Balancer Outputs
output "load_balancer_dns_name" {
  description = "DNS name of the load balancer"
  value       = module.alb.alb_dns_name
}

output "load_balancer_zone_id" {
  description = "Zone ID of the load balancer"
  value       = module.alb.alb_zone_id
}

output "load_balancer_arn" {
  description = "ARN of the load balancer"
  value       = module.alb.alb_arn
}

# ECS Outputs
output "ecs_cluster_id" {
  description = "ID of the ECS cluster"
  value       = module.ecs.cluster_id
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = module.ecs.cluster_arn
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = module.ecs.service_name
}

# Security Group Outputs
output "alb_security_group_id" {
  description = "ID of the ALB security group"
  value       = module.alb.alb_security_group_id
}

output "ecs_security_group_id" {
  description = "ID of the ECS security group"
  value       = module.ecs.security_group_id
}

output "rds_security_group_id" {
  description = "ID of the RDS security group"
  value       = module.database.db_security_group_id
}

# Application URLs
output "n8n_url" {
  description = "URL to access n8n"
  value = var.certificate_arn != "" ? (
    var.domain_name != "" ? "https://${var.domain_name}" : "https://${module.alb.alb_dns_name}"
  ) : "http://${module.alb.alb_dns_name}"
}

# CloudWatch Log Group
output "log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = module.ecs.log_group_name
}

# SSM Parameter ARNs (for reference)
output "ssm_parameter_arns" {
  description = "ARNs of SSM parameters created"
  value = {
    db_password           = aws_ssm_parameter.db_password.arn
    encryption_key        = aws_ssm_parameter.n8n_encryption_key.arn
    basic_auth_password   = aws_ssm_parameter.n8n_basic_auth_password.arn
  }
  sensitive = true
}

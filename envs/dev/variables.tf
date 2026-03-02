variable "region" {
    description = "AWS region"
    type    = string
    default = "ap-southeast-1"
}

variable "profile" {
    description = "AWS profile"
    type = string
    default = "n8n"
}

# Environment Configuration
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

# VPC Configuration - Single AZ for cost optimization
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.1.0.0/16"  # Different CIDR to avoid conflicts with prod
}

variable "availability_zones" {
  description = "List of availability zones - single AZ for dev"
  type        = list(string)
  default     = ["ap-southeast-1a"]  # Single AZ for cost savings
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.1.1.0/24"]  # Single public subnet
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.1.10.0/24"]  # Single private subnet (not used)
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets - disabled for dev"
  type        = bool
  default     = false  # Disabled to save costs
}

# Load Balancer Variables
variable "certificate_arn" {
  description = "SSL certificate ARN for HTTPS"
  type        = string
  default     = ""  # No SSL for dev
}

variable "domain_name" {
  description = "Domain name for n8n (optional)"
  type        = string
  default     = ""  # No custom domain for dev
}

# Security Variables - More permissive for dev
variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access n8n"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Open for dev - restrict as needed
}

# ECS Variables - Reduced resources for dev
variable "n8n_image" {
  description = "n8n Docker image"
  type        = string
  default     = "n8nio/n8n:latest"
}

variable "n8n_cpu" {
  description = "CPU units for n8n task - reduced for dev"
  type        = number
  default     = 256  # Reduced from 512
}

variable "n8n_memory" {
  description = "Memory for n8n task - reduced for dev"
  type        = number
  default     = 512  # Reduced from 1024
}

variable "n8n_desired_count" {
  description = "Desired number of n8n tasks"
  type        = number
  default     = 1
}

variable "n8n_port" {
  description = "Port for n8n application"
  type        = number
  default     = 5678
}

# n8n Configuration Variables
variable "n8n_encryption_key" {
  description = "Encryption key for n8n"
  type        = string
  sensitive   = true
}

variable "n8n_webhook_url" {
  description = "Webhook URL for n8n"
  type        = string
  default     = ""
}

variable "n8n_timezone" {
  description = "Timezone for n8n"
  type        = string
  default     = "Asia/Singapore"
}

variable "n8n_basic_auth_active" {
  description = "Enable basic authentication for n8n"
  type        = bool
  default     = true  # Enable for dev security
}

variable "n8n_basic_auth_user" {
  description = "Basic auth username for n8n"
  type        = string
  default     = "admin"
}

variable "n8n_basic_auth_password" {
  description = "Basic auth password for n8n"
  type        = string
  sensitive   = true
  default     = ""
}

# Database Variables - Optimized for dev
variable "db_engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "16.3"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"  # Same as prod, already minimal
}

variable "db_allocated_storage" {
  description = "Initial allocated storage for RDS - reduced for dev"
  type        = number
  default     = 10  # Reduced from 20GB
}

variable "db_max_allocated_storage" {
  description = "Maximum allocated storage for RDS autoscaling"
  type        = number
  default     = 50  # Reduced from 100GB
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "n8n_dev"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "n8n_user"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_backup_retention_period" {
  description = "Database backup retention period in days - reduced for dev"
  type        = number
  default     = 1  # Reduced from 7 days
}

variable "db_backup_window" {
  description = "Database backup window"
  type        = string
  default     = "03:00-04:00"
}

variable "db_maintenance_window" {
  description = "Database maintenance window"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "db_skip_final_snapshot" {
  description = "Skip final snapshot when deleting database - enabled for dev"
  type        = bool
  default     = true  # Skip for dev to allow easy cleanup
}

variable "db_deletion_protection" {
  description = "Enable deletion protection for database - disabled for dev"
  type        = bool
  default     = false  # Disabled for dev to allow easy cleanup
}

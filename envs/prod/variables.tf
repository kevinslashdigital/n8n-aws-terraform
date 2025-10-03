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
  default     = "prod"
}

# VPC Configuration
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = true
}

# Load Balancer Variables
variable "certificate_arn" {
  description = "SSL certificate ARN for HTTPS"
  type        = string
  default     = ""
}

variable "domain_name" {
  description = "Domain name for n8n (optional)"
  type        = string
  default     = ""
}

# Security Variables
variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access n8n"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# ECS Variables
variable "n8n_image" {
  description = "n8n Docker image"
  type        = string
  default     = "n8nio/n8n:latest"
}

variable "n8n_cpu" {
  description = "CPU units for n8n task"
  type        = number
  default     = 512
}

variable "n8n_memory" {
  description = "Memory for n8n task"
  type        = number
  default     = 1024
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
  default     = false
}

variable "n8n_basic_auth_user" {
  description = "Basic auth username for n8n"
  type        = string
  default     = ""
}

variable "n8n_basic_auth_password" {
  description = "Basic auth password for n8n"
  type        = string
  sensitive   = true
  default     = ""
}

# Database Variables
variable "db_engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "16.3"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Initial allocated storage for RDS"
  type        = number
  default     = 20
}

variable "db_max_allocated_storage" {
  description = "Maximum allocated storage for RDS autoscaling"
  type        = number
  default     = 100
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "n8n"
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
  description = "Database backup retention period in days"
  type        = number
  default     = 7
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
  description = "Skip final snapshot when deleting database"
  type        = bool
  default     = false
}

variable "db_deletion_protection" {
  description = "Enable deletion protection for database"
  type        = bool
  default     = true
}


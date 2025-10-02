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

# # Database Configuration
# variable "db_instance_class" {
#   description = "RDS instance class"
#   type        = string
#   default     = "db.t3.micro"
# }

# variable "db_allocated_storage" {
#   description = "Initial allocated storage for RDS"
#   type        = number
#   default     = 20
# }

# variable "db_password" {
#   description = "Database password"
#   type        = string
#   sensitive   = true
# }

# variable "db_deletion_protection" {
#   description = "Enable deletion protection for database"
#   type        = bool
#   default     = true
# }

# # n8n Configuration
# variable "n8n_cpu" {
#   description = "CPU units for n8n task"
#   type        = number
#   default     = 512
# }

# variable "n8n_memory" {
#   description = "Memory for n8n task"
#   type        = number
#   default     = 1024
# }

# variable "n8n_desired_count" {
#   description = "Desired number of n8n tasks"
#   type        = number
#   default     = 1
# }

# variable "n8n_encryption_key" {
#   description = "Encryption key for n8n"
#   type        = string
#   sensitive   = true
# }

# # Security Configuration
# variable "allowed_cidr_blocks" {
#   description = "CIDR blocks allowed to access n8n"
#   type        = list(string)
#   default     = ["0.0.0.0/0"]
# }

# # Optional SSL Configuration
# variable "certificate_arn" {
#   description = "SSL certificate ARN for HTTPS"
#   type        = string
#   default     = ""
# }

# variable "domain_name" {
#   description = "Domain name for n8n"
#   type        = string
#   default     = ""
# }

# # Optional Basic Auth Configuration
# variable "n8n_basic_auth_active" {
#   description = "Enable basic authentication for n8n"
#   type        = bool
#   default     = false
# }

# variable "n8n_basic_auth_user" {
#   description = "Basic auth username for n8n"
#   type        = string
#   default     = ""
# }

# variable "n8n_basic_auth_password" {
#   description = "Basic auth password for n8n"
#   type        = string
#   sensitive   = true
#   default     = ""
# }
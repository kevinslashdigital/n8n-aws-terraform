variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where RDS will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for DB subnet group"
  type        = list(string)
}

variable "allowed_security_group_ids" {
  description = "List of security group IDs allowed to access RDS"
  type        = list(string)
}

variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "15.4"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Initial allocated storage for RDS"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum allocated storage for RDS autoscaling"
  type        = number
  default     = 100
}

variable "database_name" {
  description = "Database name"
  type        = string
  default     = "n8n"
}

variable "username" {
  description = "Database username"
  type        = string
  default     = "n8n_user"
}

variable "password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "backup_retention_period" {
  description = "Database backup retention period in days"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "Database backup window"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "Database maintenance window"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when deleting database"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Enable deletion protection for database"
  type        = bool
  default     = true
}

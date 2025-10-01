variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where ECS will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for ECS tasks"
  type        = list(string)
}

variable "allowed_security_group_ids" {
  description = "List of security group IDs allowed to access ECS tasks"
  type        = list(string)
}

# ECS Configuration
variable "cpu" {
  description = "CPU units for ECS task"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memory for ECS task"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 1
}

variable "assign_public_ip" {
  description = "Assign public IP to ECS tasks"
  type        = bool
  default     = false
}

variable "enable_container_insights" {
  description = "Enable CloudWatch Container Insights"
  type        = bool
  default     = true
}

# Container Configuration
variable "container_name" {
  description = "Name of the container"
  type        = string
}

variable "container_image" {
  description = "Docker image for the container"
  type        = string
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
  default     = 80
}

variable "environment_variables" {
  description = "Environment variables for the container"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "secrets" {
  description = "Secrets for the container (from SSM Parameter Store)"
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
}

# Load Balancer Integration
variable "target_group_arn" {
  description = "ARN of the target group for load balancer integration"
  type        = string
  default     = ""
}

variable "alb_listener_arns" {
  description = "List of ALB listener ARNs (for dependency)"
  type        = list(string)
  default     = []
}

# CloudWatch Logs
variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 7
}

# IAM Permissions
variable "ssm_parameter_arns" {
  description = "List of SSM parameter ARNs that the task needs access to"
  type        = list(string)
  default     = []
}

variable "task_policy_statements" {
  description = "Additional IAM policy statements for the ECS task role"
  type        = list(any)
  default     = []
}

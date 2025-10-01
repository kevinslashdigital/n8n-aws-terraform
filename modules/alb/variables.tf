variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where ALB will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for ALB"
  type        = list(string)
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access ALB"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "target_port" {
  description = "Port for the target group"
  type        = number
  default     = 80
}

variable "certificate_arn" {
  description = "SSL certificate ARN for HTTPS"
  type        = string
  default     = ""
}

variable "ssl_policy" {
  description = "SSL policy for HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for ALB"
  type        = bool
  default     = false
}

# Health Check Variables
variable "health_check_path" {
  description = "Health check path"
  type        = string
  default     = "/healthz"
}

variable "health_check_healthy_threshold" {
  description = "Health check healthy threshold"
  type        = number
  default     = 2
}

variable "health_check_unhealthy_threshold" {
  description = "Health check unhealthy threshold"
  type        = number
  default     = 2
}

variable "health_check_timeout" {
  description = "Health check timeout"
  type        = number
  default     = 5
}

variable "health_check_interval" {
  description = "Health check interval"
  type        = number
  default     = 30
}

variable "health_check_matcher" {
  description = "Health check matcher"
  type        = string
  default     = "200"
}

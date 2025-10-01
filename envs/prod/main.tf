module "n8n" {
  source = "../../modules/n8n"

  environment = var.environment

  # VPC Configuration
  vpc_cidr               = var.vpc_cidr
  availability_zones     = var.availability_zones
  public_subnet_cidrs    = var.public_subnet_cidrs
  private_subnet_cidrs   = var.private_subnet_cidrs
  enable_nat_gateway     = var.enable_nat_gateway

  # Database Configuration
  db_instance_class      = var.db_instance_class
  db_allocated_storage   = var.db_allocated_storage
  db_password           = var.db_password
  db_deletion_protection = var.db_deletion_protection

  # n8n Configuration
  n8n_cpu               = var.n8n_cpu
  n8n_memory            = var.n8n_memory
  n8n_desired_count     = var.n8n_desired_count
  n8n_encryption_key    = var.n8n_encryption_key

  # Security Configuration
  allowed_cidr_blocks   = var.allowed_cidr_blocks

  # Optional: SSL Certificate and Domain
  certificate_arn       = var.certificate_arn
  domain_name          = var.domain_name

  # Optional: Basic Auth
  n8n_basic_auth_active   = var.n8n_basic_auth_active
  n8n_basic_auth_user     = var.n8n_basic_auth_user
  n8n_basic_auth_password = var.n8n_basic_auth_password
}
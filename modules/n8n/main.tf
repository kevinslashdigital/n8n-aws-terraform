# Networking Module
module "networking" {
  source = "../networking"

  name_prefix            = "${var.environment}-n8n"
  environment           = var.environment
  vpc_cidr              = var.vpc_cidr
  availability_zones    = var.availability_zones
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  enable_nat_gateway    = var.enable_nat_gateway
}

# RDS Module
module "database" {
  source = "../rds"

  name_prefix                 = "${var.environment}-n8n"
  environment                = var.environment
  vpc_id                     = module.networking.vpc_id
  subnet_ids                 = module.networking.private_subnet_ids
  allowed_security_group_ids = [module.ecs.security_group_id]
  
  engine_version             = var.db_engine_version
  instance_class             = var.db_instance_class
  allocated_storage          = var.db_allocated_storage
  max_allocated_storage      = var.db_max_allocated_storage
  database_name              = var.db_name
  username                   = var.db_username
  password                   = var.db_password
  backup_retention_period    = var.db_backup_retention_period
  backup_window              = var.db_backup_window
  maintenance_window         = var.db_maintenance_window
  skip_final_snapshot        = var.db_skip_final_snapshot
  deletion_protection        = var.db_deletion_protection
}

# Application Load Balancer Module
module "alb" {
  source = "../alb"

  name_prefix         = "${var.environment}-n8n"
  environment        = var.environment
  vpc_id             = module.networking.vpc_id
  subnet_ids         = module.networking.public_subnet_ids
  allowed_cidr_blocks = var.allowed_cidr_blocks
  target_port        = var.n8n_port
  certificate_arn    = var.certificate_arn
}

# SSM Parameters for sensitive data
resource "aws_ssm_parameter" "db_password" {
  name  = "/${var.environment}/n8n/db_password"
  type  = "SecureString"
  value = var.db_password

  tags = {
    Name        = "${var.environment}-n8n-db-password"
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "n8n_encryption_key" {
  name  = "/${var.environment}/n8n/encryption_key"
  type  = "SecureString"
  value = var.n8n_encryption_key

  tags = {
    Name        = "${var.environment}-n8n-encryption-key"
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "n8n_basic_auth_password" {
  name  = "/${var.environment}/n8n/basic_auth_password"
  type  = "SecureString"
  value = var.n8n_basic_auth_password

  tags = {
    Name        = "${var.environment}-n8n-basic-auth-password"
    Environment = var.environment
  }
}

# ECS Module
module "ecs" {
  source = "../ecs"

  name_prefix                = "${var.environment}-n8n"
  environment               = var.environment
  vpc_id                    = module.networking.vpc_id
  subnet_ids                = module.networking.private_subnet_ids
  allowed_security_group_ids = [module.alb.alb_security_group_id]
  
  cpu           = var.n8n_cpu
  memory        = var.n8n_memory
  desired_count = var.n8n_desired_count
  
  container_name  = "n8n"
  container_image = var.n8n_image
  container_port  = var.n8n_port
  
  target_group_arn   = module.alb.target_group_arn
  alb_listener_arns  = [module.alb.http_listener_arn, module.alb.https_listener_arn]
  
  environment_variables = [
    {
      name  = "DB_TYPE"
      value = "postgresdb"
    },
    {
      name  = "DB_POSTGRESDB_HOST"
      value = module.database.db_instance_endpoint
    },
    {
      name  = "DB_POSTGRESDB_PORT"
      value = "5432"
    },
    {
      name  = "DB_POSTGRESDB_DATABASE"
      value = var.db_name
    },
    {
      name  = "DB_POSTGRESDB_USER"
      value = var.db_username
    },
    {
      name  = "N8N_PORT"
      value = tostring(var.n8n_port)
    },
    {
      name  = "GENERIC_TIMEZONE"
      value = var.n8n_timezone
    },
    {
      name  = "N8N_PROTOCOL"
      value = var.certificate_arn != "" ? "https" : "http"
    },
    {
      name  = "N8N_HOST"
      value = var.domain_name != "" ? var.domain_name : module.alb.alb_dns_name
    },
    {
      name  = "WEBHOOK_URL"
      value = var.n8n_webhook_url != "" ? var.n8n_webhook_url : (var.certificate_arn != "" ? "https://${var.domain_name != "" ? var.domain_name : module.alb.alb_dns_name}" : "http://${module.alb.alb_dns_name}")
    },
    {
      name  = "N8N_BASIC_AUTH_ACTIVE"
      value = tostring(var.n8n_basic_auth_active)
    },
    {
      name  = "N8N_BASIC_AUTH_USER"
      value = var.n8n_basic_auth_user
    }
  ]
  
  secrets = [
    {
      name      = "DB_POSTGRESDB_PASSWORD"
      valueFrom = aws_ssm_parameter.db_password.arn
    },
    {
      name      = "N8N_ENCRYPTION_KEY"
      valueFrom = aws_ssm_parameter.n8n_encryption_key.arn
    },
    {
      name      = "N8N_BASIC_AUTH_PASSWORD"
      valueFrom = aws_ssm_parameter.n8n_basic_auth_password.arn
    }
  ]
  
  ssm_parameter_arns = [
    aws_ssm_parameter.db_password.arn,
    aws_ssm_parameter.n8n_encryption_key.arn,
    aws_ssm_parameter.n8n_basic_auth_password.arn
  ]
}

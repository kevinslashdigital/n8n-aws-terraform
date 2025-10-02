provider "aws" {
  region = var.region
  profile = var.profile
}

# Networking Module
module "networking" {
  source = "../../modules/networking"

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
  source = "../../modules/rds"

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
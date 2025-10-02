provider "aws" {
  region = var.region
  profile = var.profile
}

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
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
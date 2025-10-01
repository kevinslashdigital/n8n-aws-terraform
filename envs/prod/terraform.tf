terraform {
  required_version = ">= 1.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  # Uncomment and configure after bootstrap is complete
  # backend "s3" {
  #   bucket         = "n8n-tf-state-{random_suffix}"
  #   key            = "envs/prod/terraform.tfstate"
  #   region         = "ap-southeast-1"
  #   dynamodb_table = "n8n-tf-locks"
  #   profile        = "n8n"
  # }
}

terraform {
  backend "s3" {
    # bucket, dynamodb_table will be provided via -backend-config
    key     = "envs/prod/terraform.tfstate"
    region  = "ap-southeast-1"
    encrypt = true
    profile = "n8n"
  }
}
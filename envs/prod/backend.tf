terraform {
  backend "s3" {
    key     = "envs/prod/terraform.tfstate"
    region  = "ap-southeast-1"
    encrypt = true
    # DynamoDB locking disabled - using S3 only
  }
}
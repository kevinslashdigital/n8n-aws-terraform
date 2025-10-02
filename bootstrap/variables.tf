variable "region" {
    description = "AWS region"
    type    = string
    default = "ap-southeast-1"
}

variable "profile" {
    description = "AWS profile"
    type = string
    default = "n8n"
}

variable "state_bucket" {
    description = "S3 bucket name for Terraform state"
    type = string
    default = "n8n-tf-state"
}
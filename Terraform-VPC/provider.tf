terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.16.1"
    }
  }

  backend "s3" {
    bucket         = "terraform-remote-backend-s3-githubactions"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-lock-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "terraform-lock-table"
  }
}

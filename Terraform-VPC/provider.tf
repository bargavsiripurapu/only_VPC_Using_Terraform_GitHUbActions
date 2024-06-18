terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.16.1"
    }
  }

  backend "s3" {
    bucket         = "terraform-remote-backend-s3-githubactions"
    dynamodb_table = "terraform-lock-table"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = false
    
  }
}

provider "aws" {
  region = "us-east-1"
}

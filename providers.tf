# providers.tf
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.0"
    }
  }
}

# Configure the AWS Provider to use our desired region
provider "aws" {
  region = var.aws_region # This will pull from the variable we define next
}
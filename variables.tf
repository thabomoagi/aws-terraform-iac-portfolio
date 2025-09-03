# variables.tf
variable "aws_region" {
  description = "The AWS region to deploy resources into (e.g., af-south-1)."
  type        = string
  default     = "af-south-1" # Your chosen region is set as the default
}

variable "portfolio_bucket_name" {
  description = "The base name for the S3 bucket. A random suffix will be added to ensure it's globally unique."
  type        = string
  default     = "my-terraform-portfolio" # You can change this to your name
}
# outputs.tf

# Output the direct S3 website URL
output "website_url" {
  description = "The URL of the website hosted on S3"
  value       = "http://${aws_s3_bucket.portfolio_website.bucket}.s3-website.${aws_s3_bucket.portfolio_website.region}.amazonaws.com"
}

# Output the bucket name for reference
output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.portfolio_website.bucket
}

# Output the region for verification
output "aws_region" {
  description = "The AWS region where resources are deployed"
  value       = aws_s3_bucket.portfolio_website.region
}
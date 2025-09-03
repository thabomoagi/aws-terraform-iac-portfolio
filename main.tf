# main.tf
# Generate a random suffix to ensure our S3 bucket name is unique worldwide
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Create the S3 bucket with a unique name
resource "aws_s3_bucket" "portfolio_website" {
  # This uses the variable and appends the random suffix
  bucket = "${var.portfolio_bucket_name}-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "My Portfolio Website"
    Environment = "Free Tier"
    Project     = "Terraform Deployment"
  }
}

# Configure the bucket to host a static website
resource "aws_s3_bucket_website_configuration" "portfolio" {
  bucket = aws_s3_bucket.portfolio_website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Set the bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "portfolio" {
  bucket = aws_s3_bucket.portfolio_website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Configure public access settings (we are explicitly allowing public read for a website)
resource "aws_s3_bucket_public_access_block" "portfolio" {
  bucket = aws_s3_bucket.portfolio_website.id

  # THESE MUST ALL BE SET TO FALSE TO ALLOW THE PUBLIC WEBSITE
  block_public_acls       = false
  block_public_policy     = false # This is the one that was causing the error!
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Set the bucket ACL to public-read
resource "aws_s3_bucket_acl" "portfolio" {
  # This ensures the ACL is set only after the public access block is configured
  depends_on = [
    aws_s3_bucket_ownership_controls.portfolio,
    aws_s3_bucket_public_access_block.portfolio,
  ]

  bucket = aws_s3_bucket.portfolio_website.id
  acl    = "public-read"
}

# Create a bucket policy that explicitly allows public read access to all objects
data "aws_iam_policy_document" "allow_public_read" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.portfolio_website.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "allow_public_read" {
  bucket = aws_s3_bucket.portfolio_website.id
  policy = data.aws_iam_policy_document.allow_public_read.json
}
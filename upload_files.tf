# upload_files.tf

# A local value to map file extensions to their correct MIME types
# This is crucial for browsers to understand how to handle the files
locals {
  mime_types = {
    "html" = "text/html"
    "css"  = "text/css"
    "js"   = "application/javascript"
    "png"  = "image/png"
    "jpg"  = "image/jpeg"
    "jpeg" = "image/jpeg"
    "svg"  = "image/svg+xml"
    "ico"  = "image/x-icon"
    "txt"  = "text/plain"
  }
}

# This resource uses fileset() to find all files in the "website/" directory,
# and for each one, it uploads them to S3 with the correct content type
resource "aws_s3_object" "website_files" {
  for_each = fileset("website/", "**") # Finds all files in the website folder

  bucket = aws_s3_bucket.portfolio_website.id  # Reference the bucket we created
  key    = each.value                          # The file path inside the bucket
  source = "website/${each.value}"             # The local file path

  # Get the file extension, look up its MIME type, or default to "binary/octet-stream"
  content_type = lookup(local.mime_types, split(".", each.value)[length(split(".", each.value)) - 1], "binary/octet-stream")
  
  # ETag is a checksum of the file content. This helps Terraform know if the file has changed and needs to be re-uploaded.
  etag = filemd5("website/${each.value}")
}
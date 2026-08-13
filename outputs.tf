# -----------------------
# S3 Bucket Outputs
# -----------------------
output "s3_bucket_id" {
  description = "ID of the S3 Bucket hosting the static website"
  value       = aws_s3_bucket.web_bucket.id
}


# ------------------------
# Cloudfront outputs
# ------------------------
output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.s3_distribution.id
}

output "cloudfront_domain_name" {
  description = "Cloudfront distribution domain name"
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
}

# -------------------------- 
# Website URL
# --------------------------
output "website_url" {
  description = "URL of the static website through cloudfront"
  value       = "https://${aws_cloudfront_distribution.s3_distribution.domain_name}"
}
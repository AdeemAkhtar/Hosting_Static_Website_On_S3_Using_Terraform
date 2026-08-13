# ----------------------------------------------
# S3 bucket for storing the sstatic web content
# ----------------------------------------------
resource "aws_s3_bucket" "web_bucket" {
  bucket = var.web_bucket_name
}

# ---------------------------------------------
# Blocking the public access to the S3 bucket
# ---------------------------------------------
resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.web_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# --------------------------------
# aws s3 bucket policy declaration
# --------------------------------
resource "aws_s3_bucket_policy" "name" {
  bucket     = aws_s3_bucket.web_bucket.id
  depends_on = [aws_s3_bucket_public_access_block.block]

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Statement1",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudfront.amazonaws.com"
        },
        "Action" : [
          "s3:GetObject"
        ],
        "Resource" : "${aws_s3_bucket.web_bucket.arn}/*",
        "Condition" : {
          "StringEquals" : {
            "AWS:SourceArn" : aws_cloudfront_distribution.s3_distribution.arn
          }
        }
      }
    ]
  })
}

# --------------------------------------------------
# Uploading objects (static web files) on s3 bucket
# --------------------------------------------------

resource "aws_s3_object" "object" {

  for_each = fileset("${path.module}/www", "**/*")
  bucket   = aws_s3_bucket.web_bucket.id
  key      = each.value
  source   = "${path.module}/www/${each.value}"
  etag     = filemd5("${path.module}/www/${each.value}")
  content_type = lookup({
    "html" = "text/html",
    "css"  = "text/css",
    "js"   = "application/javascript",
    "json" = "application/json",
    "png"  = "image/png",
    "jpg"  = "image/jpeg",
    "jpeg" = "image/jpeg",
    "gif"  = "image/gif",
    "svg"  = "image/svg+xml",
    "ico"  = "image/x-icon",
    "txt"  = "text/plain"
  }, split(".", each.value)[length(split(".", each.value)) - 1], "application/octet-stream")
}


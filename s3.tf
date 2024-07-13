resource "aws_s3_bucket" "public_fortune_bucket" {
  bucket_prefix = "public-fortune-bucket-"
  tags = {
    Name        = "MyPublicBucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "fortune_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.public_fortune_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_fortune_bucket_policy" {
  bucket = aws_s3_bucket.public_fortune_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.public_fortune_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.public_fortune_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "index" { # TODO automate changing request url inside index.html
  bucket       = aws_s3_bucket.public_fortune_bucket.bucket
  key          = "index.html"
  source       = "./resources/s3/index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.public_fortune_bucket.bucket
  key          = "error.html"
  source       = "./resources/s3/error.html"
  content_type = "text/html"
}

resource "aws_s3_object" "cookieJpg" {
  bucket = aws_s3_bucket.public_fortune_bucket.bucket
  key    = "cookie.jpg"
  source = "./resources/s3/cookie.jpg"
}

output "bucket_name" {
  value = aws_s3_bucket.public_fortune_bucket.bucket
}

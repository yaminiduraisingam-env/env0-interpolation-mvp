data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "network" {
  bucket = "tf-remote-backend-workflow-network-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket_public_access_block" "network" {
  bucket = aws_s3_bucket.network.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "network" {
  bucket = aws_s3_bucket.network.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

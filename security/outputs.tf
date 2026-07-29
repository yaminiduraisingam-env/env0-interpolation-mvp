output "module_name" {
  value       = "security"
  description = "Identifies which module ran"
}

output "status" {
  value       = "local-state: real resources created"
  description = "Confirms this step provisions real infra with env0-managed state, pre-migration"
}

output "bucket_name" {
  value       = aws_s3_bucket.security.bucket
  description = "Name of the S3 bucket created by the security workflow step"
}

output "bucket_arn" {
  value       = aws_s3_bucket.security.arn
  description = "ARN of the S3 bucket created by the security workflow step"
}

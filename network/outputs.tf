output "module_name" {
  value       = "network"
  description = "Identifies which module ran"
}

output "status" {
  value       = "remote-backend: real resources created"
  description = "Confirms this step now provisions real infra with state in the S3 remote backend"
}

output "bucket_name" {
  value       = aws_s3_bucket.network.bucket
  description = "Name of the S3 bucket created by the network workflow step"
}

output "bucket_arn" {
  value       = aws_s3_bucket.network.arn
  description = "ARN of the S3 bucket created by the network workflow step"
}

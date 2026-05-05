terraform {
  required_version = ">= 1.5.0"
}

output "module_name" {
  value       = "test"
  description = "Pending Approval"
}

output "status" {
  value       = "no-op: no resources created"
  description = "Confirms this is a no-op execution"
}

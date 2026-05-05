terraform {
  required_version = ">= 1.5.0"
}

output "module_name" {
  value       = "data"
  description = "Change is made to push"
}

output "status" {
  value       = "no-op: no resources created"
  description = "Confirms this is a no-op execution"
}

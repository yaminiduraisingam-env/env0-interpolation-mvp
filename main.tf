terraform {
  required_version = ">= 1.7.0"
}

output "module_name" {
  value       = "app"
  description = "Identifies which no-op module ran"
}

output "status" {
  value       = "no-op: no resources created"
  description = "Confirms this is a no-op execution"
}

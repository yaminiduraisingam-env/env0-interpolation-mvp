terraform {
  required_version = ">= 1.5.0"
}

output "module_name" {
  value       = "data"
  description = "Identifies which no-op module ran-test"
}

output "status" {
  value       = "no-op: no resources created"
  description = "Confirms this is a no-op execution"
}

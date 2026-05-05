terraform {
  required_version = ">= 1.5.0"
}

output "module_name" {
  value       = "monitoring - test"
  description = "Identifies which no-op module rans"
}

output "status" {
  value       = "no-op: no resources created"
  description = "Confirms this is a no-op execution"
}

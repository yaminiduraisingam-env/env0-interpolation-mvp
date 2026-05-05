terraform {
  required_version = ">= 1.5.0"
}

output "module_name" {
  value       = "test1 test"
  description = "test test test"
}

output "status" {
  value       = "no-op: no resources created"
  description = "Confirms this is a no-op execution"
}

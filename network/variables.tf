variable "env_prefix" {
  description = "Environment prefix injected from env0 variable WORKFLOW_ENV_PREFIX"
  type        = string
  default     = "mvp"
}

variable "workspace_id" {
  description = "Workspace identifier injected from env0 variable WORKSPACE_ID"
  type        = string
  default     = "default"
}

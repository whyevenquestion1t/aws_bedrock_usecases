variable "name_prefix" {
  description = "Prefix applied to named resources created by this example."
  type        = string
  default     = "bedrock-usecase"
}

variable "region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "Additional tags merged into every resource's tag set."
  type        = map(string)
  default     = {}
}

variable "model_id" {
  description = <<-EOT
    Foundation model ID to run batch inference against. Must support batch
    inference in the chosen region -- confirm in the Bedrock console before
    applying.
  EOT
  type        = string
  default     = "anthropic.claude-3-5-haiku-20241022-v1:0"
}

variable "skip_destroy" {
  description = "If true, `terraform destroy` stops tracking the job instead of attempting to stop/delete it. Set true for jobs you want to keep running or whose output you still need after destroying everything else."
  type        = bool
  default     = false
}

variable "timeout_duration_in_hours" {
  description = "Maximum runtime for the batch job before Bedrock stops it automatically."
  type        = number
  default     = 24
}

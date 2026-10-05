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
  description = "Foundation model ID to evaluate."
  type        = string
  default     = "amazon.nova-micro-v1:0"
}

variable "skip_destroy" {
  description = <<-EOT
    Bedrock does not support permanently deleting an evaluation job.
    Defaults to true so `terraform destroy` doesn't fail trying to delete a
    job AWS won't let it delete -- it simply stops tracking the job instead.
  EOT
  type        = bool
  default     = true
}

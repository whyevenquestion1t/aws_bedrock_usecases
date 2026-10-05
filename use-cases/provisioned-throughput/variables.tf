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

variable "model_arn" {
  description = <<-EOT
    ARN of the model to provision throughput for. For the no-commitment path
    (the default in this example) this must be a custom (fine-tuned or
    distilled) model ARN -- on-demand provisioned throughput without a
    commitment is only available for custom models. Confirm your custom
    model's ARN in the Bedrock console.
  EOT
  type        = string
  default     = "arn:aws:bedrock:us-east-1:111111111111:custom-model/example-custom-model"
}

variable "model_units" {
  description = "Number of model units to allocate. Each unit is billed continuously for as long as it exists (and for the full commitment term, if any)."
  type        = number
  default     = 1
}

variable "commitment_duration" {
  description = <<-EOT
    Commitment duration for discounted provisioned throughput: "OneMonth" or
    "SixMonths". Leave null for no-commitment throughput, which is only
    valid for custom models. Committed throughput bills for the full term
    and cannot be cancelled early -- see README before setting this.
  EOT
  type        = string
  default     = null
}

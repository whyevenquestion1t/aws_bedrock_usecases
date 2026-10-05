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
    Foundation model ID to accept the EULA/offer for. Confirm the current
    model ID and its regional availability in the Bedrock console before
    applying -- model IDs and offer requirements change over time.
  EOT
  type        = string
  default     = "anthropic.claude-opus-4-5-20251101-v1:0"
}

variable "offer_type" {
  description = "Offer type to look up. PUBLIC is correct for standard account-level acceptance."
  type        = string
  default     = "PUBLIC"
}

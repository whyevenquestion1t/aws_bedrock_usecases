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

variable "company_name" {
  description = "Company name to submit on the model access use-case form."
  type        = string
  default     = "Example Corp"
}

variable "company_website" {
  description = "Company website to submit on the model access use-case form."
  type        = string
  default     = "https://www.example.com"
}

variable "industry" {
  description = "Industry option to submit on the model access use-case form (e.g. Healthcare, Financial Services, Energy)."
  type        = string
  default     = "Technology"
}

variable "intended_users" {
  description = "Estimated number of intended users, as required by the use-case form."
  type        = string
  default     = "0"
}

variable "use_case_description" {
  description = "Free-text description of the intended Bedrock use case(s)."
  type        = string
  default     = <<-EOT
    - Internal document summarization
    - Code generation and refactoring assistance
    - Customer support ticket triage
  EOT
}

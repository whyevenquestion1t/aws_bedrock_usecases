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

variable "guardrail_name" {
  description = "Name for the guardrail."
  type        = string
  default     = "support-chatbot-guardrail"
}

variable "denied_topics" {
  description = "Topics the chatbot should refuse to discuss."
  type = list(object({
    name       = string
    definition = string
    examples   = list(string)
  }))
  default = [
    {
      name       = "competitor_discussion"
      definition = "Questions asking the assistant to compare, recommend, or disparage named competitor products or companies."
      examples   = ["What do you think of [Competitor]'s product?", "Is [Competitor] better than you?"]
    }
  ]
}

variable "blocked_words" {
  description = "Custom words/phrases to block outright, beyond the managed profanity list."
  type        = list(string)
  default     = ["internal-codename-x"]
}

variable "pii_entity_types" {
  description = "PII entity types to detect and act on in both input and output."
  type        = list(string)
  default     = ["EMAIL", "US_SOCIAL_SECURITY_NUMBER", "PHONE"]
}

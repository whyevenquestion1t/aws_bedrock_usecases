output "model_id" {
  description = "Model ID the agreement was accepted for."
  value       = aws_bedrock_foundation_model_agreement.this.model_id
}

output "account_id" {
  description = "AWS account the agreement applies to."
  value       = data.aws_caller_identity.current.account_id
}

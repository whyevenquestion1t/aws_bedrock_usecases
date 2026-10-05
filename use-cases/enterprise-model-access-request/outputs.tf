output "form_data" {
  description = "The JSON-encoded form data submitted for model access."
  value       = aws_bedrock_use_case_for_model_access.this.form_data
}

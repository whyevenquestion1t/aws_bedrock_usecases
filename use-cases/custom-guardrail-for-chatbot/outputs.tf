output "guardrail_id" {
  description = "Guardrail identifier."
  value       = aws_bedrock_guardrail.this.guardrail_id
}

output "guardrail_arn" {
  description = "Guardrail ARN."
  value       = aws_bedrock_guardrail.this.guardrail_arn
}

output "guardrail_version" {
  description = "Published, invocable guardrail version."
  value       = aws_bedrock_guardrail_version.this.version
}

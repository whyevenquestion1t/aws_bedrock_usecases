output "provisioned_model_arn" {
  description = "ARN of the provisioned throughput, for wiring into an application's InvokeModel calls."
  value       = aws_bedrock_provisioned_model_throughput.this.provisioned_model_arn
}

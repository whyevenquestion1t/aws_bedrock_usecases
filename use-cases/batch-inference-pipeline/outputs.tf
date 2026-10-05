output "job_arn" {
  description = "ARN of the batch inference job."
  value       = aws_bedrock_model_invocation_job.this.job_arn
}

output "status" {
  description = "Current job status."
  value       = aws_bedrock_model_invocation_job.this.status
}

output "input_bucket" {
  description = "S3 bucket containing input prompts."
  value       = aws_s3_bucket.input.id
}

output "output_bucket" {
  description = "S3 bucket where results are written."
  value       = aws_s3_bucket.output.id
}

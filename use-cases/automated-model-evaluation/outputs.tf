output "job_arn" {
  description = "ARN of the evaluation job."
  value       = aws_bedrock_evaluation_job.this.job_arn
}

output "status" {
  description = "Current job status."
  value       = aws_bedrock_evaluation_job.this.status
}

output "output_bucket" {
  description = "S3 bucket where evaluation results are written."
  value       = aws_s3_bucket.output.id
}

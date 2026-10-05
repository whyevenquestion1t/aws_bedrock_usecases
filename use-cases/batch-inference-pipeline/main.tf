locals {
  tags = merge(var.tags, {
    Project   = "aws-bedrock-usecases"
    UseCase   = "batch-inference-pipeline"
    ManagedBy = "terraform"
  })
}

# Batch-summarizes every prompt in the input bucket and writes results to
# the output bucket, asynchronously. This is the right tool for processing
# a large, bounded set of documents -- not for real-time chat.
resource "aws_bedrock_model_invocation_job" "this" {
  depends_on = [time_sleep.iam_propagation, aws_s3_object.sample_prompts]

  job_name                  = "${var.name_prefix}-batch-summarization"
  model_id                  = var.model_id
  role_arn                  = aws_iam_role.batch_job.arn
  skip_destroy              = var.skip_destroy
  timeout_duration_in_hours = var.timeout_duration_in_hours

  input_data_config {
    s3_input_data_config {
      s3_uri = "s3://${aws_s3_bucket.input.id}/input/"
    }
  }

  output_data_config {
    s3_output_data_config {
      s3_uri = "s3://${aws_s3_bucket.output.id}/output/"
    }
  }
}

locals {
  tags = merge(var.tags, {
    Project   = "aws-bedrock-usecases"
    UseCase   = "automated-model-evaluation"
    ManagedBy = "terraform"
  })
}

# Automated evaluation job benchmarking a model on built-in Bedrock metrics
# before promoting it to production. Human-based evaluation (requiring a
# work team / human workflow) is out of scope for this pure-Terraform
# example -- see README.
resource "aws_bedrock_evaluation_job" "this" {
  job_name         = "${var.name_prefix}-automated-eval"
  job_description  = "Automated robustness evaluation of ${var.model_id} prior to production promotion."
  role_arn         = aws_iam_role.eval_job.arn
  application_type = "ModelEvaluation"
  skip_destroy     = var.skip_destroy

  customer_encryption_key_id = aws_kms_key.eval_results.arn

  evaluation_config {
    automated {
      dataset_metric_config {
        task_type = "Generation"

        dataset {
          name = "Builtin.Bold"
        }

        metric_names = ["Builtin.Robustness"]
      }
    }
  }

  inference_config {
    model {
      bedrock_model {
        model_identifier = var.model_id
      }
    }
  }

  output_data_config {
    s3_uri = "s3://${aws_s3_bucket.output.id}/output/"
  }

  tags = local.tags
}

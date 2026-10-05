data "aws_iam_policy_document" "trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["bedrock.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = ["arn:aws:bedrock:${var.region}:${data.aws_caller_identity.current.account_id}:model-invocation-job/*"]
    }
  }
}

resource "aws_iam_role" "batch_job" {
  name               = "${var.name_prefix}-batch-inference-role"
  assume_role_policy = data.aws_iam_policy_document.trust.json
}

data "aws_iam_policy_document" "batch_job_permissions" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:ListBucket"]
    resources = [aws_s3_bucket.input.arn, "${aws_s3_bucket.input.arn}/*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.output.arn}/*"]
  }
}

resource "aws_iam_role_policy" "batch_job" {
  name   = "${var.name_prefix}-batch-inference-s3"
  role   = aws_iam_role.batch_job.id
  policy = data.aws_iam_policy_document.batch_job_permissions.json
}

# IAM is eventually consistent -- without this buffer, job creation can race
# the role/policy becoming usable and fail on first apply.
resource "time_sleep" "iam_propagation" {
  depends_on      = [aws_iam_role_policy.batch_job]
  create_duration = "15s"
}

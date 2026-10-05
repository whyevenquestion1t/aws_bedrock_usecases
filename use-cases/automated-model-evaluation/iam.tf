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
      values   = ["arn:aws:bedrock:${var.region}:${data.aws_caller_identity.current.account_id}:evaluation-job/*"]
    }
  }
}

resource "aws_iam_role" "eval_job" {
  name               = "${var.name_prefix}-eval-job-role"
  assume_role_policy = data.aws_iam_policy_document.trust.json
}

data "aws_iam_policy_document" "eval_job_permissions" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject", "s3:GetObject"]
    resources = ["${aws_s3_bucket.output.arn}/*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["kms:GenerateDataKey", "kms:Decrypt"]
    resources = [aws_kms_key.eval_results.arn]
  }
}

resource "aws_iam_role_policy" "eval_job" {
  name   = "${var.name_prefix}-eval-job-s3-kms"
  role   = aws_iam_role.eval_job.id
  policy = data.aws_iam_policy_document.eval_job_permissions.json
}

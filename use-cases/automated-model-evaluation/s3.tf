data "aws_caller_identity" "current" {}

locals {
  output_bucket_name = "${var.name_prefix}-eval-output-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket" "output" {
  bucket = local.output_bucket_name
}

resource "aws_s3_bucket_public_access_block" "output" {
  bucket                  = aws_s3_bucket.output.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "output" {
  bucket = aws_s3_bucket.output.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.eval_results.arn
    }
    bucket_key_enabled = true
  }
}

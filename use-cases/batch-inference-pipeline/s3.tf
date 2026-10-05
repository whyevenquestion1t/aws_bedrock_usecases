data "aws_caller_identity" "current" {}

locals {
  input_bucket_name  = "${var.name_prefix}-batch-input-${data.aws_caller_identity.current.account_id}"
  output_bucket_name = "${var.name_prefix}-batch-output-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket" "input" {
  bucket = local.input_bucket_name
}

resource "aws_s3_bucket_public_access_block" "input" {
  bucket                  = aws_s3_bucket.input.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "input" {
  bucket = aws_s3_bucket.input.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
    bucket_key_enabled = true
  }
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
      sse_algorithm = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

# Sample fixture: 100 synthetic contract-summarization prompts, sized to
# meet Bedrock batch inference's documented minimum record count per job.
# Confirm the current minimum/maximum in AWS docs -- it has changed before.
resource "aws_s3_object" "sample_prompts" {
  bucket = aws_s3_bucket.input.id
  key    = "input/prompts.jsonl"
  source = "${path.module}/sample-data/prompts.jsonl"
  etag   = filemd5("${path.module}/sample-data/prompts.jsonl")
}

resource "aws_kms_key" "eval_results" {
  description             = "Encrypts Bedrock evaluation job output for ${var.name_prefix}."
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_kms_alias" "eval_results" {
  name          = "alias/${var.name_prefix}-bedrock-eval-results"
  target_key_id = aws_kms_key.eval_results.key_id
}

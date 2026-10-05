locals {
  tags = merge(var.tags, {
    Project   = "aws-bedrock-usecases"
    UseCase   = "provisioned-throughput"
    ManagedBy = "terraform"
  })
}

# No-commitment provisioned throughput for a custom model. This is the only
# combination that can be destroyed freely without an early-termination
# penalty, so it's the default this example applies.
#
# To instead demonstrate committed, discounted throughput for a base model
# (billed for the full term, cannot be cancelled early), set
# commitment_duration to "OneMonth" or "SixMonths" via terraform.tfvars and
# point model_arn at a base foundation model ARN instead of a custom model.
resource "aws_bedrock_provisioned_model_throughput" "this" {
  provisioned_model_name = "${var.name_prefix}-provisioned-throughput"
  model_arn              = var.model_arn
  model_units            = var.model_units
  commitment_duration    = var.commitment_duration

  tags = local.tags
}

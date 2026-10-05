data "aws_caller_identity" "current" {}

locals {
  tags = merge(var.tags, {
    Project   = "aws-bedrock-usecases"
    UseCase   = "model-access-agreement"
    ManagedBy = "terraform"
  })
}

# Looks up the offer token required to accept this model's EULA/offer for
# the calling account. The offer token is opaque and can rotate without
# representing a real configuration change -- see the lifecycle block below.
data "aws_bedrock_foundation_model_agreement_offers" "this" {
  model_id   = var.model_id
  offer_type = var.offer_type
}

# Accepts the EULA/offer so application teams in this account can invoke
# the model. This is an account-level, one-time bootstrap action: destroying
# this resource does not revoke a signed EULA.
resource "aws_bedrock_foundation_model_agreement" "this" {
  model_id    = data.aws_bedrock_foundation_model_agreement_offers.this.model_id
  offer_token = data.aws_bedrock_foundation_model_agreement_offers.this.offers[0].offer_token

  lifecycle {
    ignore_changes = [offer_token]
  }
}

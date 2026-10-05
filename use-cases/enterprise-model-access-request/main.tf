locals {
  tags = merge(var.tags, {
    Project   = "aws-bedrock-usecases"
    UseCase   = "enterprise-model-access-request"
    ManagedBy = "terraform"
  })

  # Typed object authored as HCL, then JSON-encoded into the form the
  # resource expects. Easier for contributors to read/edit than a raw JSON
  # string literal.
  form_data = {
    companyName         = var.company_name
    companyWebsite      = var.company_website
    intendedUsers       = var.intended_users
    industryOption      = var.industry
    otherIndustryOption = ""
    useCases            = var.use_case_description
  }
}

# Submits the "intended use case" questionnaire some model providers
# (historically Anthropic) require before Bedrock grants model access in
# this account. This resource adopts an existing submission rather than
# duplicating one, cannot be updated after creation, and does not delete
# anything on `terraform destroy` -- see the README before applying.
resource "aws_bedrock_use_case_for_model_access" "this" {
  form_data = jsonencode(local.form_data)
}

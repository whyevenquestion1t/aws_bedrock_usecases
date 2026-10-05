# Enterprise model access request

**Resource:** [`aws_bedrock_use_case_for_model_access`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrock_use_case_for_model_access)
**Role in this repo:** prerequisite

## Scenario

A regulated enterprise -- e.g. a healthcare or financial services
organization -- must submit an "intended use case" questionnaire that
certain model providers require before Bedrock grants model access in the
account, describing (for example) that the models will be used for internal
document summarization rather than public-facing automated decisions.

This is the second, distinct prerequisite gate in this repo, separate from
accepting a model's EULA/offer -- see
[`model-access-agreement`](../model-access-agreement). Both gates were
historically associated with Anthropic models specifically; AWS has loosened
model-provider access policies over time, so check your Bedrock console's
"Model access" page to confirm whether this step is actually required for
the model and account you're targeting before applying.

## What this creates

- Builds a typed `form_data` object from variables (company name, website,
  industry, intended user count, use-case description) and submits it via
  `aws_bedrock_use_case_for_model_access`.

No IAM role, S3 bucket, or KMS key is needed -- this is an account-level
Bedrock API call.

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars with your organization's real details
terraform init
terraform apply
```

## Caveats

Per the AWS provider's documented behavior for this resource:

- **It adopts an existing use case** rather than creating a duplicate if the
  account already has one submitted.
- **It cannot be updated.** Changing `form_data` forces replacement, and
  even then AWS may simply re-adopt the existing submission.
- **It does not delete anything on `terraform destroy`.** The submission
  persists at the AWS account level regardless of Terraform state.

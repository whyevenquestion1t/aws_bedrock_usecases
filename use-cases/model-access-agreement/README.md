# Model access agreement

**Resource:** [`aws_bedrock_foundation_model_agreement`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrock_foundation_model_agreement)
**Role in this repo:** prerequisite

## Scenario

A platform team onboarding a new AWS account needs to accept the EULA/offer
for a foundation model before any application team in that account can
invoke it. Today this is normally a manual click-through in the Bedrock
console; this example does it with Terraform instead, so it can be run once
as part of account bootstrap automation.

This is the first of two prerequisite gates in this repo -- see also
[`enterprise-model-access-request`](../enterprise-model-access-request). Not
every model requires both; check the Bedrock console's "Model access" page
for your account/region to see which gates apply to the model you want.

## What this creates

- Looks up the current offer token for `var.model_id` via the
  `aws_bedrock_foundation_model_agreement_offers` data source.
- Accepts that offer for the account via `aws_bedrock_foundation_model_agreement`.

No IAM role, S3 bucket, or KMS key is needed -- this only talks to the
Bedrock marketplace API for the calling account.

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars: set model_id to the model you need access to
terraform init
terraform apply
```

## Caveats

- **This is a one-time, account-level action.** `terraform destroy` removes
  the Terraform resource from state but does **not** revoke a signed EULA.
  Treat this as account bootstrap, not per-project infrastructure -- it's
  often run once centrally rather than per application.
- The `offer_token` is opaque and can rotate independently of any real
  configuration change, which is why `lifecycle { ignore_changes =
  [offer_token] }` is set on the resource.
- Model IDs and which models require explicit agreement change over time.
  Confirm the current model ID and requirement in the Bedrock console
  before applying.

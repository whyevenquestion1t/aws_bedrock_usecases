# Architecture notes

Cross-cutting notes that don't belong in any single use case's README.

## The model-access prerequisite chain

Two use cases in this repo are account-level prerequisites, not
application infrastructure:

- [`model-access-agreement`](../use-cases/model-access-agreement) accepts a
  foundation model's EULA/offer in the account
  (`aws_bedrock_foundation_model_agreement`).
- [`enterprise-model-access-request`](../use-cases/enterprise-model-access-request)
  submits the "intended use case" questionnaire some model providers require
  (`aws_bedrock_use_case_for_model_access`).

Until both are satisfied for a given model in a given account (where the
model provider requires them), `InvokeModel`/`Converse` calls against that
model — and resources built on top of it, like provisioned throughput or
batch inference jobs — will fail. Check the Bedrock console's "Model access"
page for your account/region before running the other four examples.

## Resources that don't clean up on `terraform destroy`

- `aws_bedrock_evaluation_job` — Bedrock does not support permanently
  deleting an evaluation job. The
  [`automated-model-evaluation`](../use-cases/automated-model-evaluation)
  example sets `skip_destroy = true` by default to avoid a confusing
  apply-time error on first destroy.
- `aws_bedrock_use_case_for_model_access` — this resource adopts an existing
  use-case submission rather than duplicating one, cannot be updated after
  creation, and does not delete anything on `terraform destroy`. The
  submission persists at the AWS account level regardless of Terraform state.
- `aws_bedrock_foundation_model_agreement` — destroying the Terraform
  resource does not revoke a signed EULA. Treat it as a one-time account
  bootstrap step.

## IAM eventual consistency

IAM is eventually consistent: a role and policy can exist in the API
response but not yet be usable by another service. The
[`batch-inference-pipeline`](../use-cases/batch-inference-pipeline) example
adds a short `time_sleep` between creating the IAM role/policy and creating
the `aws_bedrock_model_invocation_job`, to avoid a race where job creation
fails because the policy hasn't propagated yet.

## Model IDs are left as variables

Specific foundation model IDs (e.g. Anthropic or Amazon model identifiers)
are exposed as variables with a placeholder default rather than hardcoded,
because exact IDs and regional availability change over time. Confirm the
current model ID for your account/region via the Bedrock console or the
`aws_bedrock_foundation_models` data source before applying.

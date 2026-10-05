# Automated model evaluation

**Resource:** [`aws_bedrock_evaluation_job`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrock_evaluation_job)

## Scenario

An ML platform team needs to automatically benchmark a candidate model on
built-in accuracy/robustness metrics before promoting it to production,
rather than relying on ad hoc manual spot-checks.

This example demonstrates an **automated** evaluation job (built-in Bedrock
dataset and metrics), which keeps the example self-contained and runnable by
Terraform alone. **Human-based evaluation** (`application_type` variants
that require a human work team / workflow) is out of scope for this
pure-Terraform showcase -- it requires setting up a SageMaker Ground
Truth-style human workflow outside what this resource configures, and is
noted here as a documented limitation rather than attempted.

## What this creates

- An S3 bucket for evaluation output, encrypted with a dedicated KMS key and
  blocked from public access.
- A KMS key + alias, used for `customer_encryption_key_id` -- this is the
  one example in the repo that demonstrates that optional argument.
- An IAM role trusted by `bedrock.amazonaws.com`, scoped with
  `aws:SourceAccount`/`aws:SourceArn` conditions, with permissions to write
  results to the output bucket and use the KMS key.
- `aws_bedrock_evaluation_job` running an automated robustness evaluation
  (`Builtin.Bold` dataset, `Builtin.Robustness` metric) against `var.model_id`.

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform apply
```

## Caveats

- **Bedrock does not support permanently deleting an evaluation job.**
  `skip_destroy` defaults to `true` in this example so that `terraform
  destroy` stops tracking the job instead of failing to delete something
  AWS won't let it delete. The job itself keeps existing in your account
  after `terraform destroy`.
- Swap in a second `model_id` and a second `bedrock_model` block under
  `inference_config` if you want to compare two candidate models in one job,
  rather than benchmarking a single model in isolation.

# Provisioned throughput

**Resource:** [`aws_bedrock_provisioned_model_throughput`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrock_provisioned_model_throughput)

> ⚠️ **Cost warning.** Provisioned throughput bills per model unit for as
> long as it exists. Committed throughput (`commitment_duration` set)
> additionally **cannot be cancelled early** -- you are billed for the full
> term even if you run `terraform destroy` the next day. Read this whole
> README before applying.

## Scenario

A production application with predictable, high-volume traffic needs
guaranteed low-latency throughput instead of on-demand rate limits. This
resource is demonstrated two ways:

1. **No-commitment throughput for a custom model** (the default in this
   example, safe to apply and destroy) -- the only case where
   `commitment_duration` can be omitted.
2. **Committed, discounted throughput for a base model** (commented out by
   default in `terraform.tfvars.example`) -- cheaper per-unit, but billed
   for the full term and non-cancellable.

## What this creates

- A single `aws_bedrock_provisioned_model_throughput` resource, with
  `model_units` defaulting to `1` and `commitment_duration` defaulting to
  unset (no-commitment path).

No IAM role or S3 bucket is required for the resource itself. Wiring the
provisioned model ARN into an application's `bedrock:InvokeModel` policy is
documentation-only here (see the `provisioned_model_arn` output).

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
# set model_arn to your own custom model ARN
terraform init
terraform apply
```

To try the committed path instead, deliberately uncomment the alternate
block in `terraform.tfvars` -- **do not do this against a real account
unless you intend to pay for the full commitment term.**

## Caveats

- No-commitment provisioned throughput is **only valid for custom
  (fine-tuned/distilled) models**, not base foundation models.
- `terraform destroy` on committed throughput does not stop billing for the
  remaining commitment term -- AWS bills regardless of resource deletion.

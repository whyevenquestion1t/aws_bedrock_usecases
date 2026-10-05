# AWS Bedrock use cases

Runnable Terraform examples showcasing real-world AWS Bedrock capabilities,
one scenario per directory. Each example is a standalone root module: copy
the directory, fill in variables, and `terraform apply`.

## Prerequisites

- Terraform `>= 1.5.0`
- AWS provider (`hashicorp/aws`) `>= 6.53.0`
- An AWS account with permissions to create Bedrock, IAM, S3, and KMS
  resources
- For examples that invoke a model (batch inference, provisioned throughput,
  evaluation): Bedrock model access already granted for that model in your
  account/region. See [`docs/architecture-notes.md`](docs/architecture-notes.md)
  for the prerequisite chain.

## Repo layout

```
use-cases/<scenario-name>/   # one standalone Terraform root module per scenario
docs/                        # shared conventions and cross-cutting notes
.github/workflows/           # CI: fmt + validate only, no apply (see below)
```

There is no shared Terraform module between examples — each is
self-contained and meant to be copied as a whole directory. See
[`docs/conventions.md`](docs/conventions.md) for the naming/tagging
conventions they share by convention, not by code.

## Use cases

| Use case | Core resource | Prerequisite? | Scenario |
|---|---|---|---|
| [`model-access-agreement`](use-cases/model-access-agreement) | `aws_bedrock_foundation_model_agreement` | Yes — account bootstrap | Accept a foundation model's EULA/offer for an account |
| [`enterprise-model-access-request`](use-cases/enterprise-model-access-request) | `aws_bedrock_use_case_for_model_access` | Yes — account bootstrap | Submit the "intended use case" questionnaire some model providers require |
| [`custom-guardrail-for-chatbot`](use-cases/custom-guardrail-for-chatbot) | `aws_bedrock_guardrail` | No — start here | Composite safety guardrail for a support chatbot (denied topics, PII redaction, content filters, grounding) |
| [`batch-inference-pipeline`](use-cases/batch-inference-pipeline) | `aws_bedrock_model_invocation_job` | No | Asynchronously batch-summarize documents from S3 to S3 |
| [`provisioned-throughput`](use-cases/provisioned-throughput) | `aws_bedrock_provisioned_model_throughput` | No | Reserve dedicated model throughput for predictable, high-volume traffic |
| [`automated-model-evaluation`](use-cases/automated-model-evaluation) | `aws_bedrock_evaluation_job` | No | Automatically benchmark a model on built-in metrics before promotion |

> ⚠️ **Cost and safety notes before you apply anything:**
> - `provisioned-throughput`'s committed path bills for the full commitment
>   term and **cannot be cancelled early**. Its default configuration uses
>   the no-commitment path instead — read that example's README before
>   changing it.
> - `automated-model-evaluation`'s evaluation job and
>   `enterprise-model-access-request`'s submission **cannot be permanently
>   deleted** by `terraform destroy` — see
>   [`docs/architecture-notes.md`](docs/architecture-notes.md) for the full
>   list of resources with this behavior.

## CI

`.github/workflows/validate.yml` runs `terraform fmt -check`, `terraform
init -backend=false`, and `terraform validate` across every use case on
every push/PR. It intentionally never runs `plan` or `apply` — these
examples create real, sometimes billable or non-deletable AWS resources, so
applying against a real account is left to you. See
[`CONTRIBUTING.md`](CONTRIBUTING.md) before adding a new use case.

## License

[MIT](LICENSE)

# Custom guardrail for a support chatbot

**Resource:** [`aws_bedrock_guardrail`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrock_guardrail) (+ `aws_bedrock_guardrail_version`)
**Start here:** this is the cheapest, fastest example in the repo to apply
and destroy cleanly -- a good first run to validate your Terraform/provider
setup.

## Scenario

A customer-support chatbot team needs a realistic, composite set of
guardrails, not a single-policy toy example:

- Refuse to discuss or compare competitor products (denied topic).
- Redact PII -- emails, SSNs, phone numbers -- in both input and output
  (sensitive information policy).
- Block a custom word list on top of AWS's managed profanity list (word
  policy).
- Filter hate/violence/sexual/insult content (content policy).
- Keep answers grounded in retrieved context instead of hallucinating
  (contextual grounding policy).

## What this creates

- `aws_bedrock_guardrail` with all five policy types configured.
- `aws_bedrock_guardrail_version` -- published immediately so the guardrail
  is actually invocable. Applications reference `guardrail_identifier` +
  this numeric version (not the mutable draft) via the `bedrock:ApplyGuardrail`
  permission when calling `InvokeModel`/`Converse`.

No IAM role or S3 bucket is required for the guardrail definition itself.

## Using the guardrail from an application

This example only creates the guardrail; wiring it into a live chatbot is
out of scope for this repo, but a consuming application's IAM role needs a
policy like:

```json
{
  "Effect": "Allow",
  "Action": "bedrock:ApplyGuardrail",
  "Resource": "<guardrail_arn output from this example>"
}
```

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform apply
```

## Caveats

- Guardrails are versioned and immutable once published; changing policy
  content in `main.tf` and re-applying publishes a **new** version via a new
  `aws_bedrock_guardrail_version` resource rather than mutating the one
  already in use by an application.

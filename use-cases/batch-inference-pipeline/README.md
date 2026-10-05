# Batch inference pipeline

**Resource:** [`aws_bedrock_model_invocation_job`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrock_invocation_job)
*(the AWS provider's actual resource name is `aws_bedrock_model_invocation_job`)*

## Scenario

A legal/document-processing team has a large set of contracts in S3 and
needs to run a one-time (or scheduled) batch summarization job across all of
them asynchronously, writing results back to S3. This is the realistic
"batch inference" use case -- processing a large, bounded set of documents
overnight -- as opposed to real-time chat via `InvokeModel`/`Converse`.

## What this creates

- Two S3 buckets (input, output), both encrypted and with public access
  blocked.
- A sample fixture, `sample-data/prompts.jsonl`, containing 100 synthetic
  contract-summarization prompts in the record shape Bedrock batch
  inference expects (`{"recordId": ..., "modelInput": {...}}`), uploaded to
  the input bucket. **100 records is sized to meet Bedrock's documented
  minimum per batch job** -- confirm the current minimum/maximum record
  count in AWS's Bedrock batch inference docs, as it has changed before.
- An IAM role trusted by `bedrock.amazonaws.com` (scoped with
  `aws:SourceAccount` / `aws:SourceArn` conditions), with a least-privilege
  policy: read-only on the input bucket, write-only on the output bucket.
- A `time_sleep` buffer between creating the IAM role/policy and creating
  the job, working around IAM eventual consistency -- without it, job
  creation can occasionally race policy propagation and fail.
- The `aws_bedrock_model_invocation_job` itself.

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform apply
```

`terraform apply` may take a while to return -- check current provider
behavior for whether it blocks until the job reaches a terminal state, since
that affects how long you should expect to wait.

## Caveats

- **Cost and runtime:** batch inference is billed per token processed, same
  as on-demand inference, but 100 real summarization calls will still incur
  real (small) cost. Review pricing for `var.model_id` before applying.
- **`skip_destroy`:** defaults to `false`. Set it to `true` if you want
  `terraform destroy` to stop tracking the job (leaving it running or
  completed) rather than attempting to stop/delete it -- useful for
  long-running or already-completed jobs you still need output from.
- Results land in `s3://<output_bucket>/output/` once the job completes;
  check job status via the `status` output or the Bedrock console.

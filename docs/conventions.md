# Conventions

Every example in `use-cases/` is a standalone root module. There is no shared
Terraform module in this repo, so the conventions below are enforced by
review and copy-paste discipline rather than by code. Follow them when adding
a new use case.

## Version pinning

Every `versions.tf` pins the same floor:

```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.53.0"
    }
  }
}
```

`6.53.0` is the floor because `aws_bedrock_foundation_model_agreement` and
`aws_bedrock_use_case_for_model_access` were both added in that release.
Pinning every example to it keeps one version number true across the repo,
even for examples that don't use those two resources.

## Variables every example exposes

- `name_prefix` (string) — prefix applied to named resources (S3 buckets,
  IAM roles) to avoid collisions between deployments.
- `region` (string) — passed to the `aws` provider block.
- `tags` (map(string), default `{}`) — merged into a `local.tags` map along
  with fixed values and passed to the provider's `default_tags`.

## Tagging

```hcl
locals {
  tags = merge(var.tags, {
    Project   = "aws-bedrock-usecases"
    UseCase   = "<use-case-directory-name>"
    ManagedBy = "terraform"
  })
}

provider "aws" {
  region = var.region

  default_tags {
    tags = local.tags
  }
}
```

## S3 bucket naming

S3 bucket names are globally unique, so every bucket name incorporates the
account ID:

```hcl
data "aws_caller_identity" "current" {}

locals {
  bucket_name = "${var.name_prefix}-<purpose>-${data.aws_caller_identity.current.account_id}"
}
```

## tfvars

Each example ships a `terraform.tfvars.example` with placeholder values.
`.tfvars` itself is gitignored — copy the example file locally and fill in
real values; never commit it.

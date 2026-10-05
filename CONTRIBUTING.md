# Contributing

## Adding a new use case

1. Copy an existing directory under `use-cases/` that's structurally closest
   to what you're adding (e.g. `custom-guardrail-for-chatbot` for a
   no-supporting-infra example, `batch-inference-pipeline` for one that
   needs IAM/S3/KMS) and use it as a template.
2. Keep the standard file set: `README.md`, `versions.tf`, `main.tf`,
   `variables.tf`, `outputs.tf`, `terraform.tfvars.example`, plus
   `iam.tf` / `s3.tf` / `kms.tf` only if there's enough supporting
   infrastructure to warrant splitting it out of `main.tf`.
3. Follow [`docs/conventions.md`](docs/conventions.md) for variable naming,
   tagging, version pinning, and S3 bucket naming.
4. Pin the same `terraform >= 1.5.0` / `aws >= 6.53.0` floor used everywhere
   else, unless your example needs a newer provider feature — if so, bump
   the floor repo-wide and note why in your PR.
5. Write a README that explains the realistic scenario the example
   demonstrates, any prerequisites (e.g. model access already granted),
   cost/safety notes, and `destroy` caveats if the resource doesn't clean up
   fully (see [`docs/architecture-notes.md`](docs/architecture-notes.md) for
   the known list).
6. Add your directory name to the matrix in
   `.github/workflows/validate.yml` and to the table in the root
   [`README.md`](README.md).

## Before opening a PR

- Run `terraform fmt -recursive` in your use-case directory.
- Run `terraform init -backend=false && terraform validate` in your use-case
  directory.
- CI only runs `fmt`, `init`, and `validate` — it never runs `plan` or
  `apply`, since these examples create real (sometimes billable or
  non-deletable) AWS resources. Verify your example actually applies
  cleanly against a real AWS account yourself before submitting; mention in
  the PR description that you did.

## Style

- No shared Terraform module — each use case is self-contained and meant to
  be copied as a whole directory. Don't introduce `source =
  "../../modules/..."` references between examples.
- Prefer variables with safe defaults over hardcoded values that would
  surprise someone running `terraform apply` for the first time (e.g.
  `model_units = 1`, `skip_destroy` defaulting to whichever value avoids a
  destroy-time error for that resource).

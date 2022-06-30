# Terraform module: CDO instrumentation events
This Terraform module is created for enabling Cloud Build&Cloud Deploy events pushing to CDO instrumentation project for further processing and creating DORA metrics.
## Inputs:

| Key        | Description    | Values   | Default |
|------------|----------------|----------|---------|
| project_id | GCP project ID | (string) |         |

## Outputs

| Key | Description | Values |
|-----|-------------|--------|
|     |             |        |

## Usage
To use this TF module refer to template below.
```hcl
module "instrumentation-events" {
  source     = "git::ssh://git@github.com/telus/tf-module-cdo-instrumentation-events?ref=v0.1.0"
  project_id = var.project_id
}
```
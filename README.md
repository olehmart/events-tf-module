# Terraform module: CDO instrumentation events
This Terraform module is created for enabling Cloud Build&Cloud Deploy events pushing to CDO instrumentation project for further processing and creating DORA metrics.

### List of resources which will be created by this module:
* Pub/Sub topics:
  * ```cloud-deploy-resources```
  * ```cloud-deploy-operations```
  * ```cloud-deploy-approvals```
  * ```cloud-builds```
* Pub/Sub subscriptions:
  * ```cdo-instrumentation-cloud-deploy-resources-push```
  * ```cdo-instrumentation-cloud-deploy-operations-push```
  * ```cdo-instrumentation-cloud-deploy-approvals-push```
  * ```cdo-instrumentation-cloud-builds-push```
* IAM permissions:
  * Cloud Deploy Viewer role will be assigned to CDO instrumentation IAM service account

## Inputs:

| Key        | Required | Description    | Values   | Default |
|------------|----------|----------------|----------|---------|
| project_id | True     | GCP project ID | (string) |         |

## Outputs

| Key                                      | Value type | Description                                                                            | Example of values                                                                                |
|------------------------------------------|------------|----------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------|
| cloud_build_topics                       | List       | List of Cloud Build topics                                                             | ```["projects/<ProjectID>/topics/topic1", "projects/<ProjectID>/topics/topic2"]```               |
| cloud_deploy_topics                      | List       | List of Cloud Deploy topics                                                            | ```["projects/<ProjectID>/topics/topic1", "projects/<ProjectID>/topics/topic2"]```               |
| cloud_build_subscriptions                | Map        | Map of Cloud Build subscriptions                                                       | ```{"projects/<ProjectID>/topics/topic1": "projects/<ProjectID>/subscriptions/subscription1"}``` |
| cloud_deploy_subscriptions               | Map        | Map of Cloud Deploy subscriptions                                                      | ```{"projects/<ProjectID>/topics/topic1": "projects/<ProjectID>/subscriptions/subscription1"}``` |
| webhook_receiver_url                     | String     | Instrumentation webhook_receiver URL                                                   | ```https://webhook_receiver_url ```                                                              |
| webhook_cloud_deploy_path                | String     | Path for Cloud Deploy events                                                           | ```cloud_deploy_events ```                                                                       |
| webhook_cloud_build_path                 | String     | Path for Cloud Build events                                                            | ```cloud_build_events ```                                                                        |
| instrumentation_sa_email                 | String     | Instrumentation IAM service account email for gathering Cloud Deploy information       | ```service-account-name@<ProjectID>.iam.gserviceaccount.com ```                                  |

## Usage
To use this TF module refer to template below.

**SSH:**
```hcl
module "instrumentation-events" {
  source     = "git::ssh://git@github.com/olehmart/events-tf-module?ref=v0.1.0"
  project_id = var.project_id
}
```

**HTTPS:**
```hcl
module "instrumentation-events" {
  source     = "git::https://github.com/olehmart/events-tf-module.git?ref=v0.1.0"
  project_id = var.project_id
}
```

**Note: make sure that the latest version of this module is used.**
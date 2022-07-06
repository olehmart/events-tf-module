# Terraform > Module
# https://www.terraform.io/docs/modules/index.html

locals {
  webhook_receiver_url = "https://us-central2-quiet-subset-354615.cloudfunctions.net"
  cloud_deploy_events_path = "webhook_receiver"
  cloud_build_events_path = "webhook_receiver"
  instrumentation_sa_email = "cloud-deploy-enricher@quiet-subset-354615.iam.gserviceaccount.com"
  cloud_deploy_topics = ["cloud-deploy-resources", "cloud-deploy-operations", "cloud-deploy-approvals"]
  cloud_build_topics = ["cloud-builds"]
}

# Terraform > Module > google_pubsub_topic
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic
resource "google_pubsub_topic" "cloud-deploy" {
  for_each = toset(local.cloud_deploy_topics)
  project  = var.project_id
  name     = each.key
}

# Terraform > Module > google_pubsub_topic
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic
resource "google_pubsub_topic" "cloud-build" {
  for_each = toset(local.cloud_build_topics)
  project  = var.project_id
  name     = each.key
}
# Terraform > Module > google_pubsub_subscription
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription
resource "google_pubsub_subscription" "cloud-deploy-sub" {
  for_each = toset(local.cloud_deploy_topics)
  project  = var.project_id
  name     = "cdo-instrumentation-${each.key}-push"
  topic    = google_pubsub_topic.cloud-deploy[each.key].name

  push_config {
    push_endpoint = "${local.webhook_receiver_url}/${local.cloud_deploy_events_path}"
  }
}

# Terraform > Module > google_pubsub_subscription
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription
resource "google_pubsub_subscription" "cloud-build-sub" {
  for_each = toset(local.cloud_build_topics)
  project  = var.project_id
  name     = "cdo-instrumentation-${each.key}-push"
  topic    = google_pubsub_topic.cloud-build[each.key].name

  push_config {
    push_endpoint = "${local.webhook_receiver_url}/${local.cloud_build_events_path}"
  }
}

# Terraform > Module > google_project_iam_member
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam
resource "google_project_iam_member" "instrumentation-sa-cloud-deploy-viewer" {
  project = var.project_id
  role    = "roles/clouddeploy.viewer"
  member  = "serviceAccount:${local.instrumentation_sa_email}"
}

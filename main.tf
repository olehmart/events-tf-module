# Terraform > Module
# https://www.terraform.io/docs/modules/index.html

locals {
  webhook_receiver_url = "https://us-central1-quiet-subset-354615.cloudfunctions.net"
  cloud_deploy_events_path = "webhook_receiver"
  cloud_build_events_path = "webhook_receiver"
  instrumentation_sa_email = "cloud-deploy-enricher@quiet-subset-354615.iam.gserviceaccount.com"
  cloud_deploy_topics = ["cloud-deploy-resources", "cloud-deploy-operations", "cloud-deploy-approvals"]
  cloud_build_topics = ["cloud-builds"]
}

#resource "google_pubsub_topic" "cloud-deploy-resources" {
#  project = var.project_id
#  name    = "cloud-deploy-resources"
#}
#
#resource "google_pubsub_topic" "cloud-deploy-operations" {
#  project = var.project_id
#  name    = "cloud-deploy-operations"
#}
#
#resource "google_pubsub_topic" "cloud-deploy-approvals" {
#  project = var.project_id
#  name    = "cloud-deploy-approvals"
#}
#
#resource "google_pubsub_topic" "cloud-builds" {
#  project = var.project_id
#  name    = "cloud-builds"
#}
#
#resource "google_pubsub_subscription" "cloud-deploy-resources-sub" {
#  project = var.project_id
#  name    = "cdo-instrumentation-push"
#  topic   = google_pubsub_topic.cloud-deploy-resources.name
#
#  push_config {
#    push_endpoint = "${local.webhook_receiver_url}/${local.cloud_deploy_events_path}"
#  }
#}
#
#resource "google_pubsub_subscription" "cloud-deploy-operations-sub" {
#  project = var.project_id
#  name    = "cdo-instrumentation-push"
#  topic   = google_pubsub_topic.cloud-deploy-operations.name
#
#  push_config {
#    push_endpoint = "${local.webhook_receiver_url}/${local.cloud_deploy_events_path}"
#  }
#}
#
#resource "google_pubsub_subscription" "cloud-deploy-approvals-sub" {
#  project = var.project_id
#  name    = "cdo-instrumentation-push"
#  topic   = google_pubsub_topic.cloud-deploy-approvals.name
#
#  push_config {
#    push_endpoint = "${local.webhook_receiver_url}/${local.cloud_deploy_events_path}"
#  }
#}
#
#resource "google_pubsub_subscription" "cloud-builds-sub" {
#  project = var.project_id
#  name    = "cdo-instrumentation-push"
#  topic   = google_pubsub_topic.cloud-builds.name
#
#  push_config {
#    push_endpoint = "${local.webhook_receiver_url}/${local.cloud_build_events_path}"
#  }
#}

resource "google_pubsub_topic" "cloud-deploy" {
  for_each = local.cloud_deploy_topics
  project  = var.project_id
  name     = each.key
}

resource "google_pubsub_topic" "cloud-builds" {
  for_each = local.cloud_build_topics
  project  = var.project_id
  name     = each.key
}

resource "google_pubsub_subscription" "cloud-deploy-sub" {
  for_each = local.cloud_deploy_topics
  project  = var.project_id
  name     = "cdo-instrumentation-push"
  topic    = google_pubsub_topic.cloud-deploy[each.key].name

  push_config {
    push_endpoint = "${local.webhook_receiver_url}/${local.cloud_deploy_events_path}"
  }
}

resource "google_pubsub_subscription" "cloud-builds-sub" {
  for_each = local.cloud_build_topics
  project  = var.project_id
  name     = "cdo-instrumentation-push"
  topic    = google_pubsub_topic.cloud-builds[each.key].name

  push_config {
    push_endpoint = "${local.webhook_receiver_url}/${local.cloud_build_events_path}"
  }
}

resource "google_project_iam_member" "instrumentation-sa-cloud-deploy-viewer" {
  project = var.project_id
  role    = "roles/clouddeploy.viewer"
  member  = "serviceAccount:${local.instrumentation_sa_email}"
}

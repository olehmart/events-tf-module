output "cloud_build_topics" {
  value = [for topic in google_pubsub_topic.cloud-builds: topic.id]
  # value = google_pubsub_topic.cloud-builds.id
}

output "cloud_deploy_topics" {
  value = [for topic in google_pubsub_topic.cloud-deploy: topic.id]
  # value = google_pubsub_topic.cloud-deploy.id
}

output "cloud_build_subscriptions" {
  value = {for subscription in google_pubsub_subscription.cloud-builds-sub: subscription.topic => subscription.id}
  # value = google_pubsub_subscription.cloud-builds-sub.id
}

output "cloud_deploy_subscriptions" {
  value = [for subscription in google_pubsub_subscription.cloud-deploy-sub: subscription.id]
  # value = google_pubsub_subscription.cloud-deploy-sub.id
}

output "webhook_receiver_url" {
  value = local.webhook_receiver_url
}

output "webhook_cloud_deploy_path" {
  value = local.cloud_deploy_events_path
}

output "webhook_cloud_build_path" {
  value = local.cloud_build_events_path
}

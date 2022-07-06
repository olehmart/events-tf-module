# List of Cloud Build topics
# Type: list
# Format: ["topic1", "topic2"]
output "cloud_build_topics" {
  value = [for topic in google_pubsub_topic.cloud-builds: topic.id]
}

#List of Cloud Deploy topics
# Type: list
# Format:
# [
#  <topic_ID>,
#  <topic_ID>
# ]
output "cloud_deploy_topics" {
  value = [for topic in google_pubsub_topic.cloud-deploy: topic.id]
}

# Map of Cloud Build subscriptions
# Type: map
# Format:
# {
#   "<topic_ID>: <subscription_ID>",
#   "<topic_ID>: <subscription_ID>"
# }
output "cloud_build_subscriptions" {
  value = {for subscription in google_pubsub_subscription.cloud-builds-sub: subscription.topic => subscription.id}
}

# Map of Cloud Deploy subscriptions
# Type: map
# Format:
# {
#   "<topic_ID>: <subscription_ID>",
#   "<topic_ID>: <subscription_ID>"
# }
output "cloud_deploy_subscriptions" {
  value = {for subscription in google_pubsub_subscription.cloud-deploy-sub: subscription.topic => subscription.id}
}

# Instrumentation webhook_receiver URL
# Type: string
output "webhook_receiver_url" {
  value = local.webhook_receiver_url
}

# Path for Cloud Deploy events
# Type: string
output "webhook_cloud_deploy_path" {
  value = local.cloud_deploy_events_path
}

# Path for Cloud Build events
# Type: string
output "webhook_cloud_build_path" {
  value = local.cloud_build_events_path
}

# Instrumentation IAM service account email for gathering Cloud Deploy information
# Type: string
output "instrumentation_sa_email" {
  value = local.instrumentation_sa_email
}

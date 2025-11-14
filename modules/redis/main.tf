resource "google_project_service" "redis_api" {
  service            = "redis.googleapis.com"
  disable_on_destroy = false
}


resource "google_redis_instance" "redis" {
  depends_on = [google_project_service.redis_api]
  
  name           = var.redis_name
  tier           = var.tier
  memory_size_gb = var.memory_size_gb
  region         = var.region

  redis_version     = var.redis_version
  display_name      = var.display_name
  
  # Connect to the default VPC network
  authorized_network = "projects/${var.project_id}/global/networks/default"
  
  connect_mode = "DIRECT_PEERING"
  
  labels = var.labels
}
resource "google_cloud_run_service" "service" {
  name     = var.app_name
  location = var.region
  
  template {
    spec {
      containers {
        image = var.image_name
        
        dynamic "env" {
          for_each = var.env_vars
          content {
            name  = env.key
            value = env.value
          }
        }
        
        resources {
          limits = var.resource_limits
        }
      }
    }
    
    metadata {
      annotations = merge(
        {
          "autoscaling.knative.dev/maxScale" = tostring(var.max_scale)
        },
        var.vpc_connector_name != "" ? {
          "run.googleapis.com/vpc-access-connector" = var.vpc_connector_name
          "run.googleapis.com/vpc-access-egress"    = var.vpc_egress
        } : {}
      )
    }
  }
  
  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "public_access" {
  count = var.allow_public_access ? 1 : 0
  
  service  = google_cloud_run_service.service.name
  location = google_cloud_run_service.service.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
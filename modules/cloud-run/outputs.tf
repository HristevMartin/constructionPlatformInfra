output "service_url" {
  description = "URL of the deployed Cloud Run service"
  value       = google_cloud_run_service.service.status[0].url
}

output "service_name" {
  description = "Name of the Cloud Run service"
  value       = google_cloud_run_service.service.name
}

output "service_id" {
  description = "ID of the Cloud Run service"
  value       = google_cloud_run_service.service.id
}
output "frontend_simple_service_url" {
  description = "URL of the simple frontend service"
  value       = module.frontend_simple.service_url
}

output "frontend_management_service_url" {
  description = "URL of the management frontend service"
  value       = module.frontend_management.service_url
}

output "backend_service_url" {
  description = "URL of the backend service"
  value       = module.backend.service_url
}

output "mongodb_internal_ip" {
  description = "Internal IP of MongoDB instance"
  value       = module.mongodb.internal_ip
}

output "network_name" {
  description = "Name of the VPC network"
  value       = module.networking.network_name
}
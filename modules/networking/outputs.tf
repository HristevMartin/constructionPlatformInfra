output "network_name" {
  description = "Name of the shared VPC network"
  value       = google_compute_network.vpc_network.name
}

output "network_id" {
  description = "ID of the shared VPC network"
  value       = google_compute_network.vpc_network.id
}

output "main_subnet_name" {
  description = "Name of the main subnet"
  value       = google_compute_subnetwork.main_subnet.name
}

output "mongo_subnet_name" {
  description = "Name of the MongoDB subnet"
  value       = var.enable_mongo_subnet ? google_compute_subnetwork.mongo_subnet[0].name : ""
}

output "frontend_simple_connector_name" {
  description = "Name of the simple frontend VPC connector"
  value       = google_vpc_access_connector.frontend_simple_connector.name
}

output "frontend_portfolio_connector_name" {
  description = "Name of the frontend portfolio VPC connector"
  value       = google_vpc_access_connector.frontend_portfolio_connector.name
}

output "backend_connector_name" {
  description = "Name of the backend VPC connector"
  value       = google_vpc_access_connector.backend_connector.name
}
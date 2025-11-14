output "frontend_simple_service_url" {
  description = "URL of the simple frontend service"
  value       = module.frontend_simple.service_url
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



output "redis_host" {
  description = "Redis instance host IP"
  value       = module.redis.host
}

output "redis_port" {
  description = "Redis instance port"
  value       = module.redis.port
}

output "redis_connection_string" {
  description = "Redis connection string"
  value       = module.redis.connection_string
  sensitive   = true
}
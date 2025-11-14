output "host" {
  description = "Redis instance host IP"
  value       = google_redis_instance.redis.host
}

output "port" {
  description = "Redis instance port"
  value       = google_redis_instance.redis.port
}

output "connection_string" {
  description = "Full Redis connection string"
  value       = "redis://${google_redis_instance.redis.host}:${google_redis_instance.redis.port}/0"
  sensitive   = true
}

output "id" {
  description = "Redis instance ID"
  value       = google_redis_instance.redis.id
}

output "current_location_id" {
  description = "The current zone where the Redis endpoint is placed"
  value       = google_redis_instance.redis.current_location_id
}
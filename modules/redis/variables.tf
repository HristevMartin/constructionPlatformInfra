# modules/redis/variables.tf

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region for Redis instance"
  type        = string
}

variable "redis_name" {
  description = "Name of the Redis instance"
  type        = string
  default     = "jobhub-redis"
}

variable "tier" {
  description = "Redis tier: BASIC or STANDARD_HA"
  type        = string
  default     = "BASIC"
}

variable "memory_size_gb" {
  description = "Redis memory size in GB"
  type        = number
  default     = 1
}

variable "redis_version" {
  description = "Redis version"
  type        = string
  default     = "REDIS_7_0"
}

variable "display_name" {
  description = "Display name for the Redis instance"
  type        = string
  default     = "JobHub Redis"
}

variable "labels" {
  description = "Labels to apply to the Redis instance"
  type        = map(string)
  default     = {}
}
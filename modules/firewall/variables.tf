variable "app_name" {
  description = "Name of the application"
  type        = string
}

variable "network_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "enable_mongodb_rules" {
  description = "Whether to create MongoDB firewall rules"
  type        = bool
  default     = false
}

variable "mongodb_source_ranges" {
  description = "Source IP ranges for MongoDB access"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "internal_source_ranges" {
  description = "Source IP ranges for internal traffic"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}
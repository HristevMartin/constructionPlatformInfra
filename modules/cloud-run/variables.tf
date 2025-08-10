variable "project_id" {
  description = "The Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "The Google Cloud region"
  type        = string
}

variable "app_name" {
  description = "Name of the Cloud Run service"
  type        = string
}

variable "image_name" {
  description = "Container image to deploy"
  type        = string
}

variable "env_vars" {
  description = "Environment variables for the container"
  type        = map(string)
  default     = {}
}

variable "resource_limits" {
  description = "Resource limits for the container"
  type        = map(string)
  default = {
    cpu    = "1000m"
    memory = "512Mi"
  }
}

variable "max_scale" {
  description = "Maximum number of container instances"
  type        = number
  default     = 5
}

variable "vpc_connector_name" {
  description = "Name of the VPC connector (optional)"
  type        = string
  default     = ""
}

variable "vpc_egress" {
  description = "VPC egress setting"
  type        = string
  default     = "all-traffic"
}

variable "allow_public_access" {
  description = "Whether to allow public access to the service"
  type        = bool
  default     = true
}
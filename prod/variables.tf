variable "project_id" {
  description = "The Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "The main Google Cloud region"
  type        = string
  default     = "us-central1"
}

variable "mongo_region" {
  description = "The Google Cloud region for MongoDB"
  type        = string
  default     = "europe-west1"
}

variable "frontend_simple_image_name" {
  description = "Container image for the simple frontend service"
  type        = string
}

variable "frontend_management_image_name" {
  description = "Container image for the management frontend service"
  type        = string
  default     = "gcr.io/stalwart-elixir-458022-d5/managementui2:latest"
}

variable "backend_image_name" {
  description = "Container image for the backend service"
  type        = string
  default     = "gcr.io/stalwart-elixir-458022-d5/demo-construction-backend:latest"
}

variable "secret_key" {
  description = "Secret key for Flask application"
  type        = string
  sensitive   = true
}
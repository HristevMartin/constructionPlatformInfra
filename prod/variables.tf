variable "project_id" {
  description = "The Google Cloud project ID"
  type        = string
  default     = "project-951fdfad-a8e3-4d4b-a1c"
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
  default     = "gcr.io/pure-zoo-466316-t4/frontend-simple:latest"
}

variable "frontend_management_image_name" {
  description = "Container image for the management frontend service"
  type        = string
  default     = "gcr.io/pure-zoo-466316-t4/managementui2:v1.0.1"
                
}

variable "backend_image_name" {
  description = "Container image for the backend service"
  type        = string
  default     = "gcr.io/pure-zoo-466316-t4/demo-construction-backend:latest"
}

variable "secret_key" {
  description = "Secret key for Flask application"
  type        = string
  sensitive   = true
  default     = ""
}

variable "sendgrid_api_key" {
  description = "SendGrid API key"
  type        = string
  sensitive   = true
  default     = ""
}

variable "stripe_secret_key" {
  description = "Stripe secret key"
  type        = string
  sensitive   = true
  default     = ""
}

variable "OPENAI_API_KEY" {
  description = "OpenAI API key"
  type        = string
  sensitive   = true
  default     = ""
}

variable "google_client_id" {
  description = "Google Client ID"
  type        = string
  sensitive   = true
  default     = ""
}

variable "frontend_portfolio" {
  description = "Container image for the frontend portfolio service"
  type        = string
  default     = "europe-west1-docker.pkg.dev/regal-framework-475315-m1/docker-repo/martin_portfolio:v1"
}

variable "environment" {
  description = "Environment name (production, staging, etc.)"
  type        = string
  default     = "production"
}

variable "backend_portfolio" {
  description = "Container image for the backend portfolio service"
  type        = string
  default     = "europe-west1-docker.pkg.dev/regal-framework-475315-m1/docker-repo/cv-chatbot-api:v1.0.0"
}

variable "TYPESENSE_API_KEY" {
  description = "Typesense API key"
  type        = string
  sensitive   = true
  default     = ""
}


variable "front_end_base_cv_llm_url" {
  description = "Base URL for the frontend CV LLM"
  type        = string
  default     = ""
}
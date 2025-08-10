variable "project_id" {
  description = "The Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "The main Google Cloud region"
  type        = string
}

variable "mongo_region" {
  description = "The Google Cloud region for MongoDB subnet"
  type        = string
  default     = ""
}

variable "app_name" {
  description = "Name of the application (used for resource naming)"
  type        = string
}

variable "main_subnet_cidr" {
  description = "CIDR range for the main subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "mongo_subnet_cidr" {
  description = "CIDR range for the MongoDB subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "connector_cidr" {
  description = "CIDR range for the VPC connector"
  type        = string
  default     = "10.8.0.0/28"
}

variable "enable_mongo_subnet" {
  description = "Whether to create MongoDB subnet and NAT"
  type        = bool
  default     = false
}
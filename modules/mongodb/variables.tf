variable "project_id" {
  description = "The Google Cloud project ID"
  type        = string
}

variable "app_name" {
  description = "Name of the application"
  type        = string
}

variable "mongo_region" {
  description = "The Google Cloud region for MongoDB"
  type        = string
}

variable "zone_suffix" {
  description = "Zone suffix (a, b, c)"
  type        = string
  default     = "b"
}

variable "machine_type" {
  description = "Machine type for MongoDB VM"
  type        = string
  default     = "e2-micro"
}

variable "boot_image" {
  description = "Boot disk image"
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2204-lts"
}

variable "disk_size" {
  description = "Boot disk size in GB"
  type        = number
  default     = 10
}

variable "disk_type" {
  description = "Boot disk type"
  type        = string
  default     = "pd-standard"
}

variable "network_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "startup_script" {
  description = "Startup script for MongoDB installation"
  type        = string
  default     = <<-EOF
    #!/bin/bash
    apt-get update
    
    # Install MongoDB
    wget -qO - https://www.mongodb.org/static/pgp/server-7.0.asc | sudo apt-key add -
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
    apt-get update
    apt-get install -y mongodb-org
    
    # Configure MongoDB for network access
    sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf
    
    # Enable and start MongoDB
    systemctl enable mongod
    systemctl start mongod
  EOF
}
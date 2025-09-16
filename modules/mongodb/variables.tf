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
    set -e  # Exit on any error
    
    # Log all output for debugging
    exec > >(tee -a /var/log/mongodb-install.log)
    exec 2>&1
    
    echo "Starting MongoDB installation at $(date)"
    
    # Update package list
    apt-get update -y
    
    # Install required packages
    apt-get install -y wget gnupg software-properties-common
    
    # Add MongoDB GPG key using newer method
    wget -qO - https://www.mongodb.org/static/pgp/server-7.0.asc | gpg --dearmor | sudo tee /usr/share/keyrings/mongodb-server-7.0.gpg > /dev/null
    
    # Add MongoDB repository
    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
    
    # Update package list again
    apt-get update -y
    
    # Install MongoDB
    echo "Installing MongoDB..."
    apt-get install -y mongodb-org
    
    # Create MongoDB data directory with correct permissions
    sudo mkdir -p /var/lib/mongodb
    sudo chown mongodb:mongodb /var/lib/mongodb
    
    # Configure MongoDB for network access
    echo "Configuring MongoDB..."
    sudo cp /etc/mongod.conf /etc/mongod.conf.backup
    sudo sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf
    
    # Enable MongoDB service
    sudo systemctl daemon-reload
    sudo systemctl enable mongod
    
    # Start MongoDB service
    echo "Starting MongoDB service..."
    sudo systemctl start mongod
    
    # Wait a moment and check status
    sleep 5
    sudo systemctl status mongod
    
    # Create symbolic link for mongodb command (if needed)
    if [ ! -f /usr/bin/mongodb ]; then
        sudo ln -s /usr/bin/mongod /usr/bin/mongodb 2>/dev/null || true
    fi
    
    # Test MongoDB connection
    echo "Testing MongoDB connection..."
    mongod --version
    
    echo "MongoDB installation completed at $(date)"
    
    # Set up basic MongoDB admin user (optional)
    # Uncomment the following lines if you want to set up authentication
    # sleep 10  # Wait for MongoDB to be fully ready
    # mongo --eval "
    #   db = db.getSiblingDB('admin');
    #   db.createUser({
    #     user: 'admin',
    #     pwd: 'your-secure-password',
    #     roles: [ { role: 'userAdminAnyDatabase', db: 'admin' } ]
    #   });
    # "
  EOF
}
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
  
  backend "gcs" {
    bucket = "pure-zoo-terraform-state"
    prefix = "prod/terraform.tfstate"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# SHARED NETWORKING INFRASTRUCTURE
module "networking" {
  source = "../modules/networking"
  
  project_id          = var.project_id
  region             = var.region
  mongo_region       = var.mongo_region
  app_name           = "trade-harmony"
  enable_mongo_subnet = true
}

# SHARED FIREWALL RULES
module "firewall" {
  source = "../modules/firewall"
  
  app_name              = "trade-harmony"
  network_name          = module.networking.network_name
  enable_mongodb_rules  = true
  
  depends_on = [module.networking]
}

# SHARED MONGODB INSTANCE
module "mongodb" {
  source = "../modules/mongodb"
  
  project_id   = var.project_id
  app_name     = "trade-harmony"
  mongo_region = var.mongo_region
  network_name = module.networking.network_name
  subnet_name  = module.networking.mongo_subnet_name
  
  depends_on = [module.networking, module.firewall]
}

# FRONTEND SERVICE #1 (Simple - No MongoDB)
module "frontend_simple" {
  source = "../modules/cloud-run"
  
  project_id         = var.project_id
  region            = var.region
  app_name          = "trade-harmony-frontend-simple"
  image_name        = var.frontend_simple_image_name
  vpc_connector_name = module.networking.frontend_simple_connector_name
  
  env_vars = {
    NODE_ENV = "production"
  }
  
  depends_on = [module.networking]
}

# FRONTEND SERVICE #2 (Management - With MongoDB Access)
module "frontend_management" {
  source = "../modules/cloud-run"
  
  project_id         = var.project_id
  region            = var.region
  app_name          = "trade-harmony-frontend-management"
  image_name        = var.frontend_management_image_name
  vpc_connector_name = module.networking.frontend_management_connector_name
  
  env_vars = {
    NODE_ENV = "production"
  }
  
  depends_on = [module.networking]
}

# BACKEND SERVICE (API -s Connects to MongoDB)
module "backend" {
  source = "../modules/cloud-run"
  
  project_id         = var.project_id
  region            = var.region
  app_name          = "ub-travel-services-backend"
  image_name        = var.backend_image_name
  vpc_connector_name = module.networking.backend_connector_name
  
  env_vars = {
    MONGODB_URI = "mongodb://${module.mongodb.internal_ip}:27017/travelDB"
    MONGO_DB    = "travelDB"
    SECRET_KEY  = var.secret_key
    FLASK_ENV   = "production"
  }
  
  depends_on = [module.networking, module.mongodb]
}
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }

  backend "gcs" {
    bucket = "regal-framework-terraform-state"
    prefix = "prod/terraform.tfstate"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Enables Cloud Run API (shareds across alssl Cloud Run services)
resource "google_project_service" "cloud_run_api" {
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

# SHARED NETWORKING INFRASTRUCTURE
module "networking" {
  source = "../modules/networking"

  project_id          = var.project_id
  region              = var.region
  mongo_region        = var.mongo_region
  app_name            = "trade-harmony"
  enable_mongo_subnet = true
}

# SHARED FIREWALL RULES
module "firewall" {
  source = "../modules/firewall"

  app_name             = "trade-harmony"
  network_name         = module.networking.network_name
  enable_mongodb_rules = true

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
  region             = var.region
  app_name           = "trade-harmony-frontend-simple"
  image_name         = var.frontend_simple_image_name
  vpc_connector_name = module.networking.frontend_simple_connector_name

  env_vars = {
    NODE_ENV = "production"
  }

  depends_on = [module.networking]
}


module "frontend_portfolio" {
  source = "../modules/cloud-run"

  project_id         = var.project_id
  region             = var.region
  app_name           = "trade-harmony-frontend-portfolio"
  image_name         = var.frontend_portfolio
  vpc_connector_name = module.networking.frontend_portfolio_connector_name

  env_vars = {
    NODE_ENV = "production"
  }

  depends_on = [module.networking]
}

module "backend_portfolio" {
  source = "../modules/cloud-run"

  project_id         = var.project_id
  region             = var.region
  app_name           = "trade-harmony-backend-portfolio"
  image_name         = var.backend_portfolio
  vpc_connector_name = module.networking.backend_connector_name

  env_vars = {
    # OpenAI
    OPENAI_API_KEY       = var.OPENAI_API_KEY
    EMBEDDING_MODEL      = "text-embedding-3-large"
    CHAT_MODEL          = "gpt-4o-mini"
    
    # Typesense (Your VM internal IPs)
    TYPESENSE_HOST      = "10.0.1.4"
    TYPESENSE_PORT      = "8108"
    TYPESENSE_PROTOCOL  = "http"
    TYPESENSE_API_KEY   = var.TYPESENSE_API_KEY 
    
    # MongoDB (Your VM internal IP)
    MONGODB_URI         = "mongodb://10.0.1.4:27017/" 
    
    # RAG Config
    RAG_TOP_K           = "5"
    RAG_MAX_DISTANCE    = "0.7"
    CV_SOURCE           = "MH_CV.pdf"
  }

  depends_on = [module.networking]
}


# BACKEND SERVICE (API -s Connects to MongoDB)
module "backend" {
  source = "../modules/cloud-run"

  project_id         = var.project_id
  region             = var.region
  app_name           = "ub-travel-services-backend"
  image_name         = var.backend_image_name
  vpc_connector_name = module.networking.backend_connector_name

  env_vars = {
    DB_HOST    = module.mongodb.internal_ip 
    DB_PORT    = "27017"                    
    MONGO_DB   = "travelDB"                
    SECRET_KEY = var.secret_key
    FLASK_ENV  = "production"
    SENDGRID_API_KEY = var.sendgrid_api_key
    APP_BASE_URL = "https://find-tradespeople.com"
    FRONTEND_BASE_URL = "https://find-tradespeople.com"
    STRIPE_SECRET_KEY = var.stripe_secret_key
    OPENAI_API_KEY = var.OPENAI_API_KEY
    COOKIE_DOMAIN = "find-tradespeople.com"
    GOOGLE_CLIENT_ID = var.google_client_id
    REDIS_URL = module.redis.connection_string
  }

  depends_on = [module.networking, module.mongodb, module.redis]
}


module "redis" {
  source = "../modules/redis"

  project_id      = var.project_id
  region          = var.region
  redis_name      = "jobhub-redis"
  tier            = "BASIC"
  memory_size_gb  = 1
  redis_version   = "REDIS_7_0"
  display_name    = "JobHub Redis for Celery"
  
  labels = {
    environment = var.environment
    service     = "backend"
    component   = "redis"
  }
}
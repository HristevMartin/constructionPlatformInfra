# Enable required services
resource "google_project_service" "compute_api" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "vpcaccess_api" {
  service            = "vpcaccess.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "iap_api" {
  service            = "iap.googleapis.com"
  disable_on_destroy = false
}

# SINGLE VPC NETWORK FOR ALL SERVICES
resource "google_compute_network" "vpc_network" {
  name                    = "${var.app_name}-vpc"
  auto_create_subnetworks = false
  depends_on              = [google_project_service.compute_api]
}

# Main subnet for Cloud Run services
resource "google_compute_subnetwork" "main_subnet" {
  name          = "${var.app_name}-main-subnet"
  ip_cidr_range = var.main_subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc_network.id
  
  private_ip_google_access = true
}

# MongoDB subnet (different region)
resource "google_compute_subnetwork" "mongo_subnet" {
  count = var.enable_mongo_subnet ? 1 : 0
  
  name          = "${var.app_name}-mongo-subnet"
  ip_cidr_range = var.mongo_subnet_cidr
  region        = var.mongo_region
  network       = google_compute_network.vpc_network.id
  
  private_ip_google_access = true
}

# VPC Connector for Simple Frontend
resource "google_vpc_access_connector" "frontend_simple_connector" {
  name          = "th-frontend-simple"
  region        = var.region
  ip_cidr_range = "10.8.0.0/28"
  network       = google_compute_network.vpc_network.name
  
  depends_on = [google_project_service.vpcaccess_api]
}


# VPC Connector for Frontend Portfolio
resource "google_vpc_access_connector" "frontend_portfolio_connector" {
  name          = "th-frontend-portfolio"
  region        = var.region
  ip_cidr_range = "10.8.1.0/28"
  network       = google_compute_network.vpc_network.name
  
  depends_on = [google_project_service.vpcaccess_api]
}

# VPC Connector for Backend
resource "google_vpc_access_connector" "backend_connector" {
  name          = "th-backend"
  region        = var.region
  ip_cidr_range = "10.8.2.0/28"
  network       = google_compute_network.vpc_network.name
  
  depends_on = [google_project_service.vpcaccess_api]
}

# Cloud NAT for MongoDB internet access
resource "google_compute_router" "nat_router" {
  count = var.enable_mongo_subnet ? 1 : 0
  
  name    = "${var.app_name}-nat-router"
  region  = var.mongo_region
  network = google_compute_network.vpc_network.id
}

resource "google_compute_router_nat" "nat_gateway" {
  count = var.enable_mongo_subnet ? 1 : 0
  
  name   = "${var.app_name}-nat-gateway"
  router = google_compute_router.nat_router[0].name
  region = var.mongo_region
  
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
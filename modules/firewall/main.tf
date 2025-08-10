# Firewall rule for IAP SSH access
resource "google_compute_firewall" "iap_ssh" {
  name    = "${var.app_name}-iap-ssh"
  network = var.network_name
  
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  
  # IAP's IP range for SSH tunneling
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["iap-ssh"]
}

# Firewall rule for MongoDB access
resource "google_compute_firewall" "mongodb_firewall" {
  count = var.enable_mongodb_rules ? 1 : 0
  
  name    = "${var.app_name}-mongodb-firewall"
  network = var.network_name
  
  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }
  
  source_ranges = var.mongodb_source_ranges
  target_tags   = ["mongodb-server"]
}

# Allow internal traffic
resource "google_compute_firewall" "allow_internal" {
  name    = "${var.app_name}-allow-internal"
  network = var.network_name
  
  allow {
    protocol = "tcp"
  }
  
  allow {
    protocol = "udp"
  }
  
  allow {
    protocol = "icmp"
  }
  
  source_ranges = var.internal_source_ranges
}

# Allow egress traffic
resource "google_compute_firewall" "allow_egress" {
  name      = "${var.app_name}-allow-egress"
  network   = var.network_name
  direction = "EGRESS"
  
  allow {
    protocol = "all"
  }
  
  destination_ranges = ["0.0.0.0/0"]
}
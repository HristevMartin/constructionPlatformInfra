# MongoDB VM - No external IP, IAP access
resource "google_compute_instance" "mongodb_vm" {
  name         = "${var.app_name}-mongodb"
  machine_type = var.machine_type
  zone         = "${var.mongo_region}-${var.zone_suffix}"
  
  boot_disk {
    initialize_params {
      image = var.boot_image
      size  = var.disk_size
      type  = var.disk_type
    }
  }
  
  network_interface {
    network    = var.network_name
    subnetwork = var.subnet_name
  }
  
  tags = ["mongodb-server", "iap-ssh"]

   lifecycle {
    ignore_changes = [
      metadata["ssh-keys"],
      metadata_startup_script
    ]
  }
  
}
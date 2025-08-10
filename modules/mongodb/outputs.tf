output "instance_name" {
  description = "Name of the MongoDB instance"
  value       = google_compute_instance.mongodb_vm.name
}

output "instance_id" {
  description = "ID of the MongoDB instance"
  value       = google_compute_instance.mongodb_vm.id
}

output "internal_ip" {
  description = "Internal IP of the MongoDB instance"
  value       = google_compute_instance.mongodb_vm.network_interface[0].network_ip
}

output "zone" {
  description = "Zone of the MongoDB instance"
  value       = google_compute_instance.mongodb_vm.zone
}
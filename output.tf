output "consul_servers" {
  value = google_compute_instance.consul.*.network_interface.0.access_config.0.nat_ip
}

output "vault_servers" {
  value = google_compute_instance.vault.*.network_interface.0.access_config.0.nat_ip
}
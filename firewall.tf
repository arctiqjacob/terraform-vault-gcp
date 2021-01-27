resource "google_compute_firewall" "consul_ui" {
  name    = "consul"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8500"]
  }

  target_tags   = ["consul"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "vault_ui" {
  name    = "vault"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8200"]
  }

  target_tags   = ["vault"]
  source_ranges = ["0.0.0.0/0"]
}
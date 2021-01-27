resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
}

data "google_compute_image" "os_image" {
  family  = "ubuntu-1804-lts"
  project = "ubuntu-os-cloud"
}

resource "google_compute_instance" "consul" {
  count        = 3
  name         = "consul-${var.region}-${var.zone[0]}-${count.index}"
  machine_type = var.machine_type
  zone         = "${var.region}-${var.zone[0]}"

  tags = ["consul", "${var.region}-${var.zone[0]}"]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.os_image.self_link
    }
  }

  network_interface {
    network = var.network

    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    ssh-keys = "provisioner:${tls_private_key.ssh_key.public_key_openssh}"
  }

  connection {
    host        = self.network_interface.0.access_config.0.nat_ip
    type        = "ssh"
    user        = "provisioner"
    private_key = tls_private_key.ssh_key.private_key_pem
  }

  provisioner "file" {
    content     = templatefile("scripts/consul_startup.sh.tmpl", { consul_cloud_tag = "${var.region}-${var.zone[0]}" })
    destination = "/tmp/consul_startup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/consul_startup.sh",
      "/tmp/consul_startup.sh",
    ]
  }

  service_account {
    scopes = ["compute-ro", "cloud-platform"]
  }
}

resource "google_compute_instance" "vault" {
  depends_on = [google_compute_instance.consul]

  count        = 2
  name         = "vault-${var.region}-${var.zone[0]}-${count.index}"
  machine_type = var.machine_type
  zone         = "${var.region}-${var.zone[0]}"

  tags = ["vault", "${var.region}-${var.zone[0]}"]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.os_image.self_link
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    ssh-keys = "provisioner:${tls_private_key.ssh_key.public_key_openssh}"
  }

  connection {
    host        = self.network_interface.0.access_config.0.nat_ip
    type        = "ssh"
    user        = "provisioner"
    private_key = tls_private_key.ssh_key.private_key_pem
  }

  provisioner "file" {
    content     = templatefile("scripts/vault_startup.sh.tmpl", { storage_backend = "consul", consul_cloud_tag = "${var.region}-${var.zone[0]}" })
    destination = "/tmp/vault_startup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/vault_startup.sh",
      "/tmp/vault_startup.sh",
    ]
  }

  service_account {
    scopes = ["compute-ro", "cloud-platform"]
  }
}
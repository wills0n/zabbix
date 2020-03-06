#===============================================
# Create zabbix server
#===============================================
provider "google" {
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_instance" "zabbix" {
  name         = "zabbix-app"
  machine_type = "g1-small"
  zone         = "${var.zone_instance}"
  tags         = ["${var.zabbix_tag}"]

  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  metadata = {
    sshKeys = "${var.default_user}:${file("~/.ssh/appuser.pub")}"
  }
  connection {
    host        = self.network_interface.0.access_config.0.nat_ip
    type        = "ssh"
    user        = "${var.default_user}"
    private_key = "${file("~/.ssh/appuser")}"
  }

  provisioner "file" {
    source      = "scripts/setupzabbix.sh"
    destination = "~/setupzabbix.sh"
  }

  provisioner "file" {
    source      = "scripts/zabconf"
    destination = "~/"
  }

  # provisioner "remote-exec" {
  #   inline = ["${file("scripts/setupzabbix.sh")}"]
  # }


  resource "google_compute_firewall" "firewall_vpn" {
    name = "allow-zabbix"

    # name of net
    network = "default"

    allow {
      protocol = "tcp"
      ports = [
        "443", "80", "10050", "10051"
      ]
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["${var.zabbix_tag}"]
  }
}

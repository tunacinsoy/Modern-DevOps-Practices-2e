terraform {
  required_providers {
    google = {
      source  = "google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "ansible-exercise-429611"
  region  = "me-west1"
}

resource "google_compute_instance" "default" {
  count        = 1
  name         = "vm-instance-${count.index + 1}"
  machine_type = "e2-medium"
  zone         = "me-west1-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}

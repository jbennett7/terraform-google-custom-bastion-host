data "google_compute_zones" "available" {
    region = var.region
    project = var.project
}

data "google_compute_subnetwork" "subnetwork" {
    name = var.subnetwork
    region = var.region
    project = var.project
}

locals {
    zones = data.google_compute_zones.available.names
}

data "template_file" "startup_script" {
  template = var.startup_script

  vars = {
    CLUSTER_NAME   = var.cluster_name
    CLUSTER_REGION = var.region
    PROJECT        = var.project
    ISTIO_VERSION  = var.istio_version
    HELM_VERSION   = var.helm_version
    CALICO_VERSION = var.calico_version
  }
}

# Comment out the following resource if not using external access
resource "google_compute_address" "bastion_external_address" {
  name   = "bastion-external-address"
  region = var.region
  project = var.project
}

resource "google_compute_instance" "gke-bastion" {
  name                      = var.bastion_hostname
  machine_type              = var.bastion_machine_type
  zone                      = local.zones[0]
  project                   = var.project
  tags                      = var.bastion_tags
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    subnetwork = data.google_compute_subnetwork.subnetwork.self_link

    # Comment out the following block if not using external access
    access_config {
      nat_ip = google_compute_address.bastion_external_address.address
    }
  }

  metadata_startup_script = data.template_file.startup_script.rendered

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro", "cloud-platform"]
  }

}

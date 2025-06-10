terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Compute Engine pour API (Staging)
resource "google_compute_instance" "api_staging" {
  name         = "mobile-api-staging"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_public_key_path)}"
  }

  metadata_startup_script = <<-EOF
    apt-get update
    apt-get install -y docker.io
    systemctl start docker
    systemctl enable docker
    usermod -aG docker ${var.ssh_user}
  EOF

  tags = ["http-server", "https-server", "staging"]
}

# Compute Engine pour API (Production)
resource "google_compute_instance" "api_production" {
  name         = "mobile-api-production"
  machine_type = "e2-small"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_public_key_path)}"
  }

  metadata_startup_script = <<-EOF
    apt-get update
    apt-get install -y docker.io
    systemctl start docker
    systemctl enable docker
    usermod -aG docker ${var.ssh_user}
  EOF

  tags = ["http-server", "https-server", "production"]
}

# Firewall Rules
resource "google_compute_firewall" "api_firewall" {
  name    = "mobile-api-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "3000", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server", "https-server"]
}

# Cloud Storage pour backups
resource "google_storage_bucket" "api_backups" {
  name          = "${var.project_id}-mobile-api-backups"
  location      = var.region
  force_destroy = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }
}

# Cloud SQL pour base de données (optionnel)
resource "google_sql_database_instance" "api_db" {
  name             = "mobile-api-db"
  database_version = "POSTGRES_13"
  region           = var.region

  settings {
    tier = "db-f1-micro"
    
    backup_configuration {
      enabled = true
      start_time = "03:00"
    }
  }
}

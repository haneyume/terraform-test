terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file("k8sbeta-851579027fa4.json")

  project = "k8sbeta"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_cloud_run_service" "default" {
  name     = "terraform-cloudrun"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_storage_bucket" "auto-expire" {
  name     = "credot-terraform-test-storage"
  location = "US"
}

resource "google_storage_bucket_object" "picture" {
  name   = "cat01"
  source = "./images/cat.jpg"
  bucket = "credot-terraform-test-storage"
}

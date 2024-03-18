terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  project = var.projectId
  region  = var.region
  zone    = var.zone
}

resource "google_storage_bucket" "gcp-bucket" {
  name          = var.gcs_bucket_name
  location      = var.region
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

resource "google_bigquery_dataset" "ny_taxi_dataset" {
  dataset_id                 = var.bq_dataset_name
  location                   = var.region
  delete_contents_on_destroy = true
}
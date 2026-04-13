# Meridian GCP IaC — hardened baseline
terraform {
  required_version = ">= 1.6"
  required_providers {
    google = { source = "hashicorp/google", version = "~> 5.30" }
    random = { source = "hashicorp/random", version = "~> 3.6" }
  }
}

variable "project_id" {
  type    = string
  default = "722157602170"
}

provider "google" {
  project = var.project_id
  region  = "asia-south1"
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "google_storage_bucket" "fundamentals" {
  name                        = "meridian-fundamentals-${random_id.bucket_suffix.hex}"
  location                    = "ASIA-SOUTH1"
  force_destroy               = true
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  versioning {
    enabled = true
  }

  labels = {
    project             = "meridian"
    environment         = "range"
    data_classification = "training-only"
  }
}

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  project = "abx50c5xvoxqqnhrwaqfziooysf2or"
}

resource "google_container_cluster" "primary" {
  name = "nuwe-web-app"
  location = "us-central1-a"
  initial_node_count = 2
}


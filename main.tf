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

provider "kubernetes" {
  host = "https://${data.google_container_cluster.my_cluster.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate)
}

resource "google_container_cluster" "primary" {
  name = "nuwe-web-app"
  location = "us-central1-a"
  initial_node_count = 2
}


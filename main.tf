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

data "google_client_config" "default" {}
resource "google_container_cluster" "primary" {
  name = "nuwe-web-app2"
  location = "us-central1-a"
  initial_node_count = 2
}

provider "kubernetes" {
  host                   = "https://${resource.google_container_cluster.primary.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(resource.google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
}

resource "kubernetes_deployment" "kd" {
  metadata {
    name      = "nuwe-app"
  }
  spec {
    replicas = 1
    selector  {
      match_labels = {
        app = "nuwe-app"
      }
    }
    template {
      metadata {
        labels  = {
          app = "nuwe-app"
        }
      }
      spec {
        container {
          image = "gcr.io/abx50c5xvoxqqnhrwaqfziooysf2or/mms-cloud-skeleton-fork@sha256:0d4fdda135821207879552ecddf3db4dea1805568bd60106fb61a40a6b2f1589"
          name  = "nuwe-app"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "ks" {
  metadata {
    name      = "nuwe-app"
  }
  spec {
    selector = {
      app = kubernetes_deployment.kd.spec.0.template.0.metadata.0.labels.app
    }
    type = "LoadBalancer"
    port {
      port        = 80
      target_port = 8080
    }
  }
}

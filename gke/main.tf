provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

resource "google_container_cluster" "argo_cluster" {
  project  = var.project_id
  name     = var.cluster_name
  location = var.zone

  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "preemptible_nodes" {
  project    = var.project_id
  name       = "pool-1"
  location   = var.zone
  cluster    = google_container_cluster.argo_cluster.name
  node_count = 1

  node_config {
    preemptible  = var.use_preemtbile_nodes 
    machine_type = var.machine_type

  }

  autoscaling{
    min_node_count = 0 
    max_node_count = 3
  }
}

output "cluster_name" {
  value = google_container_cluster.argo_cluster.name
  description = "The cluster name."
  depends_on = [
    google_container_cluster.argo_cluster 
  ]
}

output "cluster_zone" {
  value = google_container_cluster.argo_cluster.location
  description = "The  cluster zone."
  depends_on = [
    google_container_cluster.argo_cluster 
  ] 
}

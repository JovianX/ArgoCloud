variable "project_id" {
  type = string
  default = "argocloud"
  description = "GCP project id"
}

variable "cluster_name" {
  type = string
  default = "argo-cluster"
  description = "GKE cluster name"
}

variable "region" {
  type = string 
  default = "us-central1"
}

variable "zone" {
  type = string
  default = "us-central1-a"
}

variable "machine_type" {
  type = string
  default = "c2-standard-4"
  description = "The machine type the node pool will run."
}

variable "use_preemtbile_nodes" {
  type = bool
  default = true
  description	= "Will the node instances in the pool be preemptible."
}

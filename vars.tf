variable "project" {
  type        = string
  description = "The project ID to host the cluster in (required)"
}

variable "region" {
  type        = string
  description = "The region to host the cluster in"
  default     = "us-central1"
}

variable "zone" {
  type        = list(string)
  description = "The zones to host the cluster in"
  default     = ["a", "c", "d", "f"]
}

variable "machine_type" {
  type        = string
  description = "The machine type to use for the cluster nodes"
  default     = "e2-micro"
}

variable "network" {
  type        = string
  description = "The VPC network to host the cluster in"
  default     = "default"
}
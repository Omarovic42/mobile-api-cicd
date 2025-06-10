variable "project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "mobile-api-cicd-project"
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "europe-west1"
}

variable "zone" {
  description = "GCP Zone"
  type        = string
  default     = "europe-west1-b"
}

variable "ssh_user" {
  description = "SSH User"
  type        = string
  default     = "omarovic42"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

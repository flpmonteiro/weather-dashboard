variable "projectId" {
  default = "weather-dashboard-417618"
}

variable "region" {
  description = "Region"
  default     = "southamerica-east1"
}

variable "zone" {
  description = "Zone"
  default     = "southamerica-east1-a"
}

variable "bq_dataset_name" {
  description = "BigQuery Dataset name"
  default     = "ghcn_d"
}

variable "gcs_bucket_name" {
  description = "Cloud Storage Bucket Name"
  default     = "weather-dashboard-417618-gcp-bucket"
}
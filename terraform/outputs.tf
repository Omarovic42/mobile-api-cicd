output "staging_ip" {
  value = google_compute_instance.api_staging.network_interface[0].access_config[0].nat_ip
}

output "production_ip" {
  value = google_compute_instance.api_production.network_interface[0].access_config[0].nat_ip
}

output "bucket_name" {
  value = google_storage_bucket.api_backups.name
}

output "database_connection" {
  value = google_sql_database_instance.api_db.connection_name
}

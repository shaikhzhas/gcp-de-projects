provider "google" {
  # Specify your provider configuration here: project, credentials, etc.
  credentials = file("~/terraform-key.json")
  project = "sustainable-data-platform"
}

# 1. Create a BigQuery table with a specific schema
resource "google_bigquery_table" "bq_table" {
  dataset_id = "sdp"
  table_id   = "table_tf"

  schema = jsonencode([
    {
      name = "id"
      type = "STRING"
      mode = "REQUIRED"
    },
    {
      name = "value"
      type = "INTEGER"
      mode = "NULLABLE"
    }
  ])
}
provider "google" {
  # Specify your provider configuration here: project, credentials, etc.
  credentials = file("~/terraform-key.json")
  project = "sustainable-data-platform"
}

resource "google_bigquery_table" "bq_view" {
  dataset_id = "sdp"
  table_id   = "view_tf"

  view {
    query = "SELECT id, SUM(value) as value_sum FROM `sustainable-data-platform.sdp.table_tf` GROUP BY id"
    use_legacy_sql = false
  }
}
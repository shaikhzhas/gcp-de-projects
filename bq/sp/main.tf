provider "google" {
  # Specify your provider configuration here: project, credentials, etc.
  credentials = file("~/terraform-key.json")
  project = "sustainable-data-platform"
}

resource "google_bigquery_routine" "bq_stored_procedure" {
  dataset_id   = "sdp"
  routine_id   = "sp_tf"
  routine_type = "PROCEDURE"

  definition_body = <<EOF
    CREATE PROCEDURE `sustainable-data-platform.sdp.sp_tf`(IN input_id STRING)
    BEGIN
    -- Example procedure logic here
    SELECT * FROM `sustainable-data-platform.sdp.table_tf` WHERE id = input_id;
    END;
    EOF
}
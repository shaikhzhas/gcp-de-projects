provider "google" {
  # Specify your provider configuration here: project, credentials, etc.
  credentials = file("~/terraform-key.json")
  project = "sustainable-data-platform"
}

resource "google_bigquery_table" "external_table" {
  dataset_id = "sdp"
  table_id   = "sample_sustainability_data_tf"

  external_data_configuration {
    autodetect    = false
    source_format = "CSV"
    source_uris = [
      "gs://sdp-dev/sample_sustainability_data.csv"
    ]

    csv_options {
      skip_leading_rows = 1  # If your CSV has a header row
      quote = "\""        # Define the quote character used in your CSV
    }

    # Define the schema explicitly
    schema = jsonencode([
      {
        name = "Year"
        type = "INTEGER"
        mode = "REQUIRED"
        description = "Year of the data entry"
      },
      {
        name = "Country"
        type = "STRING"
        mode = "REQUIRED"
        description = "Country of the data entry"
      },
      {
        name = "CO2_Emissions"
        type = "FLOAT"
        mode = "NULLABLE"
        description = "CO2 Emissions in metric tons"
      },
      {
        name = "Renewable_Energy_Consumption"
        type = "FLOAT"
        mode = "NULLABLE"
        description = "Percentage of renewable energy consumption"
      },
      {
        name = "Population_Millions"
        type = "FLOAT"
        mode = "NULLABLE"
        description = "Population in millions"
      }
    ])
  }
}

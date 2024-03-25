import functions_framework
from google.cloud import bigquery
from google.cloud.exceptions import NotFound

PROJECT_ID = "sustainable-data-platform"

def initialize_external_table():
    print("Initializing the external table...")
    # Initialize a BigQuery client
    client = bigquery.Client(PROJECT_ID)

    # Define the table ID
    table_id = "sustainable-data-platform.sdp.sample_sustainability_data_with_schema"

    # Attempt to delete the table if it exists
    try:
        client.delete_table(table_id, not_found_ok=True)  # Make an API request.
        print(f"Deleted table '{table_id}'.")
    except NotFound:
        print(f"Table '{table_id}' not found.")

    # Define the job configuration for loading data
    job_config = bigquery.LoadJobConfig(
        source_format=bigquery.SourceFormat.CSV,
        skip_leading_rows=1,  # Skip the header row
        autodetect=True,  # Automatically detect the schema
    )

    # Define the URI of the source file in GCS
    uri = "gs://sdp-dev/sample_sustainability_*.csv"

    # Start the load job
    load_job = client.load_table_from_uri(
        uri,
        table_id,
        job_config=job_config
    )

    # Wait for the load job to complete
    load_job.result()

    print(f"Table '{table_id}' is updated with data from '{uri}'.")
    print("External table initialization complete.")

def transform_core_layer():
    print("Transforming the core layer...")
    # Initialize a BigQuery client
    client = bigquery.Client(PROJECT_ID)

    # Define the SQL query, merging the data from the two tables
    query = """
    MERGE INTO `sustainable-data-platform.sdp.sample_sustainability_data_with_schema_core` AS TARGET
    USING `sustainable-data-platform.sdp.sample_sustainability_data_with_schema` AS SOURCE
    ON 
    TARGET.Year = SOURCE.Year AND
    TARGET.Country = SOURCE.Country
    WHEN MATCHED THEN
    UPDATE SET 
        TARGET.CO2_Emissions = SOURCE.CO2_Emissions,
        TARGET.Renewable_Energy_Consumption = SOURCE.Renewable_Energy_Consumption,
        TARGET.Population_Millions = SOURCE.Population_Millions
    WHEN NOT MATCHED THEN
    INSERT (Year, Country, CO2_Emissions, Renewable_Energy_Consumption, Population_Millions)
    VALUES (SOURCE.Year, SOURCE.Country, SOURCE.CO2_Emissions, SOURCE.Renewable_Energy_Consumption, SOURCE.Population_Millions);
    """
    query_job = client.query(query)  # API request
    query_job.result()  # Wait for the job to complete
    print("Core layer transformation complete.")

def transform_datamart_layer():
    print("Transforming the datamart layer...")
    # Initialize a BigQuery client
    client = bigquery.Client(PROJECT_ID)
    query = """
    MERGE INTO `sustainable-data-platform.sdp.sample_sustainability_data_with_schema_datamart` AS TARGET
    USING `sustainable-data-platform.sdp.sample_sustainability_data_with_core` AS SOURCE
    ON 
    TARGET.Year = SOURCE.Year AND
    TARGET.Country = SOURCE.Country
    WHEN MATCHED THEN
    UPDATE SET 
        TARGET.CO2_Emissions = SOURCE.CO2_Emissions,
        TARGET.Renewable_Energy_Consumption = SOURCE.Renewable_Energy_Consumption,
        TARGET.Population_Millions = SOURCE.Population_Millions
    WHEN NOT MATCHED THEN
    INSERT (Year, Country, CO2_Emissions, Renewable_Energy_Consumption, Population_Millions)
    VALUES (SOURCE.Year, SOURCE.Country, SOURCE.CO2_Emissions, SOURCE.Renewable_Energy_Consumption, SOURCE.Population_Millions);
    """
    query_job = client.query(query)  # API request
    query_job.result()  # Wait for the job to complete
    print("Datamart layer transformation complete.")


@functions_framework.http
def entry_point(request):
    print(f"request: {request}")
    print("Starting the data pipeline...")
    initialize_external_table()
    transform_core_layer()
    transform_datamart_layer()
    print("Data pipeline complete.")
    return "Data pipeline complete."
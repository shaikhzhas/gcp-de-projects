import functions_framework
from google.cloud import bigquery

PROJECT_ID = "sustainable-data-platform"

def transform_datamart_layer():
    print("Transforming the datamart layer...")
    # Initialize a BigQuery client
    client = bigquery.Client(PROJECT_ID)
    query = """
    MERGE INTO `sustainable-data-platform.sdp.sample_sustainability_data_with_schema_datamart` AS TARGET
    USING (
    SELECT
        Year,
        Country,
        AVG(CO2_Emissions) AS CO2_Emissions,
        AVG(Renewable_Energy_Consumption) AS Renewable_Energy_Consumption,
        AVG(Population_Millions) AS Population_Millions
    FROM
        `sustainable-data-platform.sdp.sample_sustainability_data_with_schema_core`
    GROUP BY
        Year, Country
    ) AS SOURCE
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
    transform_datamart_layer()
    print("Data pipeline complete.")
    return "Data pipeline complete."
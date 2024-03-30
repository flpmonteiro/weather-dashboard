from mage_ai.settings.repo import get_repo_path
from mage_ai.io.bigquery import BigQuery
from mage_ai.io.config import ConfigFileLoader
from os import path

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter

from google.cloud import bigquery
from google.oauth2 import service_account


@data_exporter
def export_data_to_big_query(*args, **kwargs) -> None:
    """
    Template for exporting data to a BigQuery warehouse.
    Specify your configuration settings in 'io_config.yaml'.

    Docs: https://docs.mage.ai/design/data-loading#bigquery
    """
    now = kwargs.get('execution_date')
    year = now.year

    # Define the GCS URI of the Parquet files
    bucket_name = 'weather-dashboard-417618-gcp-bucket'
    object_key = f'{year}.parquet'
    gcs_uri = f'gs://{bucket_name}/{object_key}'

    # Define the BigQuery table ID
    table_id = f'weather-dashboard-417618.ghcn_d.year_{year}'

    # Path to your service account key file
    key_path = "/home/src/personal-gcp.json"

    # Explicitly use service account credentials by specifying the private key file.
    credentials = service_account.Credentials.from_service_account_file(key_path)

    # Initialize the BigQuery client with credentials
    client = bigquery.Client(credentials=credentials)

    # Define the job configuration to load a Parquet file
    job_config = bigquery.LoadJobConfig(source_format=bigquery.SourceFormat.PARQUET)

    # Start the load job
    load_job = client.load_table_from_uri(
        gcs_uri,
        table_id,
        job_config=job_config
    )

    # Wait for the job to complete
    load_job.result()

    print(f'Successfully loaded data from {gcs_uri} to {table_id}')


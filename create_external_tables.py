from sys import prefix
from google.cloud import bigquery, storage

bq_client = bigquery.Client()
gcs_client = storage.Client()

prefix_folder = "s4"

count_blobs = 0
for blob in gcs_client.list_blobs("also-analytics-model-nonprod", prefix=prefix_folder + '/target_s4.viradocitem.parquet'):
    if blob.name.endswith(".parquet"):
        print(blob.name)
        dataset, table, f_format = blob.name.split('/')[1].split('.')
    
        dataset_ref = bigquery.Dataset(f"{bq_client.project}.1_AQUISICAO_{prefix_folder.upper()}")
        bq_client.create_dataset(dataset_ref, exists_ok=True)
        
        table_ref = bigquery.Table(f"{bq_client.project}.1_AQUISICAO_{prefix_folder.upper()}.{table}")
        
        external_config = bigquery.ExternalConfig('PARQUET')
        external_config.source_uris = [f"gs://{blob.bucket.name}/{blob.name}"]
        
        table_ref.external_data_configuration = external_config
        
        bq_client.create_table(table_ref, exists_ok=True)
        
        count_blobs += 1

print(f"Blobs processados: {count_blobs}")

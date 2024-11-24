import os
import requests
import pandas as pd
from google.cloud import bigquery
from google.oauth2 import service_account

# Base URL and access token
base_url = "https://graph.instagram.com/"
access_token = "IGQWRQQWx5ZA0NFWXdxamtDNGQ1ZA2VtUzMwUURBcVF2Q01lZAEdmR21uNzJqQVloZAWNKRmJ6M1pTVlZAqMFBVUlpqVW9XZAEtnRmFXdzFkQXZATYkR1QmJIdHBDR0FaNFEzaWdxWWVZAMUFBQ2psZAwZDZD"

# BigQuery setup
PROJECT_ID = "consulting-project-1"  # Replace with your GCP project ID
DATASET_ID = "dbt_project"  # Replace with your dataset name
TABLE_ID = "instagram_media_details"  # Replace with your table name
CREDENTIALS_PATH = "/Users/umer.ghani/dbt/dbt_project/service_account.json"  # Path to service account JSON file

# File save path
CSV_LANDING_PATH = "/Users/umer.ghani/dbt/scripts/social_media/csv_landing/"
CSV_FILE_NAME = "instagram_media_details.csv"
FULL_CSV_PATH = os.path.join(CSV_LANDING_PATH, CSV_FILE_NAME)

credentials = service_account.Credentials.from_service_account_file(CREDENTIALS_PATH)
client = bigquery.Client(credentials=credentials, project=PROJECT_ID)

# Function to fetch media details
def fetch_media_details(media_id):
    endpoint = f"{base_url}{media_id}"
    fields = "caption,id,is_shared_to_feed,media_type,media_url,permalink,thumbnail_url,timestamp,username,children"
    params = {
        "fields": fields,
        "access_token": access_token
    }
    response = requests.get(endpoint, params=params)
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Failed to fetch details for media ID {media_id}: {response.status_code}")
        print(response.text)
        return None

# Initial API call to fetch media IDs
initial_url = f"{base_url}me"
fields = "id,username,media"
params = {
    "fields": fields,
    "access_token": access_token
}
response = requests.get(initial_url, params=params)

if response.status_code == 200:
    data = response.json()
    media_list = data.get('media', {}).get('data', [])
    
    # Loop through media IDs and fetch details
    detailed_media_data = []
    for media in media_list:
        media_id = media.get('id')
        if media_id:
            details = fetch_media_details(media_id)
            if details:
                detailed_media_data.append(details)
    
    # Convert to DataFrame
    if detailed_media_data:
        df = pd.DataFrame(detailed_media_data)
        print("Detailed Media Data as DataFrame:")
        print(df)
        
        # Save as CSV
        try:
            os.makedirs(CSV_LANDING_PATH, exist_ok=True)  # Ensure the directory exists
            df.to_csv(FULL_CSV_PATH, index=False)
            print(f"Data successfully saved to CSV at {FULL_CSV_PATH}")
        except Exception as e:
            print(f"Failed to save data to CSV: {e}")
        
        # Save to BigQuery
        table_id = f"{PROJECT_ID}.{DATASET_ID}.{TABLE_ID}"
        job_config = bigquery.LoadJobConfig(
            write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE  # Replace with WRITE_APPEND to append data
        )
        
        try:
            job = client.load_table_from_dataframe(df, table_id, job_config=job_config)
            job.result()  # Wait for the job to complete
            print(f"Data successfully loaded into {table_id}")
        except Exception as e:
            print(f"Failed to load data to BigQuery: {e}")
    else:
        print("No detailed media data found.")
else:
    print(f"Initial request failed with status code {response.status_code}")
    print(response.text)

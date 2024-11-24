import os
from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.python_operator import PythonOperator
import subprocess

# Path to the Instagram ingestion script
INSTAGRAM_SCRIPT_PATH = 'scripts/social_media/instagram_ingestion.py'  # Replace with the actual path to your script

# Airflow default_args
default_args = {
    'owner': 'airflow',
    'retries': 3,
    'retry_delay': timedelta(minutes=5),
    'start_date': datetime(2024, 11, 24),  # Set the start date as per your requirement
}

# Define the DAG
dag = DAG(
    'instagram_ingestion_dag',
    default_args=default_args,
    description='Run Instagram ingestion script',
    schedule_interval='@hourly',  # Run the DAG hourly
    catchup=False,  # Set to False to prevent backfilling
)

# Define the function to call the external script
def run_instagram_ingestion():
    try:
        # Call the instagram_ingestion.py script using subprocess
        subprocess.run(['python', INSTAGRAM_SCRIPT_PATH], check=True)
        print("Instagram ingestion script executed successfully.")
    except subprocess.CalledProcessError as e:
        print(f"Error occurred while running the script: {e}")
        raise

# Define the Airflow task
ingest_instagram_task = PythonOperator(
    task_id='ingest_instagram_media',
    python_callable=run_instagram_ingestion,
    dag=dag,
)

# Task dependencies (none in this case, as it's a single task)
ingest_instagram_task

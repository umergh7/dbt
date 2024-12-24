from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.google.cloud.operators.bigquery import BigQueryInsertJobOperator
from datetime import datetime, timedelta
import os
import requests

# Define default_args for the DAG
default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

# Define the DAG
with DAG(
    dag_id="cat_fact_to_bq",
    default_args=default_args,
    description="Fetch cat facts and insert into BigQuery",
    schedule_interval="0 * * * *",  # Hourly
    start_date=datetime(2024, 12, 1),
    catchup=False,
    tags=["example", "cat-facts", "bigquery"],
) as dag:

    # Task 1: Fetch Cat Fact from API
    def fetch_cat_fact(**kwargs):
        url = "https://catfact.ninja/fact"
        response = requests.get(url)

        if response.status_code == 200:
            data = response.json()
            cat_fact = data.get("fact", "No fact found")
            # Push the fetched fact to XCom
            kwargs["ti"].xcom_push(key="cat_fact", value=cat_fact)
        else:
            raise Exception(f"Failed to fetch data. HTTP Status Code: {response.status_code}")

    fetch_cat_fact_task = PythonOperator(
        task_id="fetch_cat_fact",
        python_callable=fetch_cat_fact,
        provide_context=True,
    )

    # Task 2: Insert Cat Fact into BigQuery
    insert_into_bq_task = BigQueryInsertJobOperator(
        task_id="insert_cat_fact_into_bq",
        configuration={
            "query": {
                "query": """
                INSERT INTO `consulting-project-1.dbt_project.cat_facts` (fact, created_at)
                VALUES ("{{ ti.xcom_pull(task_ids='fetch_cat_fact', key='cat_fact') }}", CURRENT_TIMESTAMP())
                """,
                "useLegacySql": False,
            }
        },
        location="US",  # Replace with your BigQuery dataset location
        gcp_conn_id="bigquery_conn",  # Airflow connection to GCP
    )

    # Task dependencies
    fetch_cat_fact_task >> insert_into_bq_task

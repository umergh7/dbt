from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta

# Default arguments for the DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': True,  # Enable email on failure
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# DAG definition
with DAG(
    dag_id='dbt_build_cats',
    default_args=default_args,
    description='A simple DAG to run dbt build with tag:cats',
    schedule_interval='@daily',  # Adjust as per your needs
    start_date=datetime(2023, 12, 1),
    catchup=False,
) as dag:

    # Task to run dbt build
    dbt_build_task = BashOperator(
        task_id='dbt_build_cats',
        bash_command=(
            'set -e; '
            'if ! command -v dbt &> /dev/null; then echo "dbt command not found"; exit 1; fi; '
            'dbt build -s tag:cats --profiles-dir /Users/umer.ghani/dbt/dbt_project/profiles.yml --project-dir /Users/umer.ghani/dbt/dbt_project/dbt_project.yml '
            '2>&1 | tee /tmp/dbt_build_cats.log'
        ),
        env={
            'DBT_PROFILES_DIR': '/Users/umer.ghani/dbt/dbt_project/profiles.yml',
            'DBT_PROJECT_DIR': '/Users/umer.ghani/dbt/dbt_project/dbt_project.yml',
        },
    )

    dbt_build_task

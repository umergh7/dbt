from airflow import DAG
from airflow.operators.dummy import DummyOperator
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta

# Define default arguments for the DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# Define a Python function for our task
def sample_task():
    print("Hello, Airflow!")

# Initialize the DAG
with DAG(
    dag_id='sample_dag',
    default_args=default_args,
    description='A simple example DAG',
    schedule_interval=timedelta(days=1),
    start_date=datetime(2023, 1, 1),
    catchup=False,
) as dag:

    # Define tasks
    start = DummyOperator(task_id='start')

    # A Python task that calls the sample_task function
    run_python_task = PythonOperator(
        task_id='run_sample_task',
        python_callable=sample_task
    )

    end = DummyOperator(task_id='end')

    # Set task dependencies
    start >> run_python_task >> end

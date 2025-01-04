from cosmos import DbtDag, ProjectConfig, ProfileConfig, ExecutionConfig
from cosmos.profiles import GoogleCloudServiceAccountFileProfileMapping
import os
from datetime import datetime
from cosmos.config import RenderConfig


airflow_home = os.environ["AIRFLOW_HOME"]

profile_config = ProfileConfig(
    profile_name="default",
    target_name="test",
    profile_mapping=GoogleCloudServiceAccountFileProfileMapping(
        conn_id="bigquery_conn",
        profile_args={"project": "consulting-project-1", "dataset": "e_commerce", "keyfile": "/usr/local/airflow/include/keyfile.json",},
    ),
)

e_commerce_dbt = DbtDag(
    project_config=ProjectConfig(
        f"{airflow_home}/dags/dbt/dbt_project",
    ),
    profile_config=profile_config,
    execution_config=ExecutionConfig(
        dbt_executable_path=f"{airflow_home}/dbt_venv/bin/dbt",
    ),
    render_config=RenderConfig(
        select=["tag:e-commerce"],
    ),
    # normal dag parameters
    schedule_interval="@daily",
    start_date=datetime(2023, 1, 1),
    catchup=False,
    dag_id="e_commerce_dbt",
    default_args={"retries": 0},
)
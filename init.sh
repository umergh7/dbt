# Start containers with Docker Compose
cd $HOME/dbt || exit
echo "Remove previous containers"
if [ "$(docker ps -a -q)" ]; then
    docker stop $(docker ps -a -q)
    docker rm $(docker ps -a -q)
else
    echo "No containers to stop or remove."
fi

echo "Run docker containers"
docker compose -f "docker-compose.superset.yaml" up -d
docker compose -f "docker-compose.airflow.yaml" up -d

# Ensure the Airflow services are up and running (commented out for now)
echo "Waiting for Airflow webserver and scheduler to be ready..."
sleep 60  # Give it time for the containers to start

# Unpause all Airflow DAGs (commented out for now)
docker exec dbt-airflow-webserver-1 airflow dags list | tail -n +2 | awk '{print $1}' | grep -v '^==' | grep -v '^$' | while read -r dag_id; do
    echo "Unpausing DAG: $dag_id"
    docker exec dbt-airflow-webserver-1 airflow dags unpause "$dag_id"
done

# Trigger all Airflow DAGs (commented out for now)
docker exec dbt-airflow-webserver-1 airflow dags list | tail -n +2 | awk '{print $1}' | grep -v '^==' | grep -v '^$' | while read -r dag_id; do
    echo "Triggering DAG: $dag_id"
    docker exec dbt-airflow-webserver-1 airflow dags trigger "$dag_id"
done

echo "All DAGs triggered successfully."
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
astro dev start

# Dynamically find the webserver container ID
webserver_container=$(docker ps -q --filter "name=webserver-1")

if [ -z "$webserver_container" ]; then
    echo "Webserver container not found. Please check if the container is running."
    exit 1
fi

echo "Found webserver container: $webserver_container"

# Unpause all Airflow DAGs
echo "Unpausing all DAGs..."
docker exec "$webserver_container" airflow dags list | tail -n +2 | awk '{print $1}' | grep -v '^==' | grep -v '^$' | while read -r dag_id; do
    echo "Unpausing DAG: $dag_id"
    docker exec "$webserver_container" airflow dags unpause "$dag_id"
done

# Trigger all Airflow DAGs
echo "Triggering all DAGs..."
docker exec "$webserver_container" airflow dags list | tail -n +2 | awk '{print $1}' | grep -v '^==' | grep -v '^$' | while read -r dag_id; do
    echo "Triggering DAG: $dag_id"
    docker exec "$webserver_container" airflow dags trigger "$dag_id"
done

echo "All DAGs triggered successfully."

#Setup Airbyte containers
cd $HOME/dbt/airbyte || exit
chmod +x install.sh
./install.sh

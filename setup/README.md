The purpose of the setup.sh script is so that we can input this as a startup script into our VMs. 

This script ensures the following:
- Docker is installed
- Docker compose is installed
- Git is installed
- Clones the repo and pulls the latest version
- Turns on all containers and triggers ALL dags

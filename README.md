# dbt

#Local Setup - Windows
Setup a python virtual env (`venv`) with the following:
```
python3 -m venv venv
source ./venv/Scripts/activate
pip install --upgrade pip
pip install -r requirements_dbt.txt
```
#Local Setup - Mac
Setup a python virtual env (`venv`) with the following:
```
python3 -m venv venv
source ./venv/bin/activate
pip install --upgrade pip
pip install -r requirements_dbt.txt
```

#Setup Service Account Credentials
- Navigate to `dbt_project` --> `service_account.json`
- Copy your service account credentials into `service_account.json` and click save.
- Copy the path to your `service_account.json` file and save it in the .env folder under `GOOGLE_CLOUD_CREDENTIALS`
- Run the following command:

```
chmod +x ./.env                
. ./.env
export GOOGLE_CLOUD_CREDENTIALS
```
#docker-compose.airflow
- Navigate to `docker-compose.airflow.yaml`
- Run docker compose -f "docker-compose.airflow.yaml" up -d 
- Copy `/opt/airflow/.google/GOOGLE_APPLICATION_CREDENTIALS.json` and save it under the google cloud connection under the Keyfile path

#Test Connection
- `cd dbt_project`
- Run `dbt deps` to install dependencies
- Run `dbt debug` to ensure that we are connected to BigQuery


#Git Workflow
Summary of the Standard Git Workflow
1. Initialize or Clone the Repository:
```
git clone https://github.com/username/repository.git
```
2. Setup Remotes
Ensure your repository is connected to the remote where you'll push and pull code.
You can verify this by checking the remote URL:
```

```
3. Create a Branch:
Always work on a separate branch for each feature or bug fix.
4. Make Changes:
Work on the project in your branch.

5. Stage and Commit:
Stage changes and commit them regularly with clear messages.

6. Sync with the Base Branch:
Rebase or merge from the base branch before pushing your changes.

7. Push Your Branch:
Push your branch to the remote repository.

8. Open a Pull Request:
Open a PR for code review.

9. Review and Feedback:
Address feedback, commit updates, and push again if necessary.

10. Merge and Delete Branch:
Merge the branch into main or develop and delete the feature branch.

11. Pull Latest Changes:
Keep your local repository in sync with the remote.

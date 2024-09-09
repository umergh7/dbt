# dbt

#Local Setup - Windows
Setup a python virtual env (`venv`) with the following:
```
python -m venv venv
source ./venv/Scripts/activate
pip install --upgrade pip
pip install -r requirements.txt
```
#Local Setup - Mac
Setup a python virtual env (`venv`) with the following:
```
python -m venv venv
source ./venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

#Setup Service Account Credentials
- Navigate to `dbt_project` --> `service_account.json`
- Copy your service account credentials into `service_account.json` and click save.
- Copy the path to your `service_account.json` file and save it under `keyfile` in your `profiles.yml` file.

#Test Connection
- `cd dbt_project`
- Run `dbt deps` to install dependencies
- Run `dbt debug` to ensure that we are connected to BigQuery



#!/bin/bash
cd $HOME/dbt
abctl local uninstall
curl -LsfS https://get.airbyte.com | bash -
abctl local install --insecure-cookies

#!/bin/bash
cd /home/shaheerkhan/dbt
sudo systemctl start docker
curl -LsfS https://get.airbyte.com | bash -
sudo abctl local install

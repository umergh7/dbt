#!/bin/bash
#setting variables
export HOME=$(getent passwd $(whoami) | cut -d: -f6)
export USER=$(whoami)

#install docker
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Give Docker user access
sudo usermod -aG docker $USER
newgrp docker

#install git
sudo apt-get install -y git-all

echo "pulling dbt repo"
cd $HOME || exit
if [ ! -d "dbt" ]; then
    git clone https://github.com/umergh7/dbt.git
else
    cd dbt
    git pull origin main
fi

cd $HOME/dbt
chmod +x ./init.sh
./init.sh
#!/bin/bash

# Install Docker
apt-get update
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
apt-get install -y docker-ce
usermod -aG docker ubuntu

# Create CCF repo
su - ubuntu
cd /home/ubuntu
mkdir cloud-carbon-footprint
cd cloud-carbon-footprint

# Set nginx config file
mkdir docker
touch docker/nginx.conf
cat <<EOF >> docker/nginx.conf
${nginx_conf}
EOF

# Set docker compose file
touch docker-compose.yml
cat <<EOF >> docker-compose.yml
${docker_compose}
EOF

# Additional commands
${additional_bash_commands}

# Start CCF application (client and API)
docker compose build
docker compose up -d

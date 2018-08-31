#!/bin/sh -exu
if grep -q Ubuntu /etc/issue
then
  apt-get update
  apt-get install -y docker.io
  adduser ubuntu docker

  USER=ubuntu
else
  systemctl stop update-engine locksmithd

  USER=core
fi

cd /home/$USER/bootstrap

# Create login script
cp login_to_docker.sh /home/$USER

# Get credstash credentials
docker pull mozillasecurity/credstash:latest
mkdir -p /root/.docker
docker run --rm mozillasecurity/credstash get docker-login-config-json > /root/.docker/config.json
chmod 0600 /root/.docker/config.json
# Add extra authorized keys
mkdir -p /home/$USER/.ssh
docker run --rm mozillasecurity/credstash get grizzly-ssh-authorized-keys >> /home/$USER/.ssh/authorized_keys

# Install docker compose
mkdir -p /opt/bin
LATEST_VERSION="$(curl -Ls 'https://api.github.com/repos/docker/compose/releases/latest' | awk -f JSON.awk - | awk '/^\["tag_name"\]/ { gsub(/"/,""); print $2 }')"
curl -L "https://github.com/docker/compose/releases/download/$LATEST_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /opt/bin/docker-compose
chmod +x /opt/bin/docker-compose

# Fix permissions
chown $USER:$USER -R /home/$USER

# sysctls for AFL
sysctl kernel.core_pattern=core
sysctl kernel.core_uses_pid=1

# sysctls for RR
sysctl kernel.perf_event_paranoid=1

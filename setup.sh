#!/bin/sh -exu

cd /home/core/bootstrap

# Add extra authorized keys
mkdir -p /home/core/.ssh
cat .ssh/authorized_keys >> /home/core/.ssh/authorized_keys

# Create login script
cp login_to_docker.sh /home/core

# Get credstash credentials
docker pull mozillasecurity/credstash:latest
mkdir -p /root/.docker
docker run --rm mozillasecurity/credstash get docker-login-config-json > /root/.docker/config.json
chmod 0600 /root/.docker/config.json

# Fix permissions
chown core:core -R /home/core

# sysctls for AFL
sysctl kernel.core_pattern=core
sysctl kernel.core_uses_pid=1

# sysctls for RR
sysctl kernel.perf_event_paranoid=1

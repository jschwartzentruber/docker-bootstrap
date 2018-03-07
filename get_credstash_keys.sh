#!/bin/sh -ex
pip install credstash
cd /mnt  # mounted /home/core of host machine

# add hub.docker.com auth token
credstash get docker-login-config-json > docker-config.json

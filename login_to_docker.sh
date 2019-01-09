#!/bin/sh -ex
if [ $(id -u) -eq 0 ]; then
  docker exec -u root -e "COLUMNS=$(tput cols)" -e "LINES=$(tput lines)" -it "$(sudo docker ps | grep grizzly | tail -n1 | cut -f1 -d' ')" "$@" /bin/bash
else
  sudo docker exec -u worker -e "COLUMNS=$(tput cols)" -e "LINES=$(tput lines)" -it "$(sudo docker ps | grep grizzly | tail -n1 | cut -f1 -d' ')" "$@" /bin/bash
fi

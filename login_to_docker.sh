#!/bin/sh -ex
sudo docker exec -e "COLUMNS=$(tput cols)" -e "LINES=$(tput lines)" -it "$(sudo docker ps | grep grizzly | tail -n1 | cut -f1 -d' ')" "$@" /bin/bash

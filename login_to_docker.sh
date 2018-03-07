#!/bin/sh -ex
sudo docker exec -it $(sudo docker ps | tail -n1 | cut -f1 -d' ') "$@" /bin/bash

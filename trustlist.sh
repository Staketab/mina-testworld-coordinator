#!/bin/bash

. .env

if [ ! -f .env ]; then
  echo "The .env file was not found."
  exit 1
fi

WORKER_IP=$(grep -oP 'WORKER_IP=\K[^ ]+' .env)

IFS=',' read -ra IP_LIST <<< "$WORKER_IP"
for IP in "${IP_LIST[@]}"; do
    sudo docker run -ti --rm --entrypoint=mina ${MINA} advanced client-trustlist add --ip-address "$IP"
done

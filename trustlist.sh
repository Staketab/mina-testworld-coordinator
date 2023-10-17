#!/bin/bash

. .env
WORKER_IP=${WORKER_IP}

IFS=',' read -ra IP_LIST <<< "$WORKER_IP"
for IP in "${IP_LIST[@]}"; do
    sudo docker run -ti --rm --entrypoint=mina ${MINA} advanced client-trustlist add --ip-address "$IP"
done

#!/bin/bash

WORKER_IP=${WORKER_IP}

IFS=',' read -ra IP_LIST <<< "$WORKER_IP"
for IP in "${IP_LIST[@]}"; do
    mina advanced client-trustlist add --ip-address "$IP"
done

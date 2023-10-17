#!/bin/bash

. .env

tmux new-session -d -s snark-workers

tmux send-keys -t snark-workers:0 "RAYON_NUM_THREADS=${RAYON_NUM_THREADS_WORKER} mina internal snark-worker --daemon-address ${COORDINATOR_IP}:8301 --proof-level full --shutdown-on-disconnect false" C-m

tmux new-window -t snark-workers
tmux new-window -t snark-workers
tmux new-window -t snark-workers

tmux send-keys -t snark-workers:1 "RAYON_NUM_THREADS=${RAYON_NUM_THREADS_WORKER} mina internal snark-worker --daemon-address ${COORDINATOR_IP}:8301 --proof-level full --shutdown-on-disconnect false" C-m
tmux send-keys -t snark-workers:2 "RAYON_NUM_THREADS=${RAYON_NUM_THREADS_WORKER} mina internal snark-worker --daemon-address ${COORDINATOR_IP}:8301 --proof-level full --shutdown-on-disconnect false" C-m

tmux select-window -t snark-workers:0
tmux setw -t snark-workers:0 -g monitor-activity on

tmux set-option -g status off
tmux set-option -g mouse on

echo -e "---------FINISHED---------"

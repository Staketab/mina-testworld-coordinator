include .env
COMPOSE_ALL_FILES := -f docker-compose.coordinator.yml -f docker-compose.node-exporter.yml
COMPOSE_COORDINATOR := -f docker-compose.coordinator.yml
COMPOSE_WORKER := -f docker-compose.worker.yml
COMPOSE_NODE_EXPORTER := -f docker-compose.node-exporter.yml
SERVICES := coordinator node-exporter

compose_v2_not_supported = $(shell command docker compose 2> /dev/null)
ifeq (,$(compose_v2_not_supported))
  DOCKER_COMPOSE_COMMAND = docker-compose
else
  DOCKER_COMPOSE_COMMAND = docker compose
endif

# --------------------------
.PHONY: keystore-libp2p keystore-uptime rule setup coord work nodex coord-down work-down nodex-down logs status

keystore-libp2p:
	sudo docker run -ti --rm --entrypoint=mina --volume ${HOME}/keys:/root/keys ${MINA} libp2p generate-keypair --privkey-path /root/keys/libp2p-keys

keystore-uptime:
	sudo docker run -ti --rm --entrypoint=mina-generate-keypair --volume ${HOME}/keys:/root/keys ${MINA} --privkey-path /root/keys/my-wallet

rule:
	sudo chmod 700 ${KEYS_PATH}
	sudo chmod 600 ${LIBP2P_KEYPATH}
	sudo chmod 600 ${KEYPATH}

setup:		    ## Generate LIB_P2P and UPTIME Keystores.
	@make keystore-libp2p
	@make keystore-uptime
	@make rule

coord:
	$(DOCKER_COMPOSE_COMMAND) ${COMPOSE_COORDINATOR} up -d

work:
	$(DOCKER_COMPOSE_COMMAND) ${COMPOSE_WORKER} up -d

nodex:
	$(DOCKER_COMPOSE_COMMAND) ${COMPOSE_NODE_EXPORTER} up -d

coord-down:
	$(DOCKER_COMPOSE_COMMAND) ${COMPOSE_COORDINATOR} down

work-down:
	$(DOCKER_COMPOSE_COMMAND) ${COMPOSE_WORKER} down

nodex-down:
	$(DOCKER_COMPOSE_COMMAND) ${COMPOSE_NODE_EXPORTER} down

logs:
	sudo docker logs --follow coordinator -f --tail 1000

worker-logs:
	$(DOCKER_COMPOSE_COMMAND) ${COMPOSE_WORKER} logs -f

status:
	sudo docker exec -it coordinator mina client status

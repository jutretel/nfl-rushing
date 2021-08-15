COMPOSE_PROJECT_NAME=nfl_rushing
COMPOSE_FILE?=docker-compose.yml
CONTAINER=$(COMPOSE_PROJECT_NAME)_$(COMPOSE_PROJECT_NAME)_1
COMPOSE=docker compose -p $(COMPOSE_PROJECT_NAME) -f $(COMPOSE_FILE)
BASE_DIR=$(PWD)

.PHONY: build
build:
	$(COMPOSE) build

.PHONY: up
up:
	$(COMPOSE) pull
	$(COMPOSE) up -d $(COMPOSE_PROJECT_NAME)

.PHONY: down
down:
	$(COMPOSE) down

.PHONY: stop
stop:
	$(COMPOSE) stop

.PHONY: bash
bash:
	docker exec -it $(CONTAINER) /bin/bash

.PHONY: logs
logs:
	docker logs -f $(CONTAINER)

.PHONY: init
init: build up logs

SHELL=/bin/bash -e

.DEFAULT_GOAL := help
.PHONY: *

-include .env

# Список используемых портов:
#   5432 - база данных PostgreSQL.
PORT_LIST='5432'

set-interface:
ifeq ($(shell grep "${INTERFACE}" .env 1>/dev/null 2>/dev/null && echo -n yes),yes)
else
	@PORT_LIST=${PORT_LIST} ./docker/scripts/ports-free-check.sh
	@$(eval INTERFACE := $(shell PORT_LIST=${PORT_LIST} ./docker/scripts/get-free-interface.sh))
	@echo "INTERFACE=${INTERFACE}" >> ./.env
endif

pg-up: set-interface
	@docker-compose stop postgres
	@INTERFACE=${INTERFACE} docker-compose up --detach postgres
	@echo -e "\tPostgreSQL: запущен на ${INTERFACE}:5432 (логин: postgres, пароль: demo)"

example-pg_range-up: pg-up ## Запустить пример с использованием int4range в PostgreSQL
	@cat ./docker/db/pg_range.sql | \
		docker-compose exec -T --user=postgres postgres psql -U postgres -d postgres

down: ## Остановить все контейнеры
	@docker-compose down

help: ## Справка
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install-docker: ## Установка docker на ubuntu 18/20/22LTS
ifeq ($(shell type -p docker 1>/dev/null && echo -n yes),yes)
	@echo 'docker уже установлен в' $(shell type -p docker) \
		'версия' $(shell docker version --format '{{print .Server.Version}}')
else
	@$(eval CODENAME := $(shell lsb_release -cs))
	@sudo apt install --yes apt-transport-https ca-certificates curl software-properties-common
	@curl --fail --silent --show-error --location https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	@sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu ${CODENAME} stable"
	@sudo apt-get update
	@sudo apt-get install --yes docker-ce
	@sudo groupadd --force docker
	@sudo usermod --append --groups docker ${USER}
	@newgrp docker
endif

install-docker-compose: ## Установка docker-compose на ubuntu 18/20/22LTS
ifeq ($(shell type -p docker-compose 1>/dev/null && echo -n yes),yes)
	@echo 'docker-compose уже установлен в' $(shell type -p docker-compose) \
		'версия' $(shell docker-compose version --short)
else
	sudo curl --location "https://github.com/docker/compose/releases/download/v2.14.0/docker-compose-linux-x86_64" --output /usr/bin/docker-compose
	sudo chmod +x /usr/bin/docker-compose
endif

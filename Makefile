deps:
	@which docker-compose

build: deps
	@docker-compose build

up: deps
	@docker-compose up -d 
	@docker-compose exec -u root master /code/setup.sh
	@docker-compose exec -u root slave /code/setup.sh
	@docker-compose exec -u root client /code/setup.sh
	
stop: deps
	@docker-compose stop

down: deps
	@docker-compose down -v

exec-master: deps
	@docker-compose exec -u root --privileged master bash

logs: deps
	@docker-compose logs -f

ps: deps
	@docker-compose ps

.PHONY: deps build up down exec logs ps

deps:
	@which docker-compose

build: deps
	@docker-compose build

up: deps
	@docker-compose up -d

down: deps
	@docker-compose down -v

exec: deps
	@docker-compose exec -u root --privileged master bash

logs: deps
	@docker-compose logs -f

.PHONY: deps build up down exec logs

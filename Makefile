.PHONY: up down build logs shell-backend shell-db health clean restart ps

up:
	docker compose up -d

down:
	docker compose down

build:
	docker compose build --no-cache

logs:
	docker compose logs -f

logs-backend:
	docker compose logs -f backend

logs-db:
	docker compose logs -f db

shell-backend:
	docker compose exec backend bash

shell-db:
	docker compose exec db psql -U sneha -d stegoshield

health:
	bash scripts/health_check.sh

restart:
	docker compose down && docker compose up -d

ps:
	docker compose ps

clean:
	docker compose down -v
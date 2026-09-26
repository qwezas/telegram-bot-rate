include .env
export

export PROJECT_ROOT=$(shell pwd)

env-up:
	@docker compose up -d bot-postgres

env-down:
	@docker compose down bot-postgres

env-cleanup:
	@read -p "Очистить все volume файлы окружения? Опасность потери данных. [y/N]: " ans; \
	if [ "$$ans" = "y" ]; then \
		docker compose down bot-postgres && \
		rm -rf out/pgdata && \
		echo "Файлы окружения очищены"; \
	else \
		echo "Очистка окружения отменена"; \
	fi

migrate-create:
	@if [ -z "$(seq)" ]; then \
		echo "Отсутствует необходимый параметр seq. Пример: make migrate-create seq=name"; \
		exit 1; \
	fi;
	@docker compose run --rm bot-postgres-migrate \
		create \
		-ext sql \
		-dir migrations \
		-seq "$(seq)"

migrate-up:
	@make migrate-action action=up

migrate-down:
	@make migrate-action action=down

migrate-action:
	@if [ -z "$(action)" ]; then \
		echo "Отсутствует необходимый параметр action."; \
		exit 1; \
	fi;
	@docker compose run --rm bot-postgres-migrate \
	-path /migrations \
	-database postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@bot-postgres:5432/${POSTGRES_DB}?sslmode=disable \
	"$(action)"

env-port-forward:
	@docker compose up -d port-forwarder

env-port-close:
	@docker compose down -d port-forwarder
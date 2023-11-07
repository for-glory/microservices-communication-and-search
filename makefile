ENV_FILE_NAME=.env
ENV_EXAMPLE_FILE_NAME=.env.example

MS_AD_API=ms-ad-api
MS_AD_API_PATH=./$(MS_AD_API)

MS_CONSUMER_API=ms-consumer-api
MS_CONSUMER_API_PATH=./$(MS_CONSUMER_API)

DOCKER_COMPOSE_RUN_NO_DEPS=docker compose run --no-deps
DOCKER_COMPOSE_RUN=docker compose run

COMPOSER_INSTALL=composer install
KEY_GENERATE=php artisan key:generate
ARTISAN_MIGRATE=php artisan migrate

.PHONY: prepare-env
prepare-env:
ifneq (!$(wildcard ./$(ENV_FILE_NAME)),)
	@cp ./$(ENV_EXAMPLE_FILE_NAME) ./$(ENV_FILE_NAME)
endif

ifneq (!$(wildcard $(MS_AD_API_PATH)/$(ENV_FILE_NAME)),)
	@cp $(MS_AD_API_PATH)/$(ENV_EXAMPLE_FILE_NAME) $(MS_AD_API_PATH)/$(ENV_FILE_NAME)
endif

ifneq (!$(wildcard $(MS_CONSUMER_API_PATH)/$(ENV_FILE_NAME)),)
	@cp $(MS_CONSUMER_API_PATH)/$(ENV_EXAMPLE_FILE_NAME) $(MS_CONSUMER_API_PATH)/$(ENV_FILE_NAME)
endif

.PHONY: composer-install
composer-install:
	@$(DOCKER_COMPOSE_RUN_NO_DEPS) $(MS_AD_API) $(COMPOSER_INSTALL)
	@$(DOCKER_COMPOSE_RUN_NO_DEPS) $(MS_CONSUMER_API) $(COMPOSER_INSTALL)
	@clear

generate-app-key:
	@$(DOCKER_COMPOSE_RUN_NO_DEPS) $(MS_AD_API) $(KEY_GENERATE)
	@$(DOCKER_COMPOSE_RUN_NO_DEPS) $(MS_CONSUMER_API) $(KEY_GENERATE)
	@clear

.PHONY: migrate
migrate:
	@$(DOCKER_COMPOSE_RUN) $(MS_AD_API) $(ARTISAN_MIGRATE)
	@$(DOCKER_COMPOSE_RUN) $(MS_CONSUMER_API) $(ARTISAN_MIGRATE)
	@clear

.PHONY: build
build:
	@docker compose build

	@make start

	@make composer-install

	@make generate-app-key

	@echo "Waiting 5 seconds before migrating DB"
	@sleep 5 && make migrate

	@clear

.PHONY: start
start:
	@docker compose up -d
	@echo "Application Up and kickin' !"

.PHONY: down
down:
	@docker compose down --remove-orphans
	@clear

.PHONY: chown
chown:
	@sudo chown -R $(USER):$(USER) .

.PHONY: pull-apis
pull-apis:
	@git submodule init
	@git submodule update

.PHONY: ad-fresh
ad-fresh:
	@docker exec -it ms-ad-api php artisan migrate:fresh

.PHONY: benchmark
benchmark:
	@docker exec -it ms-ad-api php artisan benchmark-user-create

.PHONY: consumer-fresh
consumer-fresh:
	@docker exec -it ms-consumer-api php artisan migrate:fresh

consume-user-created:
	@docker exec -it ms-consumer-api php artisan rabbitmq:consume:user-created

consume-user-updated:
	@docker exec -it ms-consumer-api php artisan rabbitmq:consume:user-updated

consume-user-deleted:
	@docker exec -it ms-consumer-api php artisan rabbitmq:consume:user-deleted
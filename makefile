ENV_FILE_NAME=.env
ENV_EXAMPLE_FILE_NAME=.env.example

MS_AD_API=ms-ad-api
MS_AD_API_PATH=./$(MS_AD_API)

MS_CONSUMER_API=ms-consumer-api
MS_CONSUMER_API_PATH=./$(MS_CONSUMER_API)

DOCKER_COMPOSE_RUN=docker compose run --no-deps

COMPOSER_INSTALL=composer install
KEY_GENERATE=php artisan key:generate
ARTISAN_MIGRATE=php artisan migrate

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

	@chown -R $(USER):$(USER) .

composer-install:
	@$(DOCKER_COMPOSE_RUN) $(MS_AD_API) $(COMPOSER_INSTALL)
	@$(DOCKER_COMPOSE_RUN) $(MS_CONSUMER_API) $(COMPOSER_INSTALL)

	@chown -R $(USER):$(USER) .

	@clear

generate-app-key:
	@$(DOCKER_COMPOSE_RUN) $(MS_AD_API) $(KEY_GENERATE)
	@$(DOCKER_COMPOSE_RUN) $(MS_CONSUMER_API) $(KEY_GENERATE)

migrate:
	@docker compose run $(MS_AD_API) $(ARTISAN_MIGRATE)
	@docker compose run $(MS_CONSUMER_API) $(ARTISAN_MIGRATE)
	@make down

build:
	@docker compose build

	@make composer-install
	@chown -R $(USER):$(USER) .

	@make generate-app-key

	@make migrate

	@clear

start:
	@docker compose up -d

down:
	@docker compose down --remove-orphans
	@clear
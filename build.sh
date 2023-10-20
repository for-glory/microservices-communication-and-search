#! /bin/bash

MS_AD_API="ms-ad-api"
MS_CONSUMER_API="ms-consumer-api"

DOCKER_EXEC="docker exec -t"

COMPOSER_INSTALL="composer install"
KEY_GENERATE="php artisan key:generate"

if [ -f ./.env ]; then
    cp .env.example .env
fi

if [ -f ./ms-ad-api/.env ]; then
    cp ./ms-ad-api/.env.example ./ms-ad-api/.env
fi

if [ -f ./ms-consumer-api/.env ]; then
    cp ./ms-consumer-api/.env.example ./ms-consumer-api/.env
fi


# Start containers
docker compose build

./start.sh

# Install composer packages
$DOCKER_EXEC $MS_AD_API $COMPOSER_INSTALL
$DOCKER_EXEC $MS_CONSUMER_API $COMPOSER_INSTALL

# Initiate app key
$DOCKER_EXEC $MS_AD_API $KEY_GENERATE
$DOCKER_EXEC $MS_CONSUMER_API $KEY_GENERATE

# Done
exec echo "-- Done --"

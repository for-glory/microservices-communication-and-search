# Microservices communication and search

This project was made entirely focused on Microservices + RabbitMQ study.
+ We have the usage of ElasticSearch for some smart findings

## Start up

### Requirements

- Docker
- Docker Compose

### Step by step

#### Pre-defined steps

1. Build
    ```bash
    ./build.sh
    ```
2. Start
    ```bash
    ./start.sh
    ```
3. Down
    ```bash
    ./down.sh
    ```

#### Manual steps
1. Enter the application folder
    ```bash
    cd microservices-communication-and-search
    ```
2. Copy the `.env.example`s to `.env`s
    ```bash
    cp .env.example .env
    ```
    ```bash
    cp ./ms-ad-api/.env.example ./ms-ad-api/.env
    ```
    ```bash
    cp ./ms-consumer-api/.env.example ./ms-consumer-api/.env
    ```
3. Start containers
    ```bash
    docker compose up -d
    ```
4. Install composer packages
    ```bash
    docker exec -t ms-ad-api composer install
    docker exec -t ms-consumer-api composer install
    ```
5. Initiate app key
    ```bash
    docker exec -t ms-ad-api php artisan key:generate
    docker exec -t ms-consumer-api php artisan key:generate
    ```
6. Enjoy :D

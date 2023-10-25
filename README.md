# Microservices communication and search

This project was made entirely focused on Microservices + RabbitMQ study.
+ We have the usage of ElasticSearch for some smart findings

## Clone

- Clone **with** submodules

    `git clone --recurse-submodules <reference-for-clone>`

## Start up

### Requirements

- Make
- Docker
- Docker Compose

### Step by step

1. Prepare envs
    ```bash
    make prepare-env
    ```
2. Build
    ```bash
    make build
    ```
3. Start
    ```bash
    make start
    ```

## Commands

- `make prepare-env`
- `make build`
- `make start`
- `make down`
- `make migrate`
- `make composer-install`
- `make generate-app-key`

## Packages

- [Laravel](https://laravel.com)
- [RabbitMQ](https://www.rabbitmq.com/)
- [RabbitMQ AMQP PHP](https://www.rabbitmq.com/tutorials/tutorial-one-php.html)
- [RabbitMQ Queue package](https://github.com/vyuldashev/laravel-queue-rabbitmq) (Não serviu, tive que implementar um :c)
- [Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/elasticsearch-intro.html)
    - [How-to on docker](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html)
    - [How-to with PHP](https://www.elastic.co/guide/en/elasticsearch/client/php-api/current/getting-started-php.html)

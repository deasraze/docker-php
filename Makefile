init: docker-down-clear \
	docker-clear \
	docker-pull docker-build docker-up \
	docker-init
up: docker-up
down: docker-down
restart: down up

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down --remove-orphans

docker-down-clear:
	docker-compose down -v --remove-orphans

docker-pull:
	docker-compose pull --include-deps

docker-build:
	docker-compose build

docker-clear:
	docker run --rm -v ${CURDIR}:/app -w /app alpine sh -c 'rm -rf var/cache/* var/log/*'
	docker run --rm -v ${CURDIR}:/app -w /app alpine sh -c 'rm -rf vendor'

docker-init: composer-install

composer-install:
	docker-compose run --rm php-cli composer install